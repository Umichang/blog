# 記事カタログのDB化 設計書

対象読者：Codex（実装担当）。本ドキュメントはClaude（校閲者AI）がプロトタイプ検証を経て作成した。実装そのものはCowork環境（コーディングに不向き）では行わず、この設計書をもとにCodex側で行う想定。

## 1. 背景と目的

現状、記事の重複判定・棚卸しは`ARTICLES.md`という手書きの単一Markdownファイルに依存している。記事が増えるたびにこのファイルも増え、重複判定のたびに全文を読み書きする必要があり、AIの読み込みコストが記事数に比例して増え続ける。

分解すると、現在の作業には性質の異なる2種類が混在している。

- 機械的に済む部分：ファイル名の突き合わせ、キーワード検索による候補の絞り込み、カテゴリ・難易度の管理
- AIの理解が必要な部分：絞り込んだ候補について「意味的に重複しているか」「どう差別化するか」を判断すること

前者をSQLite（+全文検索）に切り出し、後者だけをAIに残すことで、記事数が増えてもAIの読み込みコストを一定に近づけることが目的である。

## 2. 真実の情報源とDBの位置づけ

DBはリポジトリの`.md`ファイル群と`index.md`から機械的に再生成できる**派生キャッシュ**であり、真実の情報源ではない。

- 真実の情報源：各記事の frontmatter、および `index.md` のカテゴリ・難易度割り当て
- DBファイル（例：`articles.db`）：gitにコミットしない。ビルド成果物として`.gitignore`へ追加する
- 生成スクリプトは冪等（何度実行しても同じ結果になる）にし、リポジトリの状態から常に作り直せることを保証する

この設計により、「frontmatterと別カタログの内容がずれる」という、今回の作業以前に実際に発生した事故（ARTICLES.mdへの言及漏れ66件、2026年8月3日発覚）が構造的に起きなくなる。DBはfrontmatterのビューでしかないため、ずれようがない。

## 3. frontmatterスキーマ（うみちゃん承認済み、2026年8月）

既存の`description`に加え、以下を追加する。

| フィールド | 型 | 必須 | 説明 |
| --- | --- | --- | --- |
| `category` | string（slug） | 新規記事は必須、既存記事は後述の移行方法で自動付与 | 単一カテゴリ。台帳（後述）で管理し、増減自由 |
| `difficulty` | `green` / `yellow` / `red` | 同上 | 現行index.mdの🟢🟡🔴に対応 |
| `tags` | list of string | 任意 | カテゴリを横断する自由記述キーワード。重複判定の検索精度を上げる本体 |
| `related` | list of string（ファイル名） | 任意 | 明示的に差別化した既存記事のファイル名 |
| `translation_of` | string（ファイル名） | 翻訳版のみ | 元記事のファイル名。`lang`（既存フィールド）とは別軸の情報 |

`category`は固定enumにしない。カテゴリ名・粒度は記事が増えるにつれて増減・改名される前提（うみちゃん指示）。そのため、カテゴリの正準リストは記事のfrontmatterではなく、下記4節の`categories`テーブル（またはそれに相当する小さな設定ファイル）側で管理し、記事側はslugだけを持つ。カテゴリ名を後で改名・統合したくなった場合、記事232本分のfrontmatterを書き換えず、`categories`テーブルの該当行を直すだけで済む。

既存記事の`category`と`difficulty`は、`index.md`の現行の手作業割り当て（H3見出しごとのリンク列挙、リンク末尾の🟢🟡🔴）から機械的に逆算できる。プロトタイプで実際に232記事中231記事を自動割り当てできることを確認済み（5節参照）。`tags`と`related`は既存記事は空のまま出発し、新規記事から前向きに蓄積する。

## 4. DBスキーマ

```sql
CREATE TABLE articles (
    filename TEXT PRIMARY KEY,
    title TEXT,
    description TEXT,
    category_slug TEXT,
    category_heading TEXT,   -- 表示用の日本語見出し（categoriesテーブルとの非正規化コピー、再生成時に同期）
    difficulty TEXT,
    lang TEXT,
    tags TEXT,                -- カンマ区切り等、実装時に決定
    related TEXT,
    translation_of TEXT
);

CREATE TABLE categories (
    slug TEXT PRIMARY KEY,
    heading TEXT,             -- index.mdの見出し文言（絵文字込み）
    parent_group TEXT         -- 「ゲーム体験と表現」等、index.mdのH2グループ
);

-- 全文検索（5節の既知の制約を踏まえ、trigramトークナイザを使用）
CREATE VIRTUAL TABLE articles_fts USING fts5(
    filename UNINDEXED, title, description, tags,
    content='articles', content_rowid='rowid',
    tokenize='trigram'
);
```

