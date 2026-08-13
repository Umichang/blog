# 記事カタログDB化 詳細設計

## 1. 目的と設計上の決定

本書は [基本設計](article-index-database.md) を実装可能な単位へ落とした詳細設計である。SQLite DBは公開記事を検索するための派生キャッシュであり、gitにはコミットしない。

今回の実装では、次の三層を明確に分ける。

| 層 | 正準データ | 用途 |
| --- | --- | --- |
| 記事 | 各Markdownのfrontmatter | 記事固有の属性（`category`、`difficulty`、`tags`、`related`、`translation_of`） |
| 分類台帳 | `data/article-categories.yml` | slug、表示見出し、親グループ、表示順 |
| 公開一覧 | `index.md` | 読者向けの掲載順・リンク表示 |

`index.md`とfrontmatterの`category`／`difficulty`は意図的に同じ事実を持つ。ビルダーは両者が一致しない場合に失敗するため、どちらかだけを更新してずれたままDBを作ることはできない。表示見出しや親グループの改名は分類台帳と`index.md`だけを更新し、記事のslugは変更しない。

`ARTICLES.md`は初回移行後、完成済み記事一覧としては参照しない。新規候補・却下履歴は本フェーズの対象外なので、当面は同ファイルに残す。完成済み一覧の削除は、移行・照合を通過したコミットで行う。

## 2. 成果物と配置

| パス | 種別 | 役割 |
| --- | --- | --- |
| `data/article-categories.yml` | git管理 | 分類台帳。21分類を初期登録する |
| `scripts/article_index.py` | git管理 | build、search、validate、migrateを提供するCLI |
| `test/article_index_test.py` | git管理 | パース、検証、検索の自動テスト |
| `.cache/articles.db` | git管理外 | SQLite/FTS5の派生キャッシュ |

`.gitignore`には`.cache/`を追加する。DBは一時ファイル`.cache/articles.db.tmp-<pid>`へ生成し、検証後に同一ファイルシステム内の原子的renameで置き換える。失敗時は既存DBを壊さない。

実装言語はPython 3とする。SQLite接続は標準ライブラリの`sqlite3`を使い、frontmatterは`PyYAML`の安全ローダーで読む。`requirements-dev.txt`に`PyYAML`を明記し、起動時にはSQLiteのFTS5とtrigramトークナイザが使用可能かを検査して、不足時には原因を示して終了する。

## 3. 分類台帳

`data/article-categories.yml`の形式を次で固定する。

```yaml
schema_version: 1
categories:
  - slug: visual-spatial-design
    heading: "🎨 ビジュアル・空間表現"
    parent_group: "🎮 ゲーム体験と表現"
    display_order: 10
```

- `slug`は`[a-z0-9]+(?:-[a-z0-9]+)*`で一意とする。
- `heading`は一意とする。`index.md`の分類見出しと完全一致しなければならない。
- `parent_group`は`index.md`のH2見出しと完全一致しなければならない。
- `display_order`は親グループ内で一意とする。DB検索の既定並びには使わず、将来の一覧生成時の安定順序に使う。
- 基本設計の21 slug案を初期値に採用する。`✨ 番外編`も独立した`extras`として登録する。

カテゴリ改名は、slugを変えずに台帳の`heading`と`index.md`の該当見出しを同一コミットで変更する。slugの統合・廃止は記事frontmatterを変更する移行であり、通常の表示名変更として扱ってはならない。

## 4. 記事frontmatter契約

公開一覧に載る記事は次を満たす。

```yaml
---
description: "検索・SNS向けの要約"
category: planning-spec-dev-process
difficulty: yellow
tags:
  - プロトタイピング
  - 仕様策定
related:
  - game-non-functional-requirements.md
translation_of: original-article.md
---
```

- `description`、`category`、`difficulty`は必須である。
- `difficulty`は`green`、`yellow`、`red`のいずれかとし、`index.md`ではそれぞれ🟢、🟡、🔴に対応する。
- `tags`と`related`は省略時に空配列として扱う。指定時は空文字列を含まない文字列配列であり、重複を禁止する。
- `related`と`translation_of`はリポジトリ相対の`.md`ファイル名であり、公開記事としてDBに収録される既存ファイルを指す。自己参照は不可とする。
- `lang`は既存任意フィールドとして保存するが、未指定時はNULLである。言語の既定値をDB側で補完しない。
- frontmatterの未知のキーは許容し、DB化対象だけを読む。YAML alias、複合キー、非文字列キーは拒否する。

