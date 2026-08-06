# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
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