候補管理（ARTICLES.mdの「新規記事候補」「却下履歴」に相当、5節で触れる将来拡張）は本設計書のスコープ外とし、7節で選択肢のみ示す。

## 5. プロトタイプ検証結果

Cowork環境のシェルサンドボックス（Python 3.10 / SQLite 3.37.2）で以下を検証した。スクリプト全文は8節に添付する。

**カテゴリ・難易度の自動割り当て**：`index.md`をH3見出し単位でパースし、リンク行から`(ファイル名 → カテゴリ見出し, 難易度絵文字)`を機械抽出。リポジトリ内の232記事中231記事に自動でカテゴリ・難易度が付与された。割り当てられなかった1件は`analytics.md`で、これは記事ではなくアクセス解析についての付随ページであることが既知（校閲者AIの作業メモリに記録済み）であり、想定どおりの結果である。

**全文検索の落とし穴（重要）**：SQLite FTS5の既定トークナイザ（unicode61）は空白区切りを前提とするため、日本語のような分かち書きされない言語では単語境界を正しく拾えない。実際に`銀行`で検索してもヒット件数0件になることを確認した（該当記事の説明文に「銀行」という文字列が含まれているにもかかわらず）。

対策として`tokenize='trigram'`（3文字連続のn-gram）に切り替えたところ、3文字以上のクエリ語では正しくヒットするようになった（例：`ガチャ OR 課金`で6件、`ローカライズ`で5件、いずれも意味的に妥当な記事が返る）。

ただし、trigramトークナイザには**2文字以下のクエリ語がヒットしない**という制約がある（3文字未満だとトライグラムを1つも構成できないため）。実際に`銀行`（2文字）は0件、`銀行に`（3文字）は1件正しくヒット、という違いを確認した。日本語の名詞には2文字語が多い（銀行、決済、課金 等）ため、これは無視できない制約である。

**対策**：2文字以下のクエリ語に限り、`LIKE '%語%'`によるフォールバック検索を併用する。この規模（記事232件）であれば全件LIKEスキャンでも1ミリ秒未満で完了することを確認済みであり、性能上の懸念はない。実装では「3文字以上はFTS、それ未満はLIKE、または両方を常に実行してUNIONする」のいずれかで良い。

**コスト比較の参考値**：現行の`ARTICLES.md`は約79KB（バイト数、2026年8月14日時点）。的を絞ったクエリ1件の結果は数百文字程度に収まる。オーダーで2桁以上の差がある。

## 6. 生成スクリプトの実装要件

- 言語：Python想定（リポジトリには`scripts/`配下に既存のRuby資産（Notion同期用）があるが、DB生成・検索は言語を揃える必然性はない。Codexの判断に委ねる）
- 配置：`scripts/build_article_index.py`（仮）。実行のたびに`articles.db`をゼロから作り直す（差分更新ではなく全再生成でよい規模）
- DB出力先：リポジトリ直下ではなく、`.gitignore`対象のパス（例：`.cache/articles.db`）を推奨。Cowork環境のプロトタイプでは、リポジトリの接続フォルダ（ネットワークマウント経由）へ直接SQLiteファイルを書き込もうとして`disk I/O error`が発生した。ローカルの一時ディレクトリへ書いてから必要な範囲だけコピーする、または最初からマウント外に生成するなど、実行環境に応じた回避が必要になる可能性がある
- 冪等性：何度実行しても同じ入力から同じ出力になること
- カテゴリ台帳の初期値：8節のプロトタイプスクリプト内`CATEGORY_SLUGS`辞書をそのまま初期データとして使ってよい（21カテゴリぶんのslug案を含む）。slugの命名はCodex・うみちゃんの判断で変更して構わない

## 7. 運用フローの移行（要判断）

以下は設計上の選択肢であり、うみちゃんの判断が必要な部分。本設計書では決定しない。

