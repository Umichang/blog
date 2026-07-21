# うみちゃんの書き物置き場

ゲームや技術に関する記事を置いているブログリポジトリです。ゲームデザイン、ゲーム史、AI、サウンド、操作インターフェイス、オンライン技術、ビジネス、法務・規制など、ゲームを作る人・考える人向けの調査記事をまとめています。

記事の一覧は [こちら](https://umichang.github.io/blog/) を参照してください。

## 公開

このブログは GitHub Pages で公開しています。

リポジトリに変更を push すると、GitHub Pages によって HTML が自動生成されます。

## アクセス解析の有効化

計測タグは、識別子が設定されるまで公開サイトに出力されない。Cloudflare Web Analytics と Google Search Console を有効にする場合は、`_config.yaml` の次の値を設定して公開する。

```yaml
analytics:
  cloudflare_web_analytics_token: "Cloudflare が発行した token"
  google_search_console_verification: "Google が発行した verification content"
  started_on: "公開日（YYYY-MM-DD）"
```

Cloudflare の token は Web Analytics でホスト名 `umichang.github.io` を追加して取得する。Google Search Console は URL プレフィックス `https://umichang.github.io/blog/` を追加し、HTML タグ方式で取得した `content` の値のみを設定する。設定後は公開ページの HTML でタグが各 1 回だけ出力されることを確認する。

## ライセンス

このリポジトリの文章は、注記がない限り MIT License で提供しています。詳細は [LICENSE](LICENSE) を参照してください。
