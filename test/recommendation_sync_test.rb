# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require_relative '../scripts/lib/recommendation_sync'

class RecommendationSyncTest < Minitest::Test
  class FakeNotion
    attr_reader :created_pages, :updated_pages

    def initialize(article_pages: [], post_pages: [])
      @article_pages = article_pages
      @post_pages = post_pages
      @created_pages = []
      @updated_pages = []
    end

    def query_all(data_source_id)
      data_source_id == 'articles' ? @article_pages : @post_pages
    end

    def create_page(data_source_id, properties)
      page = { 'id' => "created-#{@created_pages.length + 1}", 'properties' => properties }
      @created_pages << [data_source_id, page]
      @post_pages << page if data_source_id == 'posts'
      page
    end

    def update_page(page_id, properties)
      @updated_pages << [page_id, properties]
    end
  end

  class FailingNotion < FakeNotion
    def create_page(data_source_id, properties)
      raise RecommendationSync::ApiError.new(503, 'temporary failure') unless created_pages.empty?

      super
    end
  end

  def with_catalog
    Dir.mktmpdir do |directory|
      File.write(File.join(directory, '_config.yaml'), "url: https://umichang.github.io\nbaseurl: /blog\n", encoding: 'UTF-8')
      File.write(File.join(directory, 'one.md'), "---\ndescription: one\n---\n# one\n", encoding: 'UTF-8')
      File.write(File.join(directory, 'two.md'), "---\ndescription: two\n---\n# two\n", encoding: 'UTF-8')
      File.write(File.join(directory, 'index.md'), <<~MARKDOWN, encoding: 'UTF-8')
        ## 🆕 新着記事
        - [記事一](one.md) 🟢

        ## 🎮 設計
        ### 🎨 UI
        - [記事一](one.md) 🟢
        - [記事二](two.md) 🟡
      MARKDOWN
      yield directory
    end
  end

  def test_catalog_deduplicates_articles_and_uses_category_links
    with_catalog do |directory|
      articles = RecommendationSync::ArticleCatalog.new(directory).articles

      assert_equal %w[one.md two.md], articles.map(&:path)
      assert_equal ['🎨 UI'], articles.first.categories
      assert_equal 'https://umichang.github.io/blog/one.html', articles.first.url
      assert_equal '🟡', articles.last.difficulty
    end
  end

  def test_archive_reads_blog_posts_and_normalizes_markdown_urls
    Dir.mktmpdir do |directory|
      data = File.join(directory, 'data')
      Dir.mkdir(data)
      File.write(File.join(data, 'tweets.js'), <<~JSON, encoding: 'UTF-8')
        window.YTD.tweets.part0 = [
          {"tweet":{"id":"10","full_text":"おすすめ https://t.co/abc","created_at":"Wed Oct 10 20:19:24 +0000 2018","entities":{"urls":[{"url":"https://t.co/abc","expanded_url":"https://umichang.github.io/blog/one.md"}]}}},
          {"tweet":{"id":"11","full_text":"別の投稿 https://example.com/","created_at":"Wed Oct 10 20:19:24 +0000 2018","entities":{"urls":[{"expanded_url":"https://example.com/"}]}}}
        ];
      JSON

      posts = RecommendationSync::XArchive.new(directory).posts
      assert_equal ['10'], posts.map(&:id)
      assert_equal 'https://umichang.github.io/blog/one.html', RecommendationSync.normalized_blog_url(posts.first.urls.first)
    end
  end

  def test_catalog_records_series_subheading_separately_from_category
    Dir.mktmpdir do |directory|
      File.write(File.join(directory, '_config.yaml'), "url: https://umichang.github.io\nbaseurl: /blog\n", encoding: 'UTF-8')
      %w[one two three].each do |name|
        File.write(File.join(directory, "#{name}.md"), "---\ndescription: #{name}\n---\n# #{name}\n", encoding: 'UTF-8')
      end
      File.write(File.join(directory, 'index.md'), <<~MARKDOWN, encoding: 'UTF-8')
        ## 🎮 設計
        ### 🎨 UI
        - [記事一](one.md) 🟢

        #### 🏯 連載
        - 第1回：[記事二](two.md) 🟢
        - 番外編：[記事三](three.md) 🟡

        ### 🔊 音
      MARKDOWN

      articles = RecommendationSync::ArticleCatalog.new(directory).articles.to_h { |article| [article.path, article] }

      assert_equal ['🎨 UI'], articles.fetch('two.md').categories
      assert_equal '🏯 連載', articles.fetch('two.md').series
      assert_equal '🟡', articles.fetch('three.md').difficulty
      assert_equal '🏯 連載', articles.fetch('three.md').series
      assert_nil articles.fetch('one.md').series
      assert_equal '記事二', articles.fetch('two.md').title
    end
  end

  def test_catalog_ignores_numbered_links_under_headings_missing_from_ledger
    with_catalog do |directory|
      FileUtils.mkdir_p(File.join(directory, 'data'))
      File.write(File.join(directory, 'data', 'article-categories.yml'), <<~YAML, encoding: 'UTF-8')
        schema_version: 1
        categories:
          - slug: ui
            heading: "🎨 UI"
            parent_group: "🎮 設計"
            display_order: 10
      YAML
      index = File.join(directory, 'index.md')
      File.write(index, File.read(index, encoding: 'UTF-8').sub("## 🎮 設計", "## ⏰ 特集：連載\n- 第1回：[記事二](two.md) 🟡\n\n## 🎮 設計"), encoding: 'UTF-8')

      articles = RecommendationSync::ArticleCatalog.new(directory).articles.to_h { |article| [article.path, article] }

      assert_equal ['🎨 UI'], articles.fetch('two.md').categories
    end
  end

  def test_sync_articles_adds_missing_series_property_and_writes_series
    with_catalog do |directory|
      config = Struct.new(:articles_data_source_id, :posts_data_source_id).new('articles', 'posts')
      client = FakeNotion.new
      added = []
      client.define_singleton_method(:retrieve_data_source) { |_id| { 'properties' => {} } }
      client.define_singleton_method(:update_data_source) { |id, properties| added << [id, properties] }

      RecommendationSync::Synchronizer.new(client, config).sync_articles(RecommendationSync::ArticleCatalog.new(directory))

      assert_equal [['articles', { 'シリーズ' => { 'rich_text' => {} } }]], added
      properties = client.created_pages.first.last.fetch('properties')
      assert_equal [], properties.dig('シリーズ', 'rich_text')
    end
  end

  def test_sync_articles_skips_pages_whose_values_are_unchanged
    with_catalog do |directory|
      config = Struct.new(:articles_data_source_id, :posts_data_source_id).new('articles', 'posts')
      catalog = RecommendationSync::ArticleCatalog.new(directory)
      synchronizer = RecommendationSync::Synchronizer.new(FakeNotion.new, config)
      current = catalog.articles.map do |article|
        properties = synchronizer.send(:article_properties, article).transform_values do |value|
          next value unless value.key?('title') || value.key?('rich_text')

          key = value.key?('title') ? 'title' : 'rich_text'
          { key => value[key].map { |entry| { 'plain_text' => entry.dig('text', 'content') } } }
        end
        { 'id' => "page-#{article.path}", 'properties' => properties }
      end
      current.last['properties']['カテゴリ'] = { 'rich_text' => [{ 'plain_text' => '旧分類' }] }
      client = FakeNotion.new(article_pages: current)
      client.define_singleton_method(:retrieve_data_source) { |_id| { 'properties' => { 'シリーズ' => {} } } }

      summary, = RecommendationSync::Synchronizer.new(client, config).sync_articles(catalog)

      assert_equal({ created: 0, updated: 1, unchanged: 1 }, summary)
      assert_equal 'page-two.md', client.updated_pages.first.first
    end
  end

  def test_client_retries_after_rate_limit
    responses = [
      Struct.new(:code, :body) { def [](_name) = '0.5' }.new('429', '{"message":"rate limited"}'),
      Struct.new(:code, :body) { def [](_name) = nil; def is_a?(klass) = klass == Net::HTTPSuccess || super }.new('200', '{"ok":true}')
    ]
    waits = []
    original = Net::HTTP.method(:start)
    Net::HTTP.define_singleton_method(:start) { |*_args, **_options, &_block| responses.shift }
    begin
      client = RecommendationSync::NotionClient.new('token', sleeper: ->(seconds) { waits << seconds })
      assert_equal({ 'ok' => true }, client.retrieve_data_source('articles'))
      assert_equal [0.5], waits
    ensure
      Net::HTTP.define_singleton_method(:start, original)
    end
  end

  def test_import_is_idempotent_and_marks_unmatched_posts_for_review
    config = Struct.new(:articles_data_source_id, :posts_data_source_id).new('articles', 'posts')
    existing = {
      'id' => 'old-post',
      'properties' => { 'X投稿ID' => { 'rich_text' => [{ 'plain_text' => '10' }] }
      }
    }
    client = FakeNotion.new(post_pages: [existing])
    synchronizer = RecommendationSync::Synchronizer.new(client, config)
    posts = [
      RecommendationSync::Post.new(id: '10', text: 'existing', created_at: '2026-01-01T00:00:00Z', urls: ['https://umichang.github.io/blog/one.html']),
      RecommendationSync::Post.new(id: '11', text: 'unknown', created_at: '2026-01-02T00:00:00Z', urls: ['https://umichang.github.io/blog/missing.html'])
    ]

    summary = synchronizer.import_posts(posts, { 'https://umichang.github.io/blog/one.html' => 'article-1' })

    assert_equal({ imported: 1, skipped: 1, needs_review: 1 }, summary)
    created = client.created_pages.last.last.fetch('properties')
    assert_equal '要確認', created.dig('状態', 'select', 'name')
    refute created.dig('紹介済み', 'checkbox')
    assert_empty created.dig('記事', 'relation')
  end

  def test_import_reports_how_many_rows_were_created_before_an_api_failure
    config = Struct.new(:articles_data_source_id, :posts_data_source_id).new('articles', 'posts')
    synchronizer = RecommendationSync::Synchronizer.new(FailingNotion.new, config)
    posts = %w[12 13].map do |id|
      RecommendationSync::Post.new(id: id, text: 'post', created_at: '2026-01-01T00:00:00Z', urls: ['https://umichang.github.io/blog/one.html'])
    end

    error = assert_raises(RecommendationSync::Error) do
      synchronizer.import_posts(posts, { 'https://umichang.github.io/blog/one.html' => 'article-1' })
    end

    assert_match '新規 1件、既存 0件', error.message
    assert_match 'HTTP 503', error.message
  end
end
