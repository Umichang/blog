---
title: アクセス解析について
description: このサイトで利用しているアクセス解析の方針
---

# アクセス解析について

このサイトでは、コンテンツの利用状況と表示品質を改善するために、Cloudflare Web Analytics を利用しています。閲覧者を広告目的で追跡したり、個人を識別したりするためのアクセス解析は行っていません。

Cloudflare Web Analytics では、ページビュー、訪問、閲覧されたページ、参照元、端末種別、ブラウザ、国、ページの読み込み時間、Core Web Vitals を集計しています。ボットを除外した集計も利用しています。

Cloudflare Web Analytics による計測では、Cookie、localStorage、個人を識別するフィンガープリントを使用していません。Cloudflare が扱うデータとプライバシーに関する説明は、[Cloudflare Web Analytics のドキュメント](https://developers.cloudflare.com/web-analytics/about/)をご参照ください。

## 表示設定の保存

画面右上の表示テーマを選択した場合は、その選択（ライト／ダーク／システム）を、ブラウザ内の localStorage に `theme-preference` という名前で保存します。これは次回以降の表示テーマを再現するためだけに使う設定値であり、個人情報、閲覧履歴、広告識別子、アクセス解析用の識別子は保存しません。また、この設定値を Cloudflare Web Analytics や Google Search Console へ送信しません。

ブラウザの保存領域を利用できない場合は、テーマ選択を保存せず、そのページではシステムの表示設定に従います。

{% assign analytics_started_on = site.analytics.started_on | default: "" %}
{% unless analytics_started_on == "" %}
計測開始日は {{ analytics_started_on }} です。これより前の GitHub Pages のページビューは、本サイトでは復元しません。
{% else %}
計測開始日は、アクセス解析の有効化時にこのページへ記録します。これより前の GitHub Pages のページビューは、本サイトでは復元しません。
{% endunless %}

また、Google Search Console を利用して、Google 検索におけるクリック数、表示回数、クリック率、平均掲載順位を確認しています。これらは、記事の見つけやすさを改善するためにのみ利用しています。
