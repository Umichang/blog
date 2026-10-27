#!/usr/bin/env ruby
# frozen_string_literal: true

# アドベントカレンダー2026の自動公開。
# 書きためた原稿（非公開）を、公開日（日本時間）に限って 2026adv/ と image/ へコピーし、
# index.md のカレンダー表・新着欄・RSS を更新する。
#
# 使い方:
#   ruby scripts/advent-publish.rb --drafts 下書きのルート [--date 2026-12-01] [--through N] [--commit]
#     --drafts   2026adv/ と image/ を持つ下書きフォルダ（例: _adv-drafts、Actionsでは drafts）
#     --date     日本時間の日付（省略時は現在の日本時間）。その日までの未公開分を古い順に処理する
#     --through  日付の代わりに「N日目まで」を指定する（予行演習用）
#     --commit   1日分ごとに git commit する（push はしない）
#
# 1日分の処理: 原稿の点検 → 原稿と画像のコピー → カレンダー表のセル → update-recent-articles.rb 🟢 → validate

require 'date'
require 'fileutils'
require 'open3'
require 'optparse'
require 'rbconfig'

ROOT = File.expand_path('..', __dir__)
YEAR = 2026
LAST_DAY = 25
CALENDAR_HEADING = '## 🎄 アドベントカレンダー2026'
SHARED_IMAGE = /\Aadv2026-verdict-[a-z]+\.webp\z/

def fail!(message)
  warn "公開を中止しました: #{message}"
  exit 1
end

def run!(env, *cmd)
  out, status = Open3.capture2e(env, *cmd, chdir: ROOT)
  puts out unless out.empty?
  fail!("コマンドが失敗しました: #{cmd.join(' ')}") unless status.success?
  out
end

options = { commit: false }
OptionParser.new do |opts|
  opts.on('--drafts PATH') { |v| options[:drafts] = File.expand_path(v, Dir.pwd) }
  opts.on('--date YYYY-MM-DD') { |v| options[:date] = Date.iso8601(v) }
  opts.on('--through N', Integer) { |v| options[:through] = v }
  opts.on('--commit') { options[:commit] = true }
end.parse!
fail!('--drafts を指定してください。') unless options[:drafts]

through =
  if options[:through]
    options[:through]
  else
    today = options[:date] || (Time.now.utc + 9 * 3600).to_date
    if today < Date.new(YEAR, 12, 1)
      puts "公開期間前です（#{today}）。何もしません。"
      exit 0
    end
    today > Date.new(YEAR, 12, LAST_DAY) ? LAST_DAY : today.day
  end
fail!("日付が範囲外です: #{through}") unless (1..LAST_DAY).cover?(through)

draft_articles = File.join(options[:drafts], '2026adv')
draft_images = File.join(options[:drafts], 'image')
index_path = File.join(ROOT, 'index.md')
fail!('index.md にカレンダー表の見出しがありません（11月30日の設置を先に行ってください）。') unless File.read(index_path, encoding: 'UTF-8').include?(CALENDAR_HEADING)

published = []
(1..through).each do |n|
  name_glob = format('day%02d-*.md', n)
  next unless Dir[File.join(ROOT, '2026adv', name_glob)].empty? # 公開済みは飛ばす

  candidates = Dir[File.join(draft_articles, name_glob)]
  fail!("#{n}日目の原稿が見つからないか、複数あります: #{candidates.map { |c| File.basename(c) }}") unless candidates.length == 1
  src = candidates.first
  file = File.basename(src)
  text = File.read(src, encoding: 'UTF-8')

  # 点検
  front = text[/\A---\n(.*?)\n---\n/m, 1] or fail!("#{file}: frontmatter がありません。")
  fail!("#{file}: description がありません。") unless front.match?(/^description:\s*\S/)
  fail!("#{file}: difficulty: green ではありません。") unless front.match?(/^difficulty:\s*green\s*$/)
  h1 = text[/^# (.+)$/, 1] or fail!("#{file}: H1 がありません。")
  fail!("#{file}: H1 が「#{n}日目：」で始まっていません。") unless h1.start_with?("#{n}日目：")
  fail!("#{file}: ../ のない image/ への参照があります。") if text.match?(/\]\(image\//)
  images = text.scan(%r{\]\(\.\./image/([^)\s]+)\)}).flatten.uniq
  images.each { |img| fail!("#{file}: 画像がありません: #{img}") unless File.file?(File.join(draft_images, img)) }

  # 原稿と画像のコピー
  FileUtils.mkdir_p(File.join(ROOT, '2026adv'))
  FileUtils.cp(src, File.join(ROOT, '2026adv', file))
  images.each do |img|
    dest = File.join(ROOT, 'image', img)
    from = File.join(draft_images, img)
    if File.exist?(dest)
      next if FileUtils.compare_file(from, dest)
      fail!("image/#{img} が既にあり、内容が違います（上書きしません）。")
    end
    FileUtils.cp(from, dest)
  end

  # カレンダー表のセル
  index = File.read(index_path, encoding: 'UTF-8')
  head, sep, rest = index.partition(CALENDAR_HEADING)
  section, nxt, tail = rest.partition("\n## ")
  cell = /\|\s#{n}\s(?=\|)/
  fail!("カレンダー表に #{n} のセルが見つかりません（または既にリンク済み）。") unless section.scan(cell).length == 1
  title = h1.gsub('"', '\"')
  section = section.sub(cell, "| [#{n}](2026adv/#{file} \"#{title}\") ")
  File.write(index_path, head + sep + section + nxt + tail, encoding: 'UTF-8')

  # 新着欄・RSS・掲載日時（Notion同期は環境変数で制御）
  env = {}
  env['SKIP_NOTION_SYNC'] = '1' unless ENV['NOTION_TOKEN'] && !ENV['NOTION_TOKEN'].empty?
  run!(env, RbConfig.ruby, 'scripts/update-recent-articles.rb', "2026adv/#{file}", '🟢')
  run!({}, 'python3', 'scripts/article_index.py', 'validate')

  if options[:commit]
    run!({}, 'git', 'add', 'index.md', 'rss.xml', '_data/recent-articles.yml', "2026adv/#{file}", *images.map { |i| "image/#{i}" })
    run!({}, 'git', 'commit', '-m', "アドベントカレンダー#{n}日目を公開")
  end
  published << "#{n}日目 #{file}"
  puts "公開しました: #{n}日目 #{file}"
end

puts published.empty? ? '公開する回はありませんでした。' : "今回公開: #{published.join('、')}"
