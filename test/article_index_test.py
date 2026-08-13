#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "article_index.py"
SPEC = importlib.util.spec_from_file_location("article_index", SCRIPT)
assert SPEC and SPEC.loader
article_index = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = article_index
SPEC.loader.exec_module(article_index)


CATEGORIES = """schema_version: 1
categories:
  - slug: systems
    heading: "🧩 システム"
    parent_group: "🎮 体験"
    display_order: 10
  - slug: extras
    heading: "✨ 番外編"
    parent_group: "✨ 番外編"
    display_order: 10
"""


class ArticleIndexTest(unittest.TestCase):
    def setUp(self) -> None:
        self.directory = tempfile.TemporaryDirectory()
        self.root = Path(self.directory.name)
        (self.root / "data").mkdir()
        (self.root / "data" / "article-categories.yml").write_text(CATEGORIES, encoding="utf-8")
        self.write_article("bank.md", "銀行の設計", "銀行に関する説明", "systems", "green", tags=["経済"])
        self.write_article("loot.md", "ガチャの設計", "課金とガチャの設計", "systems", "yellow", related=["bank.md"])
        self.write_article("extra.md", "番外編", "補助ページ", "extras", "green")
        (self.root / "index.md").write_text(
            """# 一覧

## 📌 まず読む記事

- [銀行の設計](bank.md) 🟢

## 🆕 新着記事

- [ガチャの設計](loot.md) 🟡

## 🎮 体験

### 🧩 システム

- [銀行の設計](bank.md) 🟢
- [ガチャの設計](loot.md) 🟡

## ✨ 番外編

- [番外編](extra.md) 🟢
""",
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.directory.cleanup()

    def write_article(
        self,
        filename: str,
        title: str,
        description: str,
        category: str | None,
        difficulty: str | None,
        tags: list[str] | None = None,
        related: list[str] | None = None,
    ) -> None:
        lines = ["---", f'description: "{description}"']
        if category is not None:
            lines.append(f"category: {category}")
        if difficulty is not None:
            lines.append(f"difficulty: {difficulty}")
        if tags is not None:
            lines.append("tags:")
            lines.extend(f"  - {tag}" for tag in tags)
        if related is not None:
            lines.append("related:")
            lines.extend(f"  - {value}" for value in related)
        lines.extend(["---", "", f"# {title}", ""])
        (self.root / filename).write_text("\n".join(lines), encoding="utf-8")

    def build(self) -> Path:
        db = self.root / ".cache" / "articles.db"
        article_index.build_database(self.root, db)
        return db

    def test_h2_direct_category_resets_previous_h3(self) -> None:
        _, entries, articles = article_index.collect_articles(self.root)
        self.assertEqual(entries["extra.md"].category.slug, "extras")
        self.assertEqual({article.filename for article in articles}, {"bank.md", "loot.md", "extra.md"})

    def test_build_and_short_japanese_search(self) -> None:
        db = self.build()
        with article_index.database_connection(db) as connection:
            result = article_index.search_database(connection, ["銀行"], False, None, None, None, None)
        self.assertEqual([item["filename"] for item in result], ["bank.md"])

    def test_long_search_and_filters(self) -> None:
        db = self.build()
        with article_index.database_connection(db) as connection:
            result = article_index.search_database(connection, ["ガチャ", "銀行"], False, "systems", None, None, None)
            only_both = article_index.search_database(connection, ["ガチャ", "銀行"], True, None, None, None, None)
        self.assertEqual({item["filename"] for item in result}, {"bank.md", "loot.md"})
        self.assertEqual(only_both, [])

    def test_migration_keeps_existing_frontmatter_lines(self) -> None:
        self.write_article("bank.md", "銀行の設計", "銀行に関する説明", None, None)
        _, _, articles = article_index.collect_articles(self.root, require_classification=False)
        article = next(item for item in articles if item.filename == "bank.md")
        self.assertTrue(article_index.replace_classification(article.path, article.category_slug, article.difficulty))
        text = (self.root / "bank.md").read_text(encoding="utf-8")
        self.assertIn('description: "銀行に関する説明"', text)
        self.assertIn("category: systems", text)
        self.assertIn("difficulty: green", text)
        article_index.collect_articles(self.root)

    def test_index_and_frontmatter_mismatch_fails(self) -> None:
        self.write_article("bank.md", "銀行の設計", "銀行に関する説明", "extras", "green")
        with self.assertRaises(article_index.IndexError):
            article_index.collect_articles(self.root)

    def test_literal_like_escaping(self) -> None:
        self.write_article("percent.md", "100%の設計", "_ を含む", "systems", "green")
        with (self.root / "index.md").open("a", encoding="utf-8") as output:
            output.write("\n## 🎮 体験\n\n### 🧩 システム\n\n- [100%の設計](percent.md) 🟢\n")
        db = self.build()
        with article_index.database_connection(db) as connection:
            result = article_index.search_database(connection, ["%"], False, None, None, None, None)
        self.assertEqual([item["filename"] for item in result], ["percent.md"])

    def test_json_is_serializable(self) -> None:
        db = self.build()
        with article_index.database_connection(db) as connection:
            result = article_index.search_database(connection, ["ガチャ"], False, None, None, None, None)
        self.assertEqual(json.loads(json.dumps(result, ensure_ascii=False))[0]["filename"], "loot.md")


if __name__ == "__main__":
    unittest.main()
