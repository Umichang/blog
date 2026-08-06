# おすすめ記事投稿台帳

この台帳は、日々のおすすめ記事投稿をNotionで管理するための補助です。Xへの投稿操作は自動化しません。

## 初回設定

1. Notionで台帳を置く空の親ページを作り、作成したInternal Integrationをそのページへ接続する。接続には Content の Read / Insert / Update capabilities が必要である。
2. 親ページURLから32文字のIDを取り出し、環境変数へ設定する。
3. リポジトリ直下で初期化を実行する。

```sh
export NOTION_TOKEN='secret_...'
export NOTION_PARENT_PAGE_ID='親ページID'
ruby scripts/sync-recommendation-posts.rb --init
```

初期化で作られる `.notion-recommendation-sync.yml` はローカル設定であり、Gitには追加しない。トークンはこのファイルへ保存しない。

`--init` はNotionの2 DB作成と、`index.md` に掲載された公開記事の初回同期を続けて行う。記事を追加・修正した後は、次のコマンドで同期する。

```sh
ruby scripts/sync-notion-articles.rb
```

このラッパーは標準で `~/.config/umichang-blog/notion.env` を読み込む。別の場所を使う場合は `NOTION_ENV_FILE=/path/to/notion.env` を指定する。環境ファイルは通常の `export NOTION_TOKEN='secret_...'` または `NOTION_TOKEN='secret_...'` の1行だけにし、シェルコードは書かない。

トークンを含むため、作成直後に所有者だけが読める権限へ変更する。

```sh
chmod 600 ~/.config/umichang-blog/notion.env
```

## 過去のおすすめ投稿の取り込み

Xの「データのアーカイブ」を要求・ダウンロードしてから、ZIPのまま、または展開済みフォルダを渡す。ブログURLを含む投稿だけが対象になる。同じアーカイブを再実行しても、X投稿IDが既存なら重複を作らない。

```sh
ruby scripts/sync-recommendation-posts.rb --import-x-archive /path/to/twitter-archive.zip
```

短縮URLの展開先と、`.md`／`.html`の表記ゆれを正規化して記事へ紐付ける。記事が見つからない投稿は削除せず、状態を「要確認」として保存する。

## Notionで作るビュー

Notion APIはビューの作成・編集をサポートしていないため、初期化後にNotion画面で以下を一度だけ作成する。

| ビュー名 | 対象 | フィルター／並び順 |
| --- | --- | --- |
| 今日の候補 | 記事 | `紹介除外` が未チェック。`最終紹介日` を昇順（空欄を先頭）、次に `紹介回数` を昇順。 |
| 下書き | おすすめ投稿履歴 | `状態` が `下書き`。 |
| 投稿履歴 | おすすめ投稿履歴 | `状態` が `投稿済み`、`投稿日` を降順。 |
| 要確認 | おすすめ投稿履歴 | `状態` が `要確認`。 |

## 毎日の運用

1. 「今日の候補」で記事を選び、「おすすめ投稿履歴」に新しい行を作る。
2. 本文を書き、記事をRelationで結び、状態を「下書き」にする。
3. これまでどおりXから手動投稿する。
4. 投稿後、同じ行の状態を「投稿済み」にし、投稿日・X URL・X投稿IDを記録して `紹介済み` をチェックする。

再紹介は可能である。記事側の「紹介回数」と「最終紹介日」を見て選ぶ。