新規記事は`index.md`へ分類リンクを追加する時点で、同じslugと難易度をfrontmatterへ記入する。`update-recent-articles.rb`の既存引数・難易度絵文字の契約は本フェーズでは変更しない。

## 5. `index.md`のパース規則

対象は「まず読む記事」「新着記事」を除く、分類領域のローカルMarkdownリンクだけである。リンクは行全体が次の形であることを要求する。

```text
- [表示タイトル](relative/path.md) 🟢
```

パーサーは見出しレベルをスタックとして保持する。各リンクについて、最も近いH3を分類見出しにする。ただし分類台帳にH2自体が登録されている場合は、そのH2直下のリンクをそのH2分類として扱う。

この例外は必須である。現行の`✨ 番外編`はH2直下に`making-this-blog-with-ai-tools.md`を置くため、H2でH3状態を必ずリセットしなければ、直前の`👤 人物・企業史`へ誤分類される。H2遷移時に古いH3を残すプロトタイプ実装は採用しない。

ビルド時には以下をエラーにする。

- 同一ファイルが異なる分類または難易度で複数回掲載されている
- カテゴリリンクに難易度がない、または許可されない絵文字がある
- リンク先がリポジトリ外を指す、存在しない、frontmatterまたはH1がない
- 分類見出しが台帳にない、または台帳の親グループとH2が一致しない
- 台帳の分類が`index.md`にない（廃止予定の分類も放置しない）
- frontmatterの`category`／`difficulty`と、リンクから得た値が一致しない

カテゴリ一覧は`index.md`から、記事内容はリンク先から読む。未掲載の下書き、`analytics.md`、`docs/`、`ARTICLES.md`、`CLAUDE.md`、`README.md`、`introduction.md`はDBに入れない。この選び方により、DBの収録対象は「公開カタログに載っている記事」と明確になる。

## 6. SQLiteスキーマ

