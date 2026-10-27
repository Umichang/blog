#!/usr/bin/env ruby
# frozen_string_literal: true

# アドベントカレンダー2026の紹介ポストを、X API v2 で投稿する。
# 公開済み（2026adv/ にある）で、まだ投稿していない日だけを投稿する。投稿の記録は _data/advent-x-posts.yml に残す。
#
# 使い方:
#   ruby scripts/advent-post-x.rb --tweets 紹介文の一覧.md --days 1,2 [--dry-run] [--notion-json 出力.json]
#     --tweets       「## N日目」の見出しとコードブロックで紹介文を並べたファイル（tweets-2026adv.md）
#     --days         投稿する日（カンマ区切り）。省略時は公開済みで未投稿のすべて
#     --dry-run      投稿せず、文字数と内容の点検だけを行う
#     --notion-json  投稿した記録を、Notion「おすすめ投稿履歴」へ取り込むためのJSONとして書き出す
#     --check-auth   投稿せず、認証が通るかだけを確かめる（自分のアカウント名を表示）
# 認証（環境変数）: X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_TOKEN_SECRET（OAuth 1.0a、Read and Write）

require 'base64'
require 'json'
require 'net/http'
require 'openssl'
require 'optparse'
require 'securerandom'
require 'time'
require 'uri'
require 'yaml'

ROOT = File.expand_path('..', __dir__)
RECORD = File.join(ROOT, '_data', 'advent-x-posts.yml')
SITE = 'https://umichang.github.io/blog/'
LIMIT = 280
ENDPOINT = URI('https://api.x.com/2/tweets')

def fail!(message)
  warn "投稿を中止しました: #{message}"
  exit 1
end

