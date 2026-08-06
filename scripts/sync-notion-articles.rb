#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rbconfig'
require_relative 'lib/notion_environment'

begin
  NotionEnvironment.load_token!
  script = File.join(__dir__, 'sync-recommendation-posts.rb')
  exec RbConfig.ruby, script, '--sync-articles'
rescue RuntimeError => error
  warn "Notion記事台帳を同期できません: #{error.message}"
  exit 1
end
