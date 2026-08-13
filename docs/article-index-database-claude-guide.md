# 記事カタログDB 利用・レビューガイド（Claude向け）

## 1. この仕組みで行うこと

公開済み記事との重複候補を、手書きの完成済み記事一覧ではなくSQLite検索で絞り込む。DBは各記事のfrontmatter、`data/article-categories.yml`、`index.md`から毎回再生成する派生キャッシュであり、gitには保存しない。

検索結果は候補抽出である。Claudeは返された記事のタイトル・要約・タグ・明示的関連を読み、テーマが意味的に重複するか、どの切り口なら差別化できるかを判断する。

候補・却下・見送りの履歴は、従来どおり`ARTICLES.md`を参照・更新する。公開済み記事を同ファイルへ追記しない。

## 2. 最短の利用手順

リポジトリルートで、候補の検討前に次を実行する。

```sh
python3 scripts/article_index.py build
python3 scripts/article_index.py search 検索語 --limit 20
```

例えば、銀行とゲーム規制の関係を検討する場合は次のように検索する。

```sh
python3 scripts/article_index.py search 銀行 規制 --limit 20
```

既定では複数語はOR検索である。すべての語を含む記事だけに絞るには`--and`を付ける。

```sh
python3 scripts/article_index.py search ガチャ 課金 --and --limit 20
```

検索結果が0件でも、そのことだけで新規性を結論づけない。表現が異なる既存記事や、候補・却下履歴に残る判断を確認するため、関連する言い換え・作品名・メカニクス・制度名でも検索し、`ARTICLES.md`も読む。

## 3. 検索対象と出力の読み方

検索対象は、`index.md`の分類一覧に掲載されている公開記事231件（初回移行時点）である。`analytics.md`、`docs/`配下、未掲載の下書き、`ARTICLES.md`は検索対象外である。

通常出力はTSVで、1行が1記事である。

```text
filename<TAB>title<TAB>category_slug<TAB>difficulty<TAB>matched_terms<TAB>description
```

- `filename`：記事本文を確認するためのファイル名
- `title`：記事のH1
- `category_slug`：機械処理用のカテゴリ識別子
- `difficulty`：`green`／`yellow`／`red`。`index.md`の🟢／🟡／🔴と対応する
- `matched_terms`：その記事をヒットさせた検索語
- `description`：重複・差別化の一次判断に使う要約

機械処理やレビュー報告に取り込む場合は`--json`を使う。

```sh
python3 scripts/article_index.py search ローカライズ --difficulty green --json
```

利用可能な絞り込みは次のとおりである。

```sh
# 特定カテゴリだけを検索する
python3 scripts/article_index.py search 物理 --category planning-spec-dev-process

# 読みやすさで絞り込む
python3 scripts/article_index.py search AI --difficulty green

# 将来付与されるタグで絞り込む
python3 scripts/article_index.py search イベント --tag ライブサービス

# langを持つ記事だけに絞り込む
python3 scripts/article_index.py search gacha --lang en-US
```

カテゴリslugの一覧は`data/article-categories.yml`で確認する。

## 4. 日本語検索の特性

3文字以上の検索語はSQLite FTS5のtrigram全文検索を使う。2文字以下の語は、タイトル・要約・タグ・ファイル名に対する安全な部分一致検索へ自動的に切り替わる。

そのため、次のどちらも利用できる。

```sh
python3 scripts/article_index.py search 銀行
python3 scripts/article_index.py search ローカライズ
```

本文全文は今回の索引対象ではない。説明文にない固有の仕様・引用・事例を調べたい場合は、検索結果の本文を開くか、必要に応じて`rg`で本文を補助検索する。

## 5. 新規記事を完成・掲載した後の更新手順

新規記事を`index.md`の通常カテゴリへ掲載する前に、frontmatterへ最低限次を入れる。

```yaml
---
description: "検索・SNS向けの要約"
category: planning-spec-dev-process
difficulty: yellow
---
```

`category`は`data/article-categories.yml`のslug、`difficulty`は`green`、`yellow`、`red`のいずれかである。`index.md`の同じ記事リンクには対応する🟢、🟡、🔴を一つ付ける。

必要な場合だけ、次の任意フィールドを追加する。

```yaml
tags:
  - プロトタイピング
  - 仕様策定
related:
  - game-non-functional-requirements.md
translation_of: original-article.md
```

- `tags`は検索精度を上げる横断キーワードである。
- `related`は、差別化を明示した既存の公開記事ファイル名である。
- `translation_of`は翻訳版だけに付ける元記事ファイル名である。
- `related`と`translation_of`の参照先は、公開一覧に載る既存`.md`ファイルでなければならない。

更新後は必ず次を順に実行する。

```sh
python3 scripts/article_index.py validate
python3 scripts/article_index.py build
```

`validate`が失敗した場合はDBを再生成しない。エラーに示されたfrontmatter、カテゴリ台帳、または`index.md`をそろえてから再実行する。通常の公開処理では、この後に既存の`ruby scripts/update-recent-articles.rb 記事ファイル.md`も実行する。

## 6. Claudeレビュー用チェックリスト

実装レビューでは、次を確認する。

1. `python3 scripts/article_index.py validate`が成功する。
2. `python3 scripts/article_index.py build`が成功し、記事数と分類数を出力する。
3. 2回続けて`build`し、`source_digest`が同じであることを確認する。
4. 2文字語（例：`銀行`）と3文字以上の語（例：`ローカライズ`）が検索できる。
5. `--and`、`--category`、`--difficulty`、`--json`が期待どおりに絞り込む。
6. `index.md`の新着記事・まず読む記事は検索DBへ重複登録されず、分類一覧の掲載だけが登録される。
7. `✨ 番外編`のH2直下にある記事が、直前のH3カテゴリへ誤分類されない。
8. frontmatterの`category`・`difficulty`と、`index.md`の分類・難易度が異なる場合に`validate`が失敗する。
9. `.cache/articles.db`が`.gitignore`対象であり、DBをコミットしない。

自動テストは次で実行できる。

```sh
python3 -m unittest discover -s test -p 'article_index_test.py'
```

## 7. 失敗時の見方

| 表示例 | 原因 | 対応 |
| --- | --- | --- |
| `category が分類台帳のslugではありません` | frontmatterのslugが未定義、または未記入 | `data/article-categories.yml`のslugへ合わせる |
| `frontmatter(...) と index.md(...) が一致しません` | 記事属性と掲載分類・難易度の片方だけを更新した | 両方を同じ分類・難易度にそろえる |
| `カテゴリがindex.mdにありません` | 台帳だけに分類を追加した | `index.md`へ対応する分類見出しを追加するか、台帳変更を戻す |
| `DBがありません` | `search`の前に未生成、またはキャッシュを削除した | `build`を実行する |
| `SQLite FTS5 trigramトークナイザが利用できません` | 使用中PythonのSQLiteが要件を満たさない | FTS5/trigram対応のPython環境で実行する |

PyYAMLがない環境では、`requirements-dev.txt`に従って導入する。

```sh
python3 -m pip install -r requirements-dev.txt
```

## 8. レビュー範囲外

候補・却下履歴のDB化、記事本文全文の索引化、`index.md`の自動生成、Notion同期へのDB接続は実装していない。これらは現在の検索・検証基盤を確認した後の別フェーズである。
