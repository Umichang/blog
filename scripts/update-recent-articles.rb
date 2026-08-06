#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'fileutils'
require 'rexml/document'
require 'rbconfig'
require 'time'
require 'yaml'

# 新着記事欄、RSS、掲載日時データを同時に更新する。
# 使い方: ruby scripts/update-recent-articles.rb article.md [🟡]

RECENT_START = '<!-- recent-articles:start -->'
RECENT_END = '<!-- recent-articles:end -->'
VALID_DIFFICULTIES = %w[🟢 🟡 🔴].freeze
RECENT_LIMIT = 5
NON_ARTICLE_PATHS = %w[index.md ARTICLES.md CLAUDE.md].freeze
RECENT_LINE = /\A- \[(?<title>.+)\]\((?<path>[^)]+)\) (?<difficulty>#{VALID_DIFFICULTIES.join('|')})\z/

def abort_with_usage(message)
  warn message
  warn '使い方: ruby scripts/update-recent-articles.rb 記事ファイル.md [読みやすさ(🟢|🟡|🔴)]'
  exit 1
end

def fail_update(message)
  warn message
  exit 1
end

def yaml_document(path, label)
  YAML.safe_load(File.read(path, encoding: 'UTF-8'), aliases: false) || {}
rescue Psych::Exception => error
  fail_update("#{label} を読み込めません: #{error.message}")
end

def article_metadata(root, article_path)
  file = File.join(root, article_path)
  body = File.read(file, encoding: 'UTF-8')
  front_matter = body.match(/\A---\s*\n(.*?)\n---\s*\n/m)&.captures&.first
  fail_update("記事のフロントマターが見つかりません: #{article_path}") unless front_matter

  metadata = YAML.safe_load(front_matter, aliases: false) || {}
  title = body.each_line.find { |line| line.start_with?('# ') }&.sub(/^# /, '')&.strip
  description = metadata['description']&.strip
  fail_update("記事の H1 が見つかりません: #{article_path}") if title.nil? || title.empty?
  fail_update("記事の description が見つかりません: #{article_path}") if description.nil? || description.empty?

  { title: title, description: description }
rescue Psych::Exception => error
  fail_update("記事のフロントマターを読み込めません: #{article_path} (#{error.message})")
end

def parse_recent_entries(block)
  entries = block.lines(chomp: true).reject(&:empty?).map do |line|
    match = line.match(RECENT_LINE)
    fail_update("新着記事欄の形式が不正です: #{line}") unless match

    { title: match[:title], path: match[:path], difficulty: match[:difficulty] }
  end
  fail_update("新着記事欄は#{RECENT_LIMIT}件以下にしてください。") if entries.length > RECENT_LIMIT

  entries
end

def load_published_at(path)
  return {} unless File.file?(path)

  data = yaml_document(path, '掲載日時データ')
  articles = data['articles']
  fail_update('掲載日時データの articles が配列ではありません。') unless articles.is_a?(Array)

  articles.each_with_object({}) do |entry, result|
    fail_update('掲載日時データの項目が不正です。') unless entry.is_a?(Hash)

    article_path = entry['path']
    published_at = entry['published_at']
    fail_update('掲載日時データに path または published_at がありません。') unless article_path.is_a?(String) && published_at.is_a?(String)

    Time.iso8601(published_at)
    result[article_path] = published_at
  rescue ArgumentError
    fail_update("掲載日時の形式が不正です: #{published_at}")
  end
end

def build_site_url(config, article_path)
  url = config['url']&.sub(%r{/+\z}, '')
  baseurl = config['baseurl'].to_s.sub(%r{\A/+}, '').sub(%r{/+\z}, '')
  fail_update('_config.yaml の url が見つかりません。') if url.nil? || url.empty?

  [url, baseurl, article_path.sub(/\.md\z/, '.html')].reject(&:empty?).join('/')
end

def xml_text(text)
  CGI.escapeHTML(text.to_s)
end

def build_rss(config, entries, article_data, published_at)
  channel_link = [config.fetch('url').sub(%r{/+\z}, ''), config.fetch('baseurl', '').to_s.sub(%r{\A/+}, '').sub(%r{/+\z}, '')].reject(&:empty?).join('/') + '/'
  build_time = entries.map { |entry| Time.iso8601(published_at.fetch(entry[:path])) }.max
  items = entries.map do |entry|
    article = article_data.fetch(entry[:path])
    url = build_site_url(config, entry[:path])
    time = Time.iso8601(published_at.fetch(entry[:path]))

    <<~ITEM.chomp
          <item>
            <title>#{xml_text(article[:title])}</title>
            <link>#{xml_text(url)}</link>
            <guid isPermaLink="true">#{xml_text(url)}</guid>
            <description>#{xml_text(article[:description])}</description>
            <pubDate>#{xml_text(time.rfc2822)}</pubDate>
          </item>
    ITEM
  end

  indented_items = items.join("\n").lines.map { |line| "    #{line}" }.join

  <<~RSS
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>#{xml_text(config.fetch('title'))} の新着情報</title>
        <link>#{xml_text(channel_link)}</link>
        <description>#{xml_text(config.fetch('description'))}</description>
        <language>#{xml_text(config.fetch('lang', 'ja-JP'))}</language>
        <lastBuildDate>#{xml_text(build_time.rfc2822)}</lastBuildDate>
    #{indented_items}
      </channel>
    </rss>
  RSS
end

def validate_rss(xml, entries, article_data, config)
  document = REXML::Document.new(xml)
  items = document.elements.to_a('rss/channel/item')
  fail_update("RSSの記事数が#{RECENT_LIMIT}件ではありません。") unless items.length == entries.length

  items.zip(entries).each do |item, entry|
    expected_url = build_site_url(config, entry[:path])
    fail_update("RSSのタイトルが新着記事欄と一致しません: #{entry[:path]}") unless item.elements['title']&.text == article_data.fetch(entry[:path]).fetch(:title)
    fail_update("RSSのURLが新着記事欄と一致しません: #{entry[:path]}") unless item.elements['link']&.text == expected_url
    fail_update("RSSのdescriptionが見つかりません: #{entry[:path]}") if item.elements['description']&.text.to_s.empty?
  end
rescue REXML::ParseException => error
  fail_update("RSSを生成できません: #{error.message}")
end

def write_if_changed(path, contents)
  return false if File.file?(path) && File.read(path, encoding: 'UTF-8') == contents

  FileUtils.mkdir_p(File.dirname(path))
  temporary_path = "#{path}.tmp-#{Process.pid}"
  File.write(temporary_path, contents, encoding: 'UTF-8')
  File.rename(temporary_path, path)
  true
ensure
  File.delete(temporary_path) if temporary_path && File.exist?(temporary_path)
end

def sync_notion_articles(root)
  script = File.join(root, 'scripts', 'sync-notion-articles.rb')
  return true if system(RbConfig.ruby, script)

  warn 'Notion記事台帳の同期に失敗しました。Notionの設定を確認し、同じ公開コマンドを再実行してください。'
  false
end

article_path, difficulty = ARGV
abort_with_usage('引数は記事ファイルと、必要なら読みやすさです。') unless (1..2).cover?(ARGV.length)
abort_with_usage("読みやすさは #{VALID_DIFFICULTIES.join('、')} のいずれかです。") if difficulty && !VALID_DIFFICULTIES.include?(difficulty)
abort_with_usage('記事ファイルは Markdown ファイルで指定してください。') unless article_path.end_with?('.md')

root = File.expand_path('..', __dir__)
article_file = File.expand_path(article_path, root)
abort_with_usage('リポジトリ外のファイルは指定できません。') unless article_file.start_with?("#{root}/")
article_path = article_file.delete_prefix("#{root}/")
abort_with_usage("#{article_path} は新着記事に指定できません。") if NON_ARTICLE_PATHS.include?(article_path)
abort_with_usage("記事ファイルが見つかりません: #{article_path}") unless File.file?(article_file)

index_file = File.join(root, 'index.md')
index = File.read(index_file, encoding: 'UTF-8')
unless difficulty
  matched_difficulties = index.scan(/^- \[.*?\]\(#{Regexp.escape(article_path)}\) (#{VALID_DIFFICULTIES.join('|')})\s*$/).flatten.uniq
  abort_with_usage('通常の分類へのリンクが見つかりません。読みやすさを明示してください。') if matched_difficulties.empty?
  abort_with_usage('通常の分類で読みやすさが一致しません。読みやすさを明示してください。') if matched_difficulties.length > 1

  difficulty = matched_difficulties.first
end

pattern = /(#{Regexp.escape(RECENT_START)}\n)(.*?)(\n\n#{Regexp.escape(RECENT_END)})/m
match = index.match(pattern)
abort_with_usage('index.md の新着記事マーカーが見つかりません。') unless match

previous_entries = parse_recent_entries(match[2])
article = article_metadata(root, article_path)
existing_entries = previous_entries.reject { |entry| entry[:path] == article_path }
recent_entries = [{ title: article[:title], path: article_path, difficulty: difficulty }, *existing_entries].first(RECENT_LIMIT)
replacement = "#{match[1]}#{recent_entries.map { |entry| "- [#{entry[:title]}](#{entry[:path]}) #{entry[:difficulty]}" }.join("\n")}#{match[3]}"
updated_index = index.sub(pattern, replacement)

article_data = recent_entries.each_with_object({}) do |entry, result|
  metadata = article_metadata(root, entry[:path])
  fail_update("新着記事欄のタイトルがH1と一致しません: #{entry[:path]}") unless entry[:title] == metadata[:title]

  result[entry[:path]] = metadata
end

published_at_file = File.join(root, '_data', 'recent-articles.yml')
stored_published_at = load_published_at(published_at_file)
now = Time.now.utc.iso8601
first_run = !File.file?(published_at_file)
article_moved_to_top = previous_entries.first&.fetch(:path) != article_path
published_at = recent_entries.each_with_object({}) do |entry, result|
  result[entry[:path]] = if first_run || (entry[:path] == article_path && article_moved_to_top)
                             now
                           else
                             stored_published_at.fetch(entry[:path], now)
                           end
end

rss_config = yaml_document(File.join(root, '_config.yaml'), '_config.yaml')
rss = build_rss(rss_config, recent_entries, article_data, published_at)
validate_rss(rss, recent_entries, article_data, rss_config)
published_at_yaml = YAML.dump('articles' => recent_entries.map { |entry| { 'path' => entry[:path], 'published_at' => published_at.fetch(entry[:path]) } })

changed_files = []
changed_files << 'index.md' if write_if_changed(index_file, updated_index)
changed_files << '_data/recent-articles.yml' if write_if_changed(published_at_file, published_at_yaml)
changed_files << 'rss.xml' if write_if_changed(File.join(root, 'rss.xml'), rss)

if changed_files.empty?
  puts '新着記事、掲載日時データ、RSSは変更されませんでした。'
else
  puts "更新しました: #{changed_files.join('、')}"
end

fail_update('Notion記事台帳を同期できませんでした。') unless sync_notion_articles(root)
