#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/recommendation_sync'

options = { config: ENV.fetch('NOTION_RECOMMENDATION_CONFIG', RecommendationSync::DEFAULT_CONFIG_PATH) }
parser = OptionParser.new do |opts|
  opts.banner = '使い方: NOTION_TOKEN=... ruby scripts/sync-recommendation-posts.rb [--init | --sync-articles | --import-x-archive PATH]'
  opts.on('--init', 'Notionに記事・おすすめ投稿履歴DBを作成する') { options[:init] = true }
  opts.on('--sync-articles', 'index.mdの公開記事をNotionへ同期する') { options[:sync_articles] = true }
  opts.on('--import-x-archive PATH', 'XアーカイブZIPまたは展開済みディレクトリを取り込む') { |path| options[:archive] = path }
  opts.on('--config PATH', 'git管理外のローカル設定ファイル') { |path| options[:config] = path }
  opts.on('-h', '--help', 'このヘルプを表示する') { puts opts; exit }
end
parser.parse!

selected = [options[:init], options[:sync_articles], options[:archive]].compact.length
abort parser.to_s unless selected == 1

begin
  root = File.expand_path('..', __dir__)
  config_path = File.expand_path(options[:config], root)
  config = RecommendationSync::Config.new(config_path)
  client = RecommendationSync::NotionClient.new(ENV['NOTION_TOKEN'])

  if options[:init]
    RecommendationSync::Setup.new(client, ENV['NOTION_PARENT_PAGE_ID'], config).run
    puts "Notion台帳を作成しました。設定を保存しました: #{config_path}"
    article_summary, = RecommendationSync::Synchronizer.new(client, config).sync_articles(RecommendationSync::ArticleCatalog.new(root))
    puts "記事を同期しました: 新規 #{article_summary[:created]}件、更新 #{article_summary[:updated]}件"
    puts 'DBビューは docs/recommendation-posts.md の手順でNotion上に作成します。'
  else
    raise RecommendationSync::Error, "初期化が必要です: #{config_path}" unless config.configured?

    synchronizer = RecommendationSync::Synchronizer.new(client, config)
    article_summary, pages_by_url = synchronizer.sync_articles(RecommendationSync::ArticleCatalog.new(root))
    puts "記事を同期しました: 新規 #{article_summary[:created]}件、更新 #{article_summary[:updated]}件"
    if options[:archive]
      post_summary = synchronizer.import_posts(RecommendationSync::XArchive.new(options[:archive]).posts, pages_by_url)
      puts "おすすめ投稿を取り込みました: 新規 #{post_summary[:imported]}件、既存 #{post_summary[:skipped]}件、要確認 #{post_summary[:needs_review]}件"
    end
  end
rescue RecommendationSync::Error => error
  warn error.message
  exit 1
end
