#!/usr/bin/env python3
"""公開記事カタログをSQLite/FTS5へ再生成し、候補検索を行う。"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sqlite3
import sys
import tempfile
import unicodedata
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

try:
    import yaml
except ImportError as error:  # pragma: no cover - startup guard
    raise SystemExit("PyYAML が必要です。python3 -m pip install -r requirements-dev.txt を実行してください。") from error


SCHEMA_VERSION = "1"
GENERATOR_VERSION = "1.0.0"
DIFFICULTY_FROM_EMOJI = {"🟢": "green", "🟡": "yellow", "🔴": "red"}
VALID_DIFFICULTIES = frozenset(DIFFICULTY_FROM_EMOJI.values())
NON_CATEGORY_HEADINGS = frozenset({"📌 まず読む記事", "🆕 新着記事"})
SLUG_RE = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*\Z")
FRONTMATTER_RE = re.compile(r"\A---\r?\n(?P<content>.*?)\r?\n---\r?\n", re.DOTALL)
H1_RE = re.compile(r"^#\s+(.+?)\s*$", re.MULTILINE)
H2_RE = re.compile(r"^##\s+(.+?)\s*$")
H3_RE = re.compile(r"^###\s+(.+?)\s*$")
LINK_RE = re.compile(r"^- \[(?P<title>.+?)\]\((?P<path>[^)]+\.md)\)(?P<suffix>.*?)\s*$")


class IndexError(Exception):
    """入力カタログが契約を満たさない場合の例外。"""


@dataclass(frozen=True)
class Category:
    slug: str
    heading: str
    parent_group: str
    display_order: int


@dataclass(frozen=True)
class IndexEntry:
    filename: str
    category: Category
    difficulty: str


@dataclass(frozen=True)
class Article:
    filename: str
    title: str
    description: str
    category_slug: str
    difficulty: str
    lang: str | None
    tags: tuple[str, ...]
    related: tuple[str, ...]
    translation_of: str | None
    path: Path


def fail(message: str) -> None:
    raise IndexError(message)


def repo_path(root: Path, relative: str) -> Path:
    candidate = (root / relative).resolve()
    try:
        candidate.relative_to(root.resolve())
    except ValueError:
        fail(f"リポジトリ外を指すパスは使えません: {relative}")
    return candidate


def load_yaml(path: Path) -> Any:
    try:
        return yaml.safe_load(path.read_text(encoding="utf-8"))
    except (OSError, yaml.YAMLError) as error:
        fail(f"YAMLを読み込めません: {path}: {error}")


def load_categories(root: Path) -> tuple[dict[str, Category], dict[str, Category]]:
    path = root / "data" / "article-categories.yml"
    data = load_yaml(path)
    if not isinstance(data, dict) or data.get("schema_version") != 1 or not isinstance(data.get("categories"), list):
        fail(f"分類台帳の形式が不正です: {path}")

    by_slug: dict[str, Category] = {}
    by_heading: dict[str, Category] = {}
    orders: set[tuple[str, int]] = set()
    for raw in data["categories"]:
        if not isinstance(raw, dict):
            fail("分類台帳の各項目はmappingでなければなりません。")
        values = {key: raw.get(key) for key in ("slug", "heading", "parent_group", "display_order")}
        if not isinstance(values["slug"], str) or not SLUG_RE.fullmatch(values["slug"]):
            fail(f"カテゴリslugが不正です: {values['slug']!r}")
        if not isinstance(values["heading"], str) or not values["heading"].strip():
            fail(f"カテゴリ見出しが不正です: {values['slug']}")
        if not isinstance(values["parent_group"], str) or not values["parent_group"].strip():
            fail(f"カテゴリ親グループが不正です: {values['slug']}")
        if not isinstance(values["display_order"], int):
            fail(f"カテゴリ表示順が不正です: {values['slug']}")
        category = Category(**values)
        order_key = (category.parent_group, category.display_order)
        if category.slug in by_slug or category.heading in by_heading or order_key in orders:
            fail(f"分類台帳に重複があります: {category.slug}")
        by_slug[category.slug] = category
        by_heading[category.heading] = category
        orders.add(order_key)
    return by_slug, by_heading


def parse_index(root: Path, categories_by_heading: dict[str, Category]) -> dict[str, IndexEntry]:
    path = root / "index.md"
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as error:
        fail(f"index.mdを読み込めません: {error}")

    current_h2: str | None = None
    current_h3: str | None = None
    entries: dict[str, IndexEntry] = {}
    seen_headings: set[str] = set()
    for line_number, line in enumerate(lines, start=1):
        if match := H2_RE.match(line):
            current_h2 = match.group(1)
            current_h3 = None
            continue
        if match := H3_RE.match(line):
            current_h3 = match.group(1)
            continue
        match = LINK_RE.match(line)
        if not match or current_h2 in NON_CATEGORY_HEADINGS:
            continue

        heading = current_h3 or current_h2
        category = categories_by_heading.get(heading or "")
        if category is None:
            continue
        if category.parent_group != current_h2:
            fail(f"index.md:{line_number}: カテゴリ {heading} の親グループが分類台帳と一致しません。")
        suffix = match.group("suffix")
        difficulty = DIFFICULTY_FROM_EMOJI.get(suffix.strip())
        if difficulty is None or suffix != f" {suffix.strip()}":
            fail(f"index.md:{line_number}: 分類リンクには難易度絵文字を1つ指定してください。")
        filename = match.group("path")
        if filename in entries:
            previous = entries[filename]
            fail(
                f"index.md:{line_number}: {filename} が重複しています "
                f"({previous.category.heading}/{previous.difficulty})"
            )
        entries[filename] = IndexEntry(filename, category, difficulty)
        seen_headings.add(category.heading)

    missing = sorted(set(categories_by_heading) - seen_headings)
    if missing:
        fail(f"分類台帳にあるカテゴリがindex.mdにありません: {', '.join(missing)}")
    if not entries:
        fail("index.mdから分類済み記事を取得できません。")
    return entries


def parse_frontmatter(path: Path) -> tuple[dict[str, Any], str, re.Match[str]]:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        fail(f"記事を読み込めません: {path}: {error}")
    match = FRONTMATTER_RE.match(text)
    if not match:
        fail(f"frontmatterが見つかりません: {path}")
    try:
        metadata = yaml.safe_load(match.group("content")) or {}
    except yaml.YAMLError as error:
        fail(f"frontmatterを読み込めません: {path}: {error}")
    if not isinstance(metadata, dict) or any(not isinstance(key, str) for key in metadata):
        fail(f"frontmatterは文字列キーのmappingでなければなりません: {path}")
    title_match = H1_RE.search(text[match.end() :])
    if not title_match:
        fail(f"H1が見つかりません: {path}")
    return metadata, title_match.group(1), match


def ensure_string_list(value: Any, key: str, filename: str) -> tuple[str, ...]:
    if value is None:
        return ()
    if not isinstance(value, list) or any(not isinstance(item, str) or not item.strip() for item in value):
        fail(f"{filename}: {key} は空でない文字列の配列でなければなりません。")
    cleaned = tuple(item.strip() for item in value)
    if len(cleaned) != len(set(cleaned)):
        fail(f"{filename}: {key} に重複があります。")
    return cleaned


def validate_reference(value: str, key: str, filename: str) -> str:
    if not value.endswith(".md") or Path(value).is_absolute() or ".." in Path(value).parts:
        fail(f"{filename}: {key} はリポジトリ相対の.mdファイル名でなければなりません: {value}")
    return value


def collect_articles(root: Path, require_classification: bool = True) -> tuple[dict[str, Category], dict[str, IndexEntry], list[Article]]:
    categories_by_slug, categories_by_heading = load_categories(root)
    entries = parse_index(root, categories_by_heading)
    articles: list[Article] = []
    for filename, entry in sorted(entries.items()):
        path = repo_path(root, filename)
        if not path.is_file():
            fail(f"index.mdのリンク先が存在しません: {filename}")
        metadata, title, _ = parse_frontmatter(path)
        description = metadata.get("description")
        if not isinstance(description, str) or not description.strip():
            fail(f"{filename}: description がありません。")
        category_slug = metadata.get("category")
        difficulty = metadata.get("difficulty")
        if require_classification:
            if not isinstance(category_slug, str) or category_slug not in categories_by_slug:
                fail(f"{filename}: category が分類台帳のslugではありません: {category_slug!r}")
            if difficulty not in VALID_DIFFICULTIES:
                fail(f"{filename}: difficulty が不正です: {difficulty!r}")
            if category_slug != entry.category.slug or difficulty != entry.difficulty:
                fail(
                    f"{filename}: frontmatter({category_slug}/{difficulty}) と "
                    f"index.md({entry.category.slug}/{entry.difficulty}) が一致しません。"
                )
        else:
            category_slug = entry.category.slug
            difficulty = entry.difficulty
        lang = metadata.get("lang")
        if lang is not None and (not isinstance(lang, str) or not lang.strip()):
            fail(f"{filename}: lang は空でない文字列でなければなりません。")
        tags = ensure_string_list(metadata.get("tags"), "tags", filename)
        related = tuple(validate_reference(item, "related", filename) for item in ensure_string_list(metadata.get("related"), "related", filename))
        translation_of = metadata.get("translation_of")
        if translation_of is not None:
            if not isinstance(translation_of, str) or not translation_of.strip():
                fail(f"{filename}: translation_of は空でない文字列でなければなりません。")
            translation_of = validate_reference(translation_of.strip(), "translation_of", filename)
        articles.append(
            Article(filename, title, description.strip(), category_slug, difficulty, lang.strip() if lang else None, tags, related, translation_of, path)
        )

    names = {article.filename for article in articles}
    for article in articles:
        for related in article.related:
            if related == article.filename or related not in names:
                fail(f"{article.filename}: related の参照先が公開記事にありません: {related}")
        if article.translation_of:
            if article.translation_of == article.filename or article.translation_of not in names:
                fail(f"{article.filename}: translation_of の参照先が公開記事にありません: {article.translation_of}")
    return categories_by_slug, entries, articles


def source_digest(root: Path, articles: Iterable[Article]) -> str:
    root = root.resolve()
    digest = hashlib.sha256()
    paths = [root / "data" / "article-categories.yml", root / "index.md"] + [article.path.resolve() for article in articles]
    for path in sorted(paths, key=lambda item: item.relative_to(root).as_posix()):
        relative = path.relative_to(root).as_posix().encode("utf-8")
        digest.update(relative + b"\0" + path.read_bytes() + b"\0")
    return digest.hexdigest()


SCHEMA_SQL = """
PRAGMA foreign_keys = ON;
CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE categories (
  slug TEXT PRIMARY KEY,
  heading TEXT NOT NULL UNIQUE,
  parent_group TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  UNIQUE(parent_group, display_order)
);
CREATE TABLE articles (
  filename TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category_slug TEXT NOT NULL REFERENCES categories(slug),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('green', 'yellow', 'red')),
  lang TEXT,
  tags_text TEXT NOT NULL
);
CREATE TABLE article_tags (
  article_filename TEXT NOT NULL REFERENCES articles(filename) ON DELETE CASCADE,
  tag TEXT NOT NULL,
  PRIMARY KEY(article_filename, tag)
);
CREATE TABLE article_related (
  article_filename TEXT NOT NULL REFERENCES articles(filename) ON DELETE CASCADE,
  related_filename TEXT NOT NULL REFERENCES articles(filename),
  PRIMARY KEY(article_filename, related_filename),
  CHECK(article_filename <> related_filename)
);
CREATE TABLE article_translations (
  article_filename TEXT PRIMARY KEY REFERENCES articles(filename) ON DELETE CASCADE,
  original_filename TEXT NOT NULL REFERENCES articles(filename),
  CHECK(article_filename <> original_filename)
);
CREATE INDEX articles_category_difficulty_idx ON articles(category_slug, difficulty);
CREATE INDEX article_tags_tag_idx ON article_tags(tag);
CREATE VIRTUAL TABLE articles_fts USING fts5(
  filename UNINDEXED, title, description, tags_text,
  content='articles', content_rowid='rowid', tokenize='trigram'
);
"""


def check_fts5(connection: sqlite3.Connection) -> None:
    try:
        connection.execute("CREATE VIRTUAL TABLE temp.article_index_fts_check USING fts5(value, tokenize='trigram')")
        connection.execute("DROP TABLE temp.article_index_fts_check")
    except sqlite3.OperationalError as error:
        fail(f"SQLite FTS5 trigramトークナイザが利用できません: {error}")


def build_database(root: Path, db_path: Path) -> tuple[int, int, str]:
    categories, _, articles = collect_articles(root)
    digest = source_digest(root, articles)
    db_path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temp_name = tempfile.mkstemp(prefix=f"{db_path.name}.tmp-", dir=db_path.parent)
    os.close(descriptor)
    temporary = Path(temp_name)
    try:
        with sqlite3.connect(temporary) as connection:
            check_fts5(connection)
            connection.executescript(SCHEMA_SQL)
            connection.executemany(
                "INSERT INTO categories VALUES (?, ?, ?, ?)",
                [(item.slug, item.heading, item.parent_group, item.display_order) for item in categories.values()],
            )
            connection.executemany(
                "INSERT INTO articles VALUES (?, ?, ?, ?, ?, ?, ?)",
                [
                    (article.filename, article.title, article.description, article.category_slug, article.difficulty, article.lang, "\n".join(article.tags))
                    for article in articles
                ],
            )
            connection.executemany(
                "INSERT INTO article_tags VALUES (?, ?)",
                [(article.filename, tag) for article in articles for tag in article.tags],
            )
            connection.executemany(
                "INSERT INTO article_related VALUES (?, ?)",
                [(article.filename, related) for article in articles for related in article.related],
            )
            connection.executemany(
                "INSERT INTO article_translations VALUES (?, ?)",
                [(article.filename, article.translation_of) for article in articles if article.translation_of],
            )
            connection.execute("INSERT INTO articles_fts(articles_fts) VALUES ('rebuild')")
            connection.executemany(
                "INSERT INTO meta VALUES (?, ?)",
                [("schema_version", SCHEMA_VERSION), ("generator_version", GENERATOR_VERSION), ("source_digest", digest)],
            )
            integrity = connection.execute("PRAGMA integrity_check").fetchone()[0]
            foreign_keys = connection.execute("PRAGMA foreign_key_check").fetchall()
            fts_count = connection.execute("SELECT count(*) FROM articles_fts").fetchone()[0]
            if integrity != "ok" or foreign_keys or fts_count != len(articles):
                fail(f"DB検証に失敗しました: integrity={integrity}, foreign_keys={foreign_keys}, fts={fts_count}")
        os.replace(temporary, db_path)
    except Exception:
        temporary.unlink(missing_ok=True)
        raise
    return len(articles), len(categories), digest


def default_db_path(root: Path) -> Path:
    return root / ".cache" / "articles.db"


def database_connection(db_path: Path) -> sqlite3.Connection:
    if not db_path.is_file():
        fail(f"DBがありません: {db_path}。先に build を実行してください。")
    connection = sqlite3.connect(db_path)
    version = connection.execute("SELECT value FROM meta WHERE key = 'schema_version'").fetchone()
    if version is None or version[0] != SCHEMA_VERSION:
        connection.close()
        fail("DBのスキーマバージョンが一致しません。build を実行してください。")
    return connection


def normalized_terms(raw_terms: list[str]) -> list[str]:
    terms = list(dict.fromkeys(unicodedata.normalize("NFC", term).strip() for term in raw_terms if term.strip()))
    if not terms:
        fail("検索語を1つ以上指定してください。")
    return terms


def like_literal(value: str) -> str:
    return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


def search_database(connection: sqlite3.Connection, terms: list[str], require_all: bool, category: str | None, difficulty: str | None, lang: str | None, tag: str | None) -> list[dict[str, Any]]:
    hits: dict[str, dict[str, Any]] = defaultdict(lambda: {"terms": set(), "score": None})
    for term in terms:
        if len(term) >= 3:
            query = '"' + term.replace('"', '""') + '"'
            rows = connection.execute(
                "SELECT a.filename, bm25(articles_fts) FROM articles_fts "
                "JOIN articles a ON a.rowid = articles_fts.rowid WHERE articles_fts MATCH ?",
                (query,),
            )
            for filename, score in rows:
                hits[filename]["terms"].add(term)
                hits[filename]["score"] = (hits[filename]["score"] or 0.0) + score
        else:
            literal = f"%{like_literal(term)}%"
            rows = connection.execute(
                "SELECT filename FROM articles WHERE filename LIKE ? ESCAPE '\\' OR title LIKE ? ESCAPE '\\' "
                "OR description LIKE ? ESCAPE '\\' OR tags_text LIKE ? ESCAPE '\\'",
                (literal, literal, literal, literal),
            )
            for (filename,) in rows:
                hits[filename]["terms"].add(term)
    if require_all:
        hits = {filename: value for filename, value in hits.items() if len(value["terms"]) == len(terms)}
    if not hits:
        return []

    placeholders = ",".join("?" for _ in hits)
    where = [f"a.filename IN ({placeholders})"]
    parameters: list[Any] = list(hits)
    if category:
        where.append("a.category_slug = ?")
        parameters.append(category)
    if difficulty:
        where.append("a.difficulty = ?")
        parameters.append(difficulty)
    if lang:
        where.append("a.lang = ?")
        parameters.append(lang)
    if tag:
        where.append("EXISTS (SELECT 1 FROM article_tags t WHERE t.article_filename = a.filename AND t.tag = ?)")
        parameters.append(tag)
    rows = connection.execute(
        "SELECT a.filename, a.title, a.description, a.category_slug, c.heading, a.difficulty, a.lang "
        "FROM articles a JOIN categories c ON c.slug = a.category_slug WHERE " + " AND ".join(where),
        parameters,
    ).fetchall()
    result = []
    for filename, title, description, category_slug, category_heading, item_difficulty, item_lang in rows:
        tags = [row[0] for row in connection.execute("SELECT tag FROM article_tags WHERE article_filename = ? ORDER BY tag", (filename,))]
        result.append(
            {
                "filename": filename,
                "title": title,
                "description": description,
                "category_slug": category_slug,
                "category_heading": category_heading,
                "difficulty": item_difficulty,
                "lang": item_lang,
                "tags": tags,
                "matched_terms": sorted(hits[filename]["terms"]),
                "_score": hits[filename]["score"],
            }
        )
    result.sort(key=lambda item: (-len(item["matched_terms"]), item["_score"] is None, item["_score"] or 0.0, item["filename"]))
    for item in result:
        del item["_score"]
    return result


def replace_classification(path: Path, category: str, difficulty: str) -> bool:
    text = path.read_text(encoding="utf-8")
    match = FRONTMATTER_RE.match(text)
    if not match:  # validated before this function; guard keeps standalone use safe.
        fail(f"frontmatterが見つかりません: {path}")
    metadata, _, _ = parse_frontmatter(path)
    if metadata.get("category") == category and metadata.get("difficulty") == difficulty:
        return False
    content = match.group("content")
    newline = "\r\n" if "\r\n" in match.group(0) else "\n"
    lines = content.splitlines(keepends=True)
    replacements = {"category": category, "difficulty": difficulty}
    for key, value in replacements.items():
        matches = [index for index, line in enumerate(lines) if re.match(rf"^{re.escape(key)}:\s*", line)]
        if len(matches) > 1:
            fail(f"{path}: {key} が重複しています。")
        line = f"{key}: {value}{newline}"
        if matches:
            lines[matches[0]] = line
        else:
            if lines and not lines[-1].endswith(("\n", "\r")):
                lines[-1] += newline
            lines.append(line)
    replacement = f"---{newline}{''.join(lines)}---{newline}"
    updated = replacement + text[match.end() :]
    descriptor, temporary_name = tempfile.mkstemp(prefix=f"{path.name}.tmp-", dir=path.parent)
    with os.fdopen(descriptor, "w", encoding="utf-8", newline="") as output:
        output.write(updated)
    os.replace(temporary_name, path)
    return True


def command_validate(args: argparse.Namespace) -> int:
    _, entries, articles = collect_articles(args.root)
    print(f"検証成功: 記事 {len(articles)}件、分類 {len({entry.category.slug for entry in entries.values()})}件")
    return 0


def command_build(args: argparse.Namespace) -> int:
    articles, categories, digest = build_database(args.root, args.db)
    print(f"DBを生成しました: 記事 {articles}件、分類 {categories}件、source_digest {digest}")
    return 0


def command_search(args: argparse.Namespace) -> int:
    if args.difficulty and args.difficulty not in VALID_DIFFICULTIES:
        fail(f"difficulty が不正です: {args.difficulty}")
    terms = normalized_terms(args.terms)
    with database_connection(args.db) as connection:
        result = search_database(connection, terms, args.and_mode, args.category, args.difficulty, args.lang, args.tag)
    result = result[: args.limit]
    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        for item in result:
            values = [
                item["filename"], item["title"], item["category_slug"], item["difficulty"],
                ",".join(item["matched_terms"]), item["description"],
            ]
            print("\t".join(value.replace("\t", " ").replace("\n", " ") for value in values))
    return 0


def command_migrate(args: argparse.Namespace) -> int:
    _, entries, articles = collect_articles(args.root, require_classification=False)
    changes = [article for article in articles if (metadata := parse_frontmatter(article.path)[0]).get("category") != article.category_slug or metadata.get("difficulty") != article.difficulty]
    for article in changes:
        entry = entries[article.filename]
        print(f"{article.filename}\tcategory: {entry.category.slug}\tdifficulty: {entry.difficulty}")
    if args.write:
        for article in changes:
            replace_classification(article.path, article.category_slug, article.difficulty)
        print(f"移行しました: {len(changes)}件")
    else:
        print(f"移行予定: {len(changes)}件（書き込みなし。反映するには --write を指定）")
    return 0


def argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1], help="リポジトリルート")
    parser.add_argument("--db", type=Path, help="SQLite DBのパス（既定: ROOT/.cache/articles.db）")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("validate", help="入力カタログを検証する")
    subparsers.add_parser("build", help="DBを再生成する")
    search = subparsers.add_parser("search", help="記事候補を検索する")
    search.add_argument("terms", nargs="+", help="検索語（既定はOR検索）")
    search.add_argument("--and", dest="and_mode", action="store_true", help="すべての検索語を含む記事だけを返す")
    search.add_argument("--category")
    search.add_argument("--difficulty")
    search.add_argument("--lang")
    search.add_argument("--tag")
    search.add_argument("--limit", type=int, default=20)
    search.add_argument("--json", action="store_true")
    migrate = subparsers.add_parser("migrate", help="category/difficultyをfrontmatterへ移行する")
    migrate.add_argument("--check", action="store_true", help="変更予定だけを表示する（既定）")
    migrate.add_argument("--write", action="store_true", help="変更を書き込む")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = argument_parser()
    args = parser.parse_args(argv)
    args.root = args.root.resolve()
    args.db = (args.db or default_db_path(args.root)).resolve()
    if args.command == "search" and args.limit <= 0:
        parser.error("--limit は1以上で指定してください。")
    try:
        if args.command == "validate":
            return command_validate(args)
        if args.command == "build":
            return command_build(args)
        if args.command == "search":
            return command_search(args)
        if args.command == "migrate":
            return command_migrate(args)
        parser.error("未対応のコマンドです。")
    except IndexError as error:
        print(f"エラー: {error}", file=sys.stderr)
        return 2
    except sqlite3.Error as error:
        print(f"SQLiteエラー: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
