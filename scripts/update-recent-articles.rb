#!/usr/bin/env ruby
# frozen_string_literal: true

# 新着記事欄に記事を先頭追加する。既存記事を指定すれば、掲載時点を新着として扱う。
# 使い方: ruby scripts/update-recent-articles.rb article.md [🟡]

RECENT_START = '<!-- recent-articles:start -->'
RECENT_END = '<!-- recent-articles:end -->'
VALID_DIFFICULTIES = %w[🟢 🟡 🔴].freeze
RECENT_LIMIT = 5
NON_ARTICLE_PATHS = %w[index.md ARTICLES.md CLAUDE.md].freeze

def abort_with_usage(message)
  warn message
  warn '使い方: ruby scripts/update-recent-articles.rb 記事ファイル.md [読みやすさ(🟢|🟡|🔴)]'
  exit 1
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

title = File.foreach(article_file, encoding: 'UTF-8').find { |line| line.start_with?('# ') }&.sub(/^# /, '')&.strip
abort_with_usage("記事の H1 が見つかりません: #{article_path}") if title.nil? || title.empty?

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

existing = match[2].lines(chomp: true)
existing.reject! { |line| line.include?("](#{article_path})") }
recent = ["- [#{title}](#{article_path}) #{difficulty}", *existing.reject(&:empty?)].first(RECENT_LIMIT)
replacement = "#{match[1]}#{recent.join("\n")}#{match[3]}"
updated = index.sub(pattern, replacement)

if updated == index
  warn '新着記事欄は変更されませんでした。'
else
  File.write(index_file, updated, encoding: 'UTF-8')
  puts "新着記事欄を更新しました: #{article_path}"
end
