#!/usr/bin/env ruby
# frozen_string_literal: true

# おすすめ記事のXポストをチャットから扱うための補助（管理画面なし）。
# Notion「おすすめ投稿履歴」への書き込みはこのスクリプトでは行わない（チャット側でNotionに書く）。
#
# 使い方:
#   ruby scripts/recommend-x.rb fetch XのポストURL      既存ポストの本文・日時・ブログURLをJSONで出す（認証不要・無料）
#   ruby scripts/recommend-x.rb check 本文ファイル      投稿前の点検（文字数・記事URL・公開確認）をJSONで出す
#   ruby scripts/recommend-x.rb post 本文ファイル --yes 点検に通ったら X API v2 で投稿し、結果をJSONで出す
#   ruby scripts/recommend-x.rb auth                    認証だけを確かめる（投稿しない）
#
# 認証（OAuth 1.0a、Read and Write）: X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_TOKEN_SECRET
#   環境変数になければ、X_ENV_FILE（既定 ~/.config/umichang-blog/x.env）から読む。
#   値は表示しない。環境ファイルは NAME='値' の行だけにし、chmod 600 にする。
# 投稿の記録: .cache/recommend-x-posts.jsonl（git管理外）。同じ本文の24時間以内の再投稿は --force がない限り止める。

require 'base64'
require 'json'
require 'net/http'
require 'openssl'
require 'securerandom'
require 'time'
require 'uri'
require_relative 'lib/notion_environment'
require_relative 'lib/recommendation_sync'