DBのスキーマバージョンは`meta`テーブルに保存する。DBは全再生成するため、マイグレーションSQLは持たない。バージョン不一致のDBは検索せず、buildを要求する。

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE meta (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

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
  filename UNINDEXED,
  title,
  description,
  tags_text,
  content='articles',
  content_rowid='rowid',
  tokenize='trigram'
);
```

`category_heading`は記事テーブルに複製しない。検索時に`categories`をJOINすればよく、再生成DBにも二重の真実を作らない。`tags_text`だけはFTS投入用にタグを改行連結した派生列として保存する。`article_tags`がタグの正規データである。

`meta`には少なくとも`schema_version`、`source_digest`、`generator_version`を入れる。時刻は入れない。`source_digest`は分類台帳、`index.md`、収録するMarkdownの相対パスとUTF-8バイト列をソート順でSHA-256へ投入した値とする。

## 7. ビルド処理

`build`は次の順で実行する。

1. リポジトリルート、分類台帳、`index.md`を解決する。
2. 分類台帳を構文・一意性・slug形式について検証する。
3. `index.md`を見出しスタックで読み、公開記事の分類・難易度マップを作る。
4. 各リンク先のfrontmatterを安全に読み、H1、必須属性、型、参照先を検証する。
5. index由来の属性とfrontmatter由来の属性を照合し、エラーが一つでもあればDBを作らない。
6. 一時DBにスキーマ、台帳、記事、タグ、関連、翻訳を投入する。
7. `INSERT INTO articles_fts(articles_fts) VALUES ('rebuild')`で外部コンテンツFTSを構築する。
8. `foreign_key_check`、`integrity_check`、記事件数とFTS件数の一致、サンプル検索を検証する。
9. `source_digest`を書き、コミットしてから原子的に`.cache/articles.db`へ置き換える。

全入力をソートして処理し、出力メッセージもファイル名順にする。DBバイナリそのもののページ配置はSQLite実装に依存するため一致要件に含めず、同じ入力に対して同じ論理行、`source_digest`、検索結果を返すことを冪等性と定義する。

## 8. 検索設計

### CLI

```text
python3 scripts/article_index.py build
python3 scripts/article_index.py validate
python3 scripts/article_index.py search ガチャ 課金 --limit 20
python3 scripts/article_index.py search 銀行 --category business-market-monetization
python3 scripts/article_index.py search ローカライズ --difficulty green --json
```

- `build`はDBを再生成する。終了時に記事数、カテゴリ数、FTS件数、`source_digest`を表示する。
- `validate`はDBを書き換えず、入力層だけを検証する。
- `search`は検索語を一つ以上取り、既定ではOR検索する。`--and`は全語一致を要求する。
- 絞り込みは`--category SLUG`、`--difficulty green|yellow|red`、`--lang LANG`、`--tag TAG`を提供する。
- 既定出力は1行1記事のTSV（`filename`、`title`、`category_slug`、`difficulty`、`matched_terms`、`description`）である。`--json`は同じ情報を配列で返す。

### 日本語検索のアルゴリズム

各検索語をUnicode正規化（NFC）して前後空白を除く。3文字以上の語は、FTS5 trigramの完全引用した単一語クエリで検索する。2文字以下の語は、`filename`、`title`、`description`、`tags_text`に対して`LIKE ? ESCAPE '\\'`を使う。`%`、`_`、`\\`は必ずエスケープする。

語ごとのヒットを`filename`で和集合にし、`--and`では共通集合にする。表示順は、(1) 一致した検索語数の降順、(2) FTSの合計`bm25`の昇順、(3) filename昇順とする。LIKEのみの結果はFTS順位をNULLとして(2)の後ろに置く。検索語をSQLやFTS構文として解釈しないため、記号を含む語も入力エラーまたは安全なリテラルとして扱える。

検索は候補抽出であり、意味的な重複判定を自動化しない。AIには上位候補のタイトル、要約、タグ、明示的関連を読ませ、差別化の判断だけを任せる。

## 9. frontmatter移行

移行コマンドは`migrate --check`と`migrate --write`を提供する。

1. `--check`で現在の`index.md`からカテゴリ・難易度を算出し、変更予定ファイルと差分を表示する。
2. `--write`は`category`と`difficulty`だけをfrontmatterへ追加または置換する。既存のキー順、コメント、引用符、複数行の`description`を壊さない最小編集方式とし、YAMLの全体ダンプで書き直さない。
3. `tags`、`related`、`translation_of`は既存記事に空キーを一括追加しない。省略を空配列として扱い、新規記事から必要なものだけを付ける。
4. 書き込み後に`validate`、`build`、検索スモークテストを実行する。

初回移行時は231件の分類リンクを基準とする。現行確認では、リンク先の欠落と分類衝突は0件であり、H2直下の番外編は1件である。件数は将来の記事追加で増えるため、テストには固定値でなく「分類リンク数＝DB記事数」を置く。

## 10. テストと受け入れ条件

`test/article_index_test.py`で少なくとも次をテストする。

- H2でH3状態がリセットされ、番外編が`extras`になる。
- 新着記事・まず読む記事の重複リンクを収録しない。
- 難易度絵文字とfrontmatter値の対応、未知slug、未掲載台帳、重複分類を検出する。
- YAMLの配列、空配列、`lang`、不正な型、自己参照・存在しない関連先を検証する。
- 3文字以上の日本語語がFTSで、2文字語がLIKEで検索できる。
- `%`、`_`、引用符を含む検索語がSQL/FTS注入にならない。
- `--and`、各フィルタ、TSV、JSON、空ヒット、DB未生成時の終了コードを検証する。
- 二回のbuildで論理テーブル内容と`source_digest`が一致する。

実装完了の受け入れ条件は、(a) 全テストが通ること、(b) `validate`と`build`が成功すること、(c) DB記事数が分類済み`index.md`リンク数と一致すること、(d) `bank`のような3文字以上と`銀行`のような2文字語の両方で期待記事を返すこと、(e) `git diff --check`が通ること、である。

## 11. 実装順とロールバック

1. 分類台帳、`.gitignore`、依存定義、パーサー単体テストを追加する。
2. `validate`と`migrate --check`を実装し、現行カタログで差分を監査する。
3. `migrate --write`でfrontmatterを更新し、レビュー後にコミットする。
4. SQLite buildと検索を追加し、実データで受け入れ条件を満たすことを確認する。
5. `CLAUDE.md`の完成済み記事一覧参照手順をDB検索へ切り替え、`ARTICLES.md`から完成済み一覧だけを除去する。

ロールバックはgitで分類台帳・スクリプト・frontmatter変更を戻し、`.cache/articles.db`を削除してから従来の`ARTICLES.md`運用へ戻す。DBは派生物であるため、ロールバック対象に含めない。

候補・却下履歴のSQLite化、本文全文索引、`index.md`自動生成、Notion同期へのDB利用は本フェーズに含めない。これらは公開記事カタログの移行が安定した後に別設計とする。
