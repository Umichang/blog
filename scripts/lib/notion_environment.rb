# frozen_string_literal: true

module NotionEnvironment
  DEFAULT_PATH = File.expand_path('~/.config/umichang-blog/notion.env')
  ASSIGNMENT = /\A(?:export\s+)?(?<name>[A-Z][A-Z0-9_]*)=(?<value>.*)\z/.freeze

  module_function

  def load_token!(path = ENV.fetch('NOTION_ENV_FILE', DEFAULT_PATH))
    return if ENV['NOTION_TOKEN'] && !ENV['NOTION_TOKEN'].empty?

    raise "Notion環境ファイルが見つかりません: #{path}" unless File.file?(path)

    File.foreach(path, encoding: 'UTF-8') do |line|
      name, value = parse_assignment(line)
      ENV[name] = value if name == 'NOTION_TOKEN'
    end

    return if ENV['NOTION_TOKEN'] && !ENV['NOTION_TOKEN'].empty?

    raise "NOTION_TOKEN が設定されていません: #{path}"
  end

  def parse_assignment(line)
    source = line.strip
    return [nil, nil] if source.empty? || source.start_with?('#')

    match = source.match(ASSIGNMENT)
    return [nil, nil] unless match

    [match[:name], unquote(match[:value].strip)]
  end

  def unquote(value)
    return value[1...-1] if value.length >= 2 && value.start_with?("'") && value.end_with?("'")
    return value[1...-1] if value.length >= 2 && value.start_with?('"') && value.end_with?('"')

    value
  end
end