- **ARTICLES.mdの扱い**：即時廃止か、しばらく併存させて移行期間を置くか。個人的な見立てとしては、「完成済み記事一覧」（重複防止の主目的）はDBへ完全移管して廃止し、「新規記事候補・却下履歴」（まだ機械化の設計をしていない部分）は当面ARTICLES.mdに残す、という段階的な移行が現実的だと考えている
- **候補・却下履歴のテーブル化**：`candidates(topic, status, reason, date, related_slug)`のようなテーブルを設ける案は3節までの検討で触れたが、詳細設計は未着手。次のフェーズで扱う
- **本文全文の索引化**：今回のプロトタイプは`description`（frontmatter）のみを索引化した。将来的に記事本文全体を索引に含めれば再現率が上がるが、生成コスト・DBサイズとのトレードオフがあるため今回は対象外とした

## 8. プロトタイプスクリプト（参考実装）

以下はCowork環境で実際に動作確認したスクリプトそのもの。Codexの実装の出発点として使ってよいが、本番実装では7節の判断待ち事項やエラーハンドリングを別途詰める必要がある。

```python
#!/usr/bin/env python3
"""
プロトタイプ：記事frontmatter + index.mdのカテゴリ/難易度をSQLite(FTS5)へ投入する。

真実の情報源は常にリポジトリの.mdファイル（frontmatter）とindex.mdの手作業割り当てであり、
このDBはそこから再生成できる派生キャッシュとして扱う。DBファイル自体はコミットしない想定。
"""
import glob
import re
import sqlite3
from pathlib import Path

REPO = Path("/path/to/blog")  # 実行環境に合わせて変更
DB_PATH = Path("/path/to/output/articles.db")  # gitignore対象、マウント外を推奨

# index.mdの現行21カテゴリ見出し → 英語slugの初期マッピング（増減・改名自由）
CATEGORY_SLUGS = {
    "🎨 ビジュアル・空間表現": "visual-spatial-design",
    "🔊 サウンド・音声": "sound-audio",
    "🧠 AI・ゲーム内知性": "game-ai",
    "🎮 操作・インターフェイス": "controls-interface",
    "🌐 オンライン・ネットワーク": "online-network",
    "🧩 ゲームシステム・プレイヤー体験": "game-systems-player-experience",
    "📖 物語・世界設定・謎解き": "narrative-worldbuilding-puzzle",
    "🎲 ジャンル・ゲーム文化": "genre-game-culture",
    "🛠️ 企画・仕様・開発プロセス": "planning-spec-dev-process",
    "🎬 他メディアIPのゲーム化": "ip-adaptation",
    "🧰 技術基盤・データ・アセット": "tech-foundation-data-assets",
    "🧪 品質保証・デバッグ・リリース": "qa-debug-release",
    "🌏 ローカライズ・音声制作": "localization-voice-production",
    "🤝 運営・コミュニティ": "operations-community",
    "💰 ビジネス・市場・マネタイズ": "business-market-monetization",
    "⚖️ 法務・規制": "legal-regulation",
    "📈 計測・分析": "analytics-measurement",
    "🕹️ プラットフォーム・ハードウェア": "platform-hardware",
    "📜 ゲーム史・文化史": "game-history-culture",
    "👤 人物・企業史": "people-company-history",
    "✨ 番外編": "extras",
}

DIFFICULTY_MAP = {"🟢": "green", "🟡": "yellow", "🔴": "red"}


def parse_index_md(text: str):
    """index.mdをH3見出しごとに分割し、各リンク行から (filename -> category_heading, difficulty) を作る。
    '新着記事'（H2直下でH3を持たない一覧）はカテゴリ由来ではないため除外する。"""
    lines = text.splitlines()
    current_h3 = None
    mapping = {}
    link_re = re.compile(r"\[([^\]]+)\]\(([a-zA-Z0-9_\-/]+\.md)\)\s*(🟢|🟡|🔴)?")
    for line in lines:
        h3 = re.match(r"^### (.+)$", line)
        if h3:
            current_h3 = h3.group(1).strip()
            continue
        h2 = re.match(r"^## (.+)$", line)
        if h2:
            if "新着記事" in h2.group(1) or "まず読む記事" in h2.group(1):
                current_h3 = None
            continue
        if current_h3 is None:
            continue
        m = link_re.search(line)
        if m:
            filename = m.group(2)
            difficulty_emoji = m.group(3)
            if filename not in mapping:
                mapping[filename] = (current_h3, DIFFICULTY_MAP.get(difficulty_emoji))
    return mapping


def parse_frontmatter(text: str):
    m = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not m:
        return {}
    fm = {}
    for line in m.group(1).splitlines():
        mm = re.match(r'^([a-zA-Z_]+):\s*"?(.*?)"?\s*$', line)
        if mm:
            fm[mm.group(1)] = mm.group(2)
    return fm


def main():
    index_text = (REPO / "index.md").read_text(encoding="utf-8")
    cat_map = parse_index_md(index_text)

    files = sorted(set(glob.glob(str(REPO / "*.md")) + glob.glob(str(REPO / "*/*.md"))))
    exclude_names = {"README.md", "index.md", "introduction.md"}
    exclude_dirs = {"docs", "_site", "vendor", ".bundle", ".git"}

    rows = []
    for fpath in files:
        p = Path(fpath)
        rel = p.relative_to(REPO)
        if p.name in exclude_names or any(part in exclude_dirs for part in rel.parts):
            continue
        text = p.read_text(encoding="utf-8", errors="ignore")
        fm = parse_frontmatter(text)
        if "description" not in fm and "title" not in fm:
            continue

        filename = str(rel)
        cat_heading, difficulty = cat_map.get(filename, (None, None))
        slug = CATEGORY_SLUGS.get(cat_heading) if cat_heading else None

        title_m = re.search(r"^#\s+(.+)$", text, re.MULTILINE)
        title = title_m.group(1).strip() if title_m else fm.get("title", "")

        rows.append({
            "filename": filename, "title": title, "description": fm.get("description", ""),
            "category_slug": slug, "category_heading": cat_heading, "difficulty": difficulty,
            "lang": fm.get("lang"), "tags": "", "related": "", "translation_of": None,
        })

    if DB_PATH.exists():
        DB_PATH.unlink()
    conn = sqlite3.connect(DB_PATH)
    conn.execute("""
        CREATE TABLE articles (
            filename TEXT PRIMARY KEY, title TEXT, description TEXT,
            category_slug TEXT, category_heading TEXT, difficulty TEXT,
            lang TEXT, tags TEXT, related TEXT, translation_of TEXT
        )
    """)
    # trigram: 日本語は分かち書きされないため既定(unicode61)では単語境界が拾えない
    conn.execute("""
        CREATE VIRTUAL TABLE articles_fts USING fts5(
            filename UNINDEXED, title, description, tags,
            content='articles', content_rowid='rowid', tokenize='trigram'
        )
    """)
    conn.executemany(
        """INSERT INTO articles
           (filename, title, description, category_slug, category_heading, difficulty, lang, tags, related, translation_of)
           VALUES (:filename, :title, :description, :category_slug, :category_heading, :difficulty, :lang, :tags, :related, :translation_of)""",
        rows,
    )
    conn.execute("INSERT INTO articles_fts(rowid, filename, title, description, tags) SELECT rowid, filename, title, description, tags FROM articles")
    conn.commit()
    conn.close()


def search(conn, query_terms):
    """query_terms: 検索語のリスト。3文字以上はFTS(trigram)、2文字以下はLIKEで拾う。"""
    long_terms = [t for t in query_terms if len(t) >= 3]
    short_terms = [t for t in query_terms if len(t) < 3]
    hits = {}
    if long_terms:
        fts_query = " OR ".join(long_terms)
        cur = conn.execute(
            "SELECT a.filename, a.title FROM articles_fts f JOIN articles a ON a.rowid=f.rowid WHERE articles_fts MATCH ?",
            (fts_query,),
        )
        for filename, title in cur.fetchall():
            hits[filename] = title
    for t in short_terms:
        cur = conn.execute(
            "SELECT filename, title FROM articles WHERE description LIKE ? OR title LIKE ?",
            (f"%{t}%", f"%{t}%"),
        )
        for filename, title in cur.fetchall():
            hits[filename] = title
    return hits


if __name__ == "__main__":
    main()
```

## 9. 未検証・要検討事項

- `tags`・`related`の実際の運用定着（新規記事の執筆者AIプロンプト雛形に、どう反映させるか）
- カテゴリ台帳の改名・統合をどのUIで行うか（直接SQL、YAML設定ファイル経由、等）
- `candidates`（新規候補・却下履歴）テーブルの詳細設計
- `index.md`自体の生成をこのDBから逆生成する方向（現状は人力更新）へ寄せるかどうか