# X の文字数の数え方（twitter-text v3）。URL は長さにかかわらず 23、それ以外は範囲外の文字を 2 と数える。
def weighted_length(text)
  ranges = [0..4351, 8192..8205, 8208..8223, 8242..8247]
  urls = text.scan(%r{https?://\S+})
  rest = text.gsub(%r{https?://\S+}, '').unicode_normalize(:nfc)
  urls.length * 23 + rest.each_char.sum { |c| ranges.any? { |r| r.cover?(c.ord) } ? 1 : 2 }
end

def percent(value)
  URI.encode_www_form_component(value).gsub('+', '%20').gsub('%7E', '~')
end

def oauth_header(method, uri)
  keys = %w[X_API_KEY X_API_SECRET X_ACCESS_TOKEN X_ACCESS_TOKEN_SECRET]
  missing = keys.select { |k| ENV[k].to_s.empty? }
  fail!("認証情報がありません: #{missing.join(', ')}") unless missing.empty?

  params = {
    'oauth_consumer_key' => ENV['X_API_KEY'],
    'oauth_nonce' => SecureRandom.hex(16),
    'oauth_signature_method' => 'HMAC-SHA1',
    'oauth_timestamp' => Time.now.to_i.to_s,
    'oauth_token' => ENV['X_ACCESS_TOKEN'],
    'oauth_version' => '1.0'
  }
  # JSON の本文は署名の対象に含めない（OAuth 1.0a の規定どおり）
  param_string = params.sort.map { |k, v| "#{percent(k)}=#{percent(v)}" }.join('&')
  base = [method.upcase, percent("#{uri.scheme}://#{uri.host}#{uri.path}"), percent(param_string)].join('&')
  key = "#{percent(ENV['X_API_SECRET'])}&#{percent(ENV['X_ACCESS_TOKEN_SECRET'])}"
  params['oauth_signature'] = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', key, base))
  'OAuth ' + params.sort.map { |k, v| %(#{percent(k)}="#{percent(v)}") }.join(', ')
end

# 認証の確認（投稿しない）。自分のアカウント情報を読むだけ
def check_auth
  uri = URI('https://api.x.com/2/users/me')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = oauth_header('GET', uri)
  res = http.request(req)
  fail!("認証を確認できませんでした（#{res.code}）: #{res.body}") unless res.code == '200'
  puts "認証OK: @#{JSON.parse(res.body).dig('data', 'username')}"
  exit 0
end

def post_tweet(text)
  http = Net::HTTP.new(ENDPOINT.host, ENDPOINT.port)
  http.use_ssl = true
  req = Net::HTTP::Post.new(ENDPOINT)
  req['Authorization'] = oauth_header('POST', ENDPOINT)
  req['Content-Type'] = 'application/json'
  req.body = JSON.generate('text' => text)
  res = http.request(req)
  fail!("X API がエラーを返しました（#{res.code}）: #{res.body}") unless res.code == '201'
  JSON.parse(res.body).dig('data', 'id') or fail!("投稿IDを読み取れません: #{res.body}")
end

options = { dry_run: false }
OptionParser.new do |opts|
  opts.on('--tweets PATH') { |v| options[:tweets] = File.expand_path(v, Dir.pwd) }
  opts.on('--days LIST') { |v| options[:days] = v.split(',').map { |d| Integer(d) } }
  opts.on('--dry-run') { options[:dry_run] = true }
  opts.on('--check-auth') { options[:check_auth] = true }
  opts.on('--notion-json PATH') { |v| options[:notion_json] = File.expand_path(v, Dir.pwd) }
end.parse!
check_auth if options[:check_auth]
fail!('--tweets を指定してください。') unless options[:tweets] && File.file?(options[:tweets])

# 紹介文の一覧を読む（「## N日目」の直後のコードブロック）
texts = {}
File.read(options[:tweets], encoding: 'UTF-8').scan(/^## (\d+)日目[^\n]*\n+```\n(.*?)\n```/m) { |d, body| texts[d.to_i] = body.strip }

records = File.file?(RECORD) ? (YAML.safe_load(File.read(RECORD, encoding: 'UTF-8')) || {}) : {}
records['posts'] ||= []
posted_days = records['posts'].map { |r| r['day'] }

published = Dir[File.join(ROOT, '2026adv', 'day*.md')].to_h { |f| [File.basename(f)[/\Aday(\d+)/, 1].to_i, File.basename(f)] }
days = options[:days] || published.keys.sort
days = days.reject { |d| posted_days.include?(d) }.sort
if options[:dry_run] && options[:days]
  # 予行演習では、未公開の日も点検できるようにする
else
  days.select! { |d| published.key?(d) }
end

imported = []
days.each do |d|
  text = texts[d] or fail!("#{d}日目の紹介文が見つかりません。")
  len = weighted_length(text)
  fail!("#{d}日目の紹介文が長すぎます（#{len} / #{LIMIT}）。") if len > LIMIT
  fail!("#{d}日目の紹介文が「#アドベントカレンダー2026 #{d}日目。」で始まっていません。") unless text.start_with?("#アドベントカレンダー2026 #{d}日目。")
  url = text[%r{https://umichang\.github\.io/blog/2026adv/\S+}] or fail!("#{d}日目の紹介文に記事のURLがありません。")
  file = published[d]
  expected = file && "#{SITE}2026adv/#{file.sub(/\.md\z/, '.html')}"
  fail!("#{d}日目のURLが公開した記事と一致しません: #{url}") if expected && url != expected

  if options[:dry_run]
    puts "点検OK: #{d}日目（#{len} / #{LIMIT}）"
    next
  end

  id = post_tweet(text)
  now = Time.now.utc.iso8601
  records['posts'] << { 'day' => d, 'id' => id, 'url' => "https://x.com/i/web/status/#{id}", 'posted_at' => now }
  File.write(RECORD, YAML.dump(records), encoding: 'UTF-8') # 1件ごとに書き、途中で止まっても二重投稿しない
  imported << { 'id' => id, 'text' => text, 'created_at' => now, 'urls' => [url], 'source' => '自動投稿', 'title' => "アドベントカレンダー2026 #{d}日目" }
  puts "投稿しました: #{d}日目 https://x.com/i/web/status/#{id}"
end

File.write(options[:notion_json], JSON.pretty_generate(imported), encoding: 'UTF-8') if options[:notion_json] && !imported.empty?
puts '投稿する日はありませんでした。' if days.empty?