ROOT = File.expand_path('..', __dir__)
LOG = File.join(ROOT, '.cache', 'recommend-x-posts.jsonl')
LIMIT = 280
KEYS = %w[X_API_KEY X_API_SECRET X_ACCESS_TOKEN X_ACCESS_TOKEN_SECRET].freeze
ENV_CANDIDATES = [
  ENV['X_ENV_FILE'],
  File.expand_path('~/.config/umichang-blog/x.env'),
  File.expand_path('~/mnt/umichang-blog/x.env') # Coworkの作業環境で ~/.config/umichang-blog を接続した場合
].compact.freeze
BLOG_URL = %r{https://umichang\.github\.io/blog/\S+}.freeze

def fail!(message)
  warn "中止しました: #{message}"
  exit 1
end

def emit(hash)
  puts JSON.pretty_generate(hash)
end

# X の文字数の数え方（twitter-text v3）。URL は長さにかかわらず 23、範囲外の文字は 2。
def weighted_length(text)
  ranges = [0..4351, 8192..8205, 8208..8223, 8242..8247]
  urls = text.scan(%r{https?://\S+})
  rest = text.gsub(%r{https?://\S+}, '').unicode_normalize(:nfc)
  urls.length * 23 + rest.each_char.sum { |c| ranges.any? { |r| r.cover?(c.ord) } ? 1 : 2 }
end

def http_get(uri, headers = {})
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  http.open_timeout = 10
  http.read_timeout = 20
  req = Net::HTTP::Get.new(uri)
  headers.each { |k, v| req[k] = v }
  http.request(req)
end

# ---- 認証 ----

def load_credentials!
  missing = KEYS.select { |k| ENV[k].to_s.empty? }
  return if missing.empty?

  path = ENV_CANDIDATES.find { |p| File.file?(p) }
  fail!("X の認証情報がありません（環境変数も環境ファイルもない）: #{ENV_CANDIDATES.join(' / ')}") unless path
  File.foreach(path, encoding: 'UTF-8') do |line|
    name, value = NotionEnvironment.parse_assignment(line)
    ENV[name] = value if KEYS.include?(name) && ENV[name].to_s.empty?
  end
  missing = KEYS.select { |k| ENV[k].to_s.empty? }
  fail!("環境ファイルに足りない項目があります: #{missing.join(', ')}（#{path}）") unless missing.empty?
end

def percent(value)
  URI.encode_www_form_component(value).gsub('+', '%20').gsub('%7E', '~')
end

def oauth_header(method, uri)
  params = {
    'oauth_consumer_key' => ENV['X_API_KEY'],
    'oauth_nonce' => SecureRandom.hex(16),
    'oauth_signature_method' => 'HMAC-SHA1',
    'oauth_timestamp' => Time.now.to_i.to_s,
    'oauth_token' => ENV['X_ACCESS_TOKEN'],
    'oauth_version' => '1.0'
  }
  param_string = params.sort.map { |k, v| "#{percent(k)}=#{percent(v)}" }.join('&')
  base = [method.upcase, percent("#{uri.scheme}://#{uri.host}#{uri.path}"), percent(param_string)].join('&')
  key = "#{percent(ENV['X_API_SECRET'])}&#{percent(ENV['X_ACCESS_TOKEN_SECRET'])}"
  params['oauth_signature'] = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', key, base))
  'OAuth ' + params.sort.map { |k, v| %(#{percent(k)}="#{percent(v)}") }.join(', ')
end

def my_username
  uri = URI('https://api.x.com/2/users/me')
  res = http_get(uri, 'Authorization' => oauth_header('GET', uri))
  fail!("認証を確認できませんでした（#{res.code}）: #{res.body}") unless res.code == '200'
  JSON.parse(res.body).dig('data', 'username')
end

# ---- 既存ポストの読み取り（公開の埋め込み用エンドポイント。認証もX APIの料金も不要） ----

def post_id_from(url)
  url.to_s[%r{(?:x|twitter)\.com/[^/]+/status(?:es)?/(\d+)}i, 1] || url.to_s[%r{/i/web/status/(\d+)}, 1] ||
    (url.to_s =~ /\A\d+\z/ ? url.to_s : nil)
end

def fetch_post(url)
  id = post_id_from(url) or fail!("XのポストURLとして読めません: #{url}")
  uri = URI("https://cdn.syndication.twimg.com/tweet-result?id=#{id}&lang=ja&token=a")
  res = http_get(uri)
  fail!("ポストを読み取れませんでした（#{res.code}）。非公開・削除済み、または一時的な不調の可能性があります。本文を貼り付けてもらってください。") unless res.code == '200' && !res.body.strip.empty?
  data = JSON.parse(res.body)
  fail!('ポストを読み取れませんでした（中身が空）。本文を貼り付けてもらってください。') unless data['id_str']

  text = data['text'].to_s
  Array(data.dig('entities', 'urls')).each { |u| text = text.gsub(u['url'], u['expanded_url']) if u['url'] && u['expanded_url'] }
  created = Time.parse(data['created_at'])
  blog_urls = text.scan(BLOG_URL).map { |u| RecommendationSync.normalized_blog_url(u) }.compact.uniq
  screen = data.dig('user', 'screen_name')
  {
    'id' => data['id_str'],
    'url' => "https://x.com/#{screen}/status/#{data['id_str']}",
    'screen_name' => screen,
    'text' => text,
    'created_at' => created.utc.iso8601,
    'date_jst' => created.getlocal('+09:00').strftime('%Y-%m-%d'),
    'blog_urls' => blog_urls
  }
end

# ---- 投稿前の点検 ----

def articles_by_url
  @articles_by_url ||= RecommendationSync::ArticleCatalog.new(ROOT).articles.to_h { |a| [RecommendationSync.normalized_blog_url(a.url), a] }
end

def check(text)
  problems = []
  len = weighted_length(text)
  problems << "長すぎます（#{len} / #{LIMIT}）" if len > LIMIT
  urls = text.scan(BLOG_URL)
  problems << 'ブログ記事のURLがありません' if urls.empty?
  problems << "ブログ記事のURLが#{urls.length}個あります（1個にする）" if urls.length > 1
  problems << 'URLの直後に文字が続いています（URLの後ろは改行か空白にする）' if text =~ %r{https://umichang\.github\.io/blog/\S*[^\x00-\x7F]}
  article = nil
  if urls.length == 1
    normalized = RecommendationSync.normalized_blog_url(urls.first)
    article = articles_by_url[normalized]
    problems << "index.md に掲載された記事と一致しません: #{urls.first}" unless article
    problems << 'URLは .html で終える' unless urls.first.end_with?('.html')
    code = http_get(URI(urls.first)).code rescue 'error'
    problems << "公開URLが表示できません（#{code}）" unless code == '200'
  end
  {
    'ok' => problems.empty?,
    'length' => len,
    'limit' => LIMIT,
    'url' => urls.first,
    'article' => article && { 'title' => article.title, 'path' => article.path, 'url' => article.url,
                              'difficulty' => article.difficulty, 'categories' => article.categories, 'series' => article.series },
    'problems' => problems
  }
end

def read_text(path)
  fail!("本文ファイルがありません: #{path}") unless path && File.file?(path)
  File.read(path, encoding: 'UTF-8').strip
end

def recent_duplicate?(text)
  return false unless File.file?(LOG)

  File.foreach(LOG, encoding: 'UTF-8').any? do |line|
    entry = JSON.parse(line) rescue next
    entry['text'] == text && Time.parse(entry['posted_at']) > Time.now - 86_400
  end
end

def post(text, force:)
  result = check(text)
  fail!("点検に通りません: #{result['problems'].join(' / ')}") unless result['ok']
  fail!('同じ本文を24時間以内に投稿しています（二重投稿の防止）。意図した再投稿なら --force を付けます。') if recent_duplicate?(text) && !force

  load_credentials!
  endpoint = URI('https://api.x.com/2/tweets')
  http = Net::HTTP.new(endpoint.host, endpoint.port)
  http.use_ssl = true
  req = Net::HTTP::Post.new(endpoint)
  req['Authorization'] = oauth_header('POST', endpoint)
  req['Content-Type'] = 'application/json'
  req.body = JSON.generate('text' => text)
  res = http.request(req)
  fail!("X API がエラーを返しました（#{res.code}）: #{res.body}") unless res.code == '201'
  id = JSON.parse(res.body).dig('data', 'id') or fail!("投稿IDを読み取れません: #{res.body}")

  now = Time.now
  entry = { 'id' => id, 'url' => "https://x.com/i/web/status/#{id}", 'posted_at' => now.utc.iso8601,
            'date_jst' => now.getlocal('+09:00').strftime('%Y-%m-%d'), 'text' => text, 'article_url' => result.dig('article', 'url') }
  Dir.mkdir(File.dirname(LOG)) unless Dir.exist?(File.dirname(LOG))
  File.open(LOG, 'a', encoding: 'UTF-8') { |f| f.puts(JSON.generate(entry)) }
  emit(entry.merge('article' => result['article']))
end

command = ARGV.shift
case command
when 'fetch'
  emit(fetch_post(ARGV.first))
when 'check'
  result = check(read_text(ARGV.first))
  emit(result)
  exit 1 unless result['ok']
when 'post'
  file = ARGV.find { |a| !a.start_with?('--') }
  fail!('投稿するには --yes を付けます（うみちゃんの承認を得てから）。') unless ARGV.include?('--yes')
  post(read_text(file), force: ARGV.include?('--force'))
when 'auth'
  load_credentials!
  puts "認証OK: @#{my_username}"
else
  warn File.read(__FILE__)[/^# 使い方:.*?(?=^# 認証)/m].gsub(/^# ?/, '')
  exit 1
end
