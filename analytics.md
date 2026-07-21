---
title: アクセス解析について
description: このサイトで利用しているアクセス解析の方針
---

# アクセス解析について

このサイトでは、コンテンツの利用状況と表示品質を改善するために、Cloudflare Web Analytics を利用する。閲覧者を広告目的で追跡したり、個人を識別したりするためのアクセス解析は行わない。

Cloudflare Web Analytics では、ページビュー、訪問、閲覧されたページ、参照元、端末種別、ブラウザ、国、ページの読み込み時間、Core Web Vitals を集計する。ボットを除外した集計も利用する。

この計測は Cookie、localStorage、個人を識別するフィンガープリントを使用しない。Cloudflare が扱うデータとプライバシーに関する説明は、[Cloudflare Web Analytics のドキュメント](https://developers.cloudflare.com/web-analytics/about/)を参照してほしい。

{% assign analytics_started_on = site.analytics.started_on | default: "" %}
{% unless analytics_started_on == "" %}
計測開始日は {{ analytics_started_on }} である。これより前の GitHub Pages のページビューは本サイトでは復元しない。
{% else %}
計測開始日は、アクセス解析の有効化時にこのページへ記録する。これより前の GitHub Pages のページビューは本サイトでは復元しない。
{% endunless %}

また、Google Search Console を利用して、Google 検索におけるクリック数、表示回数、クリック率、平均掲載順位を確認する。これらは記事の見つけやすさを改善するためにのみ利用する。
