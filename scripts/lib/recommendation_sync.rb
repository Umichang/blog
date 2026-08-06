# frozen_string_literal: true

require 'json'
require 'net/http'
require 'open3'
require 'pathname'
require 'time'
require 'uri'
require 'yaml'

module RecommendationSync
  NOTION_VERSION = '2026-03-11'
  DEFAULT_CONFIG_PATH = '.notion-recommendation-sync.yml'
  DIFFICULTIES = %w[🟢 🟡 🔴].freeze

  class Error < StandardError; end
  class ApiError < Error
    attr_reader :status

    def initialize(status, message)
      @status = status
      super("Notion API (HTTP #{status}): #{message}")
    end
  end

  Article = Struct.new(:title, :path, :url, :difficulty, :categories, keyword_init: true)
  Post = Struct.new(:id, :text, :created_at, :urls, keyword_init: true)

  module Text
    module_function

    def rich_text(value)
      return [] if value.nil? || value.empty?

      [{ 'type' => 'text', 'text' => { 'content' => value } }]
    end

    def title(value)
      { 'title' => rich_text(value) }
    end

    def value(property)
      return '' unless property

      values = property.fetch('title', property.fetch('rich_text', []))
      values.map { |entry| entry['plain_text'] || entry.dig('text', 'content').to_s }.join
    end
  end

  class Config
    attr_reader :path, :articles_data_source_id, :posts_data_source_id

    def initialize(path)
      @path = Pathname(path)
      return unless @path.file?

      data = YAML.safe_load(@path.read(encoding: 'UTF-8'), aliases: false) || {}
      @articles_data_source_id = data['articles_data_source_id']
      @posts_data_source_id = data['posts_data_source_id']
    rescue Psych::Exception => error
      raise Error, "設定ファイルを読み込めません: #{error.message}"
    end

    def configured?
      !articles_data_source_id.to_s.empty? && !posts_data_source_id.to_s.empty?
    end

    def write!(articles_data_source_id:, posts_data_source_id:)
      content = YAML.dump(
        'articles_data_source_id' => articles_data_source_id,
        'posts_data_source_id' => posts_data_source_id
      )
      path.write(content, encoding: 'UTF-8')
      @articles_data_source_id = articles_data_source_id
      @posts_data_source_id = posts_data_source_id
    end
  end

  class ArticleCatalog
    NON_CATEGORY_HEADINGS = ['📌 まず読む記事', '🆕 新着記事'].freeze
    LINK = /^- \[(?<title>.+?)\]\((?<path>[^)]+\.md)\)(?:\s+(?<difficulty>🟢|🟡|🔴))?\s*$/.freeze

    def initialize(root)
      @root = Pathname(root)
    end

    def articles
      config = YAML.safe_load((@root / '_config.yaml').read(encoding: 'UTF-8'), aliases: false) || {}
      base_url = [config.fetch('url').sub(%r{/+\z}, ''), config.fetch('baseurl', '').to_s.sub(%r{\A/+|/+\z}, '')].reject(&:empty?).join('/')
      categories = {}
      titles = {}
      difficulties = {}
      headings = {}

      (@root / 'index.md').each_line(encoding: 'UTF-8') do |line|
        if (heading = line.match(/\A(?<marks>\#{2,4})\s+(?<title>.+?)\s*\z/))
          level = heading[:marks].length
          headings.delete_if { |existing_level, _| existing_level >= level }
          headings[level] = heading[:title]
          next
        end

        match = line.match(LINK)
        next unless match

        path = match[:path]
        next unless local_article?(path)

        titles[path] ||= match[:title]
        difficulties[path] ||= match[:difficulty]
        category = headings[headings.keys.max]
        categories[path] ||= []
        categories[path] << category if category && !NON_CATEGORY_HEADINGS.include?(category) && !categories[path].include?(category)
      end

      titles.map do |path, title|
        Article.new(
          title: title,
          path: path,
          url: "#{base_url}/#{path.sub(/\.md\z/, '.html')}",
          difficulty: difficulties[path],
          categories: categories.fetch(path, [])
        )
      end.sort_by(&:path)
    end

    private

    def local_article?(path)
      candidate = (@root / path).expand_path
      candidate.to_s.start_with?("#{@root.expand_path}/") && candidate.file?
    end
  end

  class XArchive
    def initialize(path)
      @path = Pathname(path)
    end

    def posts
      tweet_documents.flat_map { |document| parse_document(document) }.uniq { |post| post.id }
    end

    private

    def tweet_documents
      if @path.directory?
        files = Dir[(@path / 'data' / 'tweets*.js').to_s] + Dir[(@path / 'data' / 'tweets*.json').to_s]
        raise Error, "Xアーカイブ内に data/tweets*.js が見つかりません: #{@path}" if files.empty?

        files.sort.map { |file| File.read(file, encoding: 'UTF-8') }
      elsif @path.file? && @path.extname.downcase == '.zip'
        list, status = Open3.capture2('unzip', '-Z1', @path.to_s)
        raise Error, "XアーカイブZIPを読み込めません: #{@path}" unless status.success?

        entries = list.lines(chomp: true).grep(%r{\Adata/tweets.*\.(?:js|json)\z})
        raise Error, "Xアーカイブ内に data/tweets*.js が見つかりません: #{@path}" if entries.empty?

        entries.sort.map do |entry|
          output, extract_status = Open3.capture2('unzip', '-p', @path.to_s, entry)
          raise Error, "XアーカイブZIPから #{entry} を読み出せません" unless extract_status.success?

          output
        end
      else
        raise Error, "XアーカイブのZIPまたは展開済みディレクトリを指定してください: #{@path}"
      end
    end

    def parse_document(document)
      first = document.index('[')
      last = document.rindex(']')
      raise Error, 'Xアーカイブの投稿JSONを解析できません。' unless first && last && first < last

      JSON.parse(document[first..last]).filter_map do |entry|
        tweet = entry['tweet'] || entry
        id = tweet['id'].to_s
        text = tweet['full_text'] || tweet['text']
        next if id.empty? || text.to_s.empty?

        urls = Array(tweet.dig('entities', 'urls')).flat_map { |url| [url['expanded_url'], url['url']] }.compact
        urls.concat(text.scan(%r{https?://[^\s]+}i))
        urls.select! { |url| RecommendationSync.normalized_blog_url(url) }
        next if urls.empty?

        Post.new(id: id, text: text, created_at: Time.parse(tweet.fetch('created_at')).utc.iso8601, urls: urls)
      end
    rescue JSON::ParserError, KeyError, ArgumentError => error
      raise Error, "Xアーカイブの投稿を解析できません: #{error.message}"
    end
  end

  def self.normalized_blog_url(url)
    parsed = URI.parse(url)
    return unless parsed.is_a?(URI::HTTP) && parsed.host&.casecmp?('umichang.github.io') && parsed.path.start_with?('/blog/')

    path = URI::DEFAULT_PARSER.unescape(parsed.path).sub(/\.md\z/i, '.html')
    path = "#{path}.html" unless File.extname(path) == '.html'
    "https://umichang.github.io#{path}"
  rescue URI::InvalidURIError
    nil
  end

  class NotionClient
    API_URI = URI('https://api.notion.com/v1/')

    def initialize(token, base_uri: API_URI)
      raise Error, 'NOTION_TOKEN を設定してください。' if token.to_s.empty?

      @token = token
      @base_uri = base_uri
    end

    def create_database(parent_page_id, title, properties)
      request(:post, 'databases', {
        'parent' => { 'type' => 'page_id', 'page_id' => parent_page_id },
        'title' => Text.rich_text(title),
        'initial_data_source' => { 'title' => Text.rich_text(title), 'properties' => properties }
      })
    end

    def database_data_source_id(database_id)
      database = request(:get, "databases/#{database_id}")
      database.fetch('data_sources').fetch(0).fetch('id')
    rescue KeyError
      raise Error, "NotionデータベースのデータソースIDを取得できません: #{database_id}"
    end

    def update_data_source(data_source_id, properties)
      request(:patch, "data_sources/#{data_source_id}", { 'properties' => properties })
    end

    def retrieve_data_source(data_source_id)
      request(:get, "data_sources/#{data_source_id}")
    end

    def query_all(data_source_id)
      results = []
      cursor = nil
      loop do
        body = { 'page_size' => 100 }
        body['start_cursor'] = cursor if cursor
        response = request(:post, "data_sources/#{data_source_id}/query", body)
        results.concat(response.fetch('results'))
        break unless response['has_more']

        cursor = response.fetch('next_cursor')
      end
      results
    end

    def create_page(data_source_id, properties)
      request(:post, 'pages', { 'parent' => { 'type' => 'data_source_id', 'data_source_id' => data_source_id }, 'properties' => properties })
    end

    def update_page(page_id, properties)
      request(:patch, "pages/#{page_id}", { 'properties' => properties })
    end

    private

    def request(method, path, body = nil)
      uri = @base_uri.dup
      uri.path = "#{@base_uri.path.sub(%r{/$}, '')}/#{path}"
      request = Net::HTTP.const_get(method.to_s.capitalize).new(uri)
      request['Authorization'] = "Bearer #{@token}"
      request['Notion-Version'] = NOTION_VERSION
      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(body) if body

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
      parsed = JSON.parse(response.body)
      return parsed if response.is_a?(Net::HTTPSuccess)

      raise ApiError.new(response.code, parsed['message'] || response.body)
    rescue JSON::ParserError
      raise ApiError.new(response&.code || 'unknown', response&.body || 'JSONでない応答')
    end
  end

  class Setup
    def initialize(client, parent_page_id, config)
      @client = client
      @parent_page_id = parent_page_id
      @config = config
    end

    def run
      raise Error, 'NOTION_PARENT_PAGE_ID を設定してください。' if @parent_page_id.to_s.empty?
      raise Error, "設定ファイルがすでにあります: #{@config.path}" if @config.configured?

      articles_database = @client.create_database(@parent_page_id, '記事', article_properties)
      articles_id = @client.database_data_source_id(articles_database.fetch('id'))
      posts_database = @client.create_database(@parent_page_id, 'おすすめ投稿履歴', post_properties)
      posts_id = @client.database_data_source_id(posts_database.fetch('id'))

      @client.update_data_source(posts_id, {
        '記事' => { 'relation' => { 'data_source_id' => articles_id, 'dual_property' => { 'synced_property_name' => 'おすすめ投稿' } } }
      })

      # 双方向RelationでNotionが作成した逆向きプロパティを取得してからRollupを定義する。
      article_source = @client.retrieve_data_source(articles_id)
      post_source = @client.retrieve_data_source(posts_id)
      relation_id = article_source.fetch('properties').fetch('おすすめ投稿').fetch('id')
      post_date_id = post_source.fetch('properties').fetch('投稿日').fetch('id')
      posted_id = post_source.fetch('properties').fetch('紹介済み').fetch('id')
      @client.update_data_source(articles_id, {
        '紹介回数' => { 'rollup' => rollup(relation_id, 'おすすめ投稿', posted_id, '紹介済み', 'checked') },
        '最終紹介日' => { 'rollup' => rollup(relation_id, 'おすすめ投稿', post_date_id, '投稿日', 'latest_date') }
      })
      @config.write!(articles_data_source_id: articles_id, posts_data_source_id: posts_id)
    end

    private

    def article_properties
      {
        '記事名' => { 'title' => {} },
        '記事URL' => { 'url' => {} },
        'Markdownパス' => { 'rich_text' => {} },
        '難易度' => { 'select' => { 'options' => DIFFICULTIES.map { |name| { 'name' => name } } } },
        'カテゴリ' => { 'rich_text' => {} },
        '紹介除外' => { 'checkbox' => {} }
      }
    end

    def post_properties
      {
        '投稿' => { 'title' => {} },
        '本文' => { 'rich_text' => {} },
        '状態' => { 'select' => { 'options' => [{ 'name' => '下書き', 'color' => 'yellow' }, { 'name' => '投稿済み', 'color' => 'green' }, { 'name' => '要確認', 'color' => 'red' }] } },
        '投稿日' => { 'date' => {} },
        '紹介済み' => { 'checkbox' => {} },
        'X URL' => { 'url' => {} },
        'X投稿ID' => { 'rich_text' => {} },
        '登録元' => { 'select' => { 'options' => [{ 'name' => '手動' }, { 'name' => 'アーカイブ' }] } }
      }
    end

    def rollup(relation_id, relation_name, property_id, property_name, function)
      {
        'relation_property_id' => relation_id,
        'relation_property_name' => relation_name,
        'rollup_property_id' => property_id,
        'rollup_property_name' => property_name,
        'function' => function
      }
    end
  end

  class Synchronizer
    def initialize(client, config)
      @client = client
      @config = config
    end

    def sync_articles(catalog)
      summary = { created: 0, updated: 0 }
      existing = @client.query_all(@config.articles_data_source_id)
      by_path = existing.each_with_object({}) do |page, result|
        path = Text.value(page.fetch('properties')['Markdownパス'])
        result[path] = page unless path.empty?
      end

      pages_by_url = {}
      catalog.articles.each do |article|
        properties = article_properties(article)
        page = by_path[article.path]
        if page
          @client.update_page(page.fetch('id'), properties)
          summary[:updated] += 1
          pages_by_url[article.url] = page.fetch('id')
        else
          created = @client.create_page(@config.articles_data_source_id, properties.merge('紹介除外' => { 'checkbox' => false }))
          summary[:created] += 1
          pages_by_url[article.url] = created.fetch('id')
        end
      end
      [summary, pages_by_url]
    rescue ApiError => error
      raise Error, "記事同期は途中で失敗しました（新規 #{summary[:created] || 0}件、更新 #{summary[:updated] || 0}件）: #{error.message}"
    end

    def import_posts(posts, pages_by_url)
      summary = { imported: 0, skipped: 0, needs_review: 0 }
      existing = @client.query_all(@config.posts_data_source_id)
      ids = existing.each_with_object({}) do |page, result|
        id = Text.value(page.fetch('properties')['X投稿ID'])
        result[id] = true unless id.empty?
      end

      posts.each do |post|
        if ids[post.id]
          summary[:skipped] += 1
          next
        end

        article_ids = post.urls.filter_map { |url| pages_by_url[RecommendationSync.normalized_blog_url(url)] }.uniq
        needs_review = article_ids.empty?
        @client.create_page(@config.posts_data_source_id, post_properties(post, article_ids, needs_review))
        summary[:imported] += 1
        summary[:needs_review] += 1 if needs_review
      end
      summary
    rescue ApiError => error
      raise Error, "おすすめ投稿の取り込みは途中で失敗しました（新規 #{summary[:imported] || 0}件、既存 #{summary[:skipped] || 0}件）: #{error.message}"
    end

    private

    def article_properties(article)
      {
        '記事名' => Text.title(article.title),
        '記事URL' => { 'url' => article.url },
        'Markdownパス' => { 'rich_text' => Text.rich_text(article.path) },
        '難易度' => { 'select' => article.difficulty ? { 'name' => article.difficulty } : nil },
        'カテゴリ' => { 'rich_text' => Text.rich_text(article.categories.join('／')) }
      }
    end

    def post_properties(post, article_ids, needs_review)
      {
        '投稿' => Text.title("おすすめ投稿 #{post.id}"),
        '本文' => { 'rich_text' => Text.rich_text(post.text) },
        '状態' => { 'select' => { 'name' => needs_review ? '要確認' : '投稿済み' } },
        '投稿日' => { 'date' => { 'start' => post.created_at } },
        '紹介済み' => { 'checkbox' => !needs_review },
        'X URL' => { 'url' => "https://x.com/i/web/status/#{post.id}" },
        'X投稿ID' => { 'rich_text' => Text.rich_text(post.id) },
        '登録元' => { 'select' => { 'name' => 'アーカイブ' } },
        '記事' => { 'relation' => article_ids.map { |id| { 'id' => id } } }
      }
    end
  end
end
