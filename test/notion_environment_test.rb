# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require_relative '../scripts/lib/notion_environment'

class NotionEnvironmentTest < Minitest::Test
  def with_environment
    previous = ENV.delete('NOTION_TOKEN')
    yield
  ensure
    ENV['NOTION_TOKEN'] = previous if previous
  end

  def test_loads_a_quoted_token_without_evaluating_other_shell_content
    Dir.mktmpdir do |directory|
      path = File.join(directory, 'notion.env')
      File.write(path, "export NOTION_TOKEN='secret-value'\nUNRELATED=$(touch should-not-run)\n", encoding: 'UTF-8')

      with_environment do
        NotionEnvironment.load_token!(path)
        assert_equal 'secret-value', ENV['NOTION_TOKEN']
        refute File.exist?(File.join(directory, 'should-not-run'))
      end
    end
  end

  def test_reports_a_missing_token
    Dir.mktmpdir do |directory|
      path = File.join(directory, 'notion.env')
      File.write(path, "# token is intentionally absent\n", encoding: 'UTF-8')

      with_environment do
        error = assert_raises(RuntimeError) { NotionEnvironment.load_token!(path) }
        assert_match 'NOTION_TOKEN', error.message
      end
    end
  end

  def test_uses_an_explicit_environment_token_without_reading_a_file
    previous = ENV['NOTION_TOKEN']
    ENV['NOTION_TOKEN'] = 'already-set'

    NotionEnvironment.load_token!('/does/not/exist')
    assert_equal 'already-set', ENV['NOTION_TOKEN']
  ensure
    ENV['NOTION_TOKEN'] = previous
  end
end
