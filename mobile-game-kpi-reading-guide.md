# モバイルゲームのKPI読み方入門——数字の意味と、数字だけに騙されない判断力
<script>
  window.MathJax = {
    tex: {
      inlineMath: [['\\(', '\\)']],
      displayMath: [['$$', '$$'], ['\\[', '\\]']]
    },
    options: { skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'] }
  };
</script>
<script type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>

***

## はじめに

ゲームプランナーとして運営型モバイルゲームに携わると、毎日大量の数字と向き合うことになる。DAU、MAU、リテンション率、ARPU、ARPPU、LTV、CPI——これらのKPI（重要業績評価指標）は、チームの議論や意思決定の中心に置かれる。

しかし「数字が読める」ことと「数字から正しく判断できる」ことは別物だ。新米プランナーが陥りやすいのは、**数字の定義を覚えることに満足し、その数字が何を示していて何を示していないかを考えない** ことである。この記事では主要KPIの定義と計算式を整理しつつ、それぞれの「限界と落とし穴」にも踏み込む。

***

## 第1章：エンゲージメント指標

### DAU・MAU——「誰がどれだけ来ているか」

**DAU（Daily Active Users）** は1日に1回以上ゲームを起動したユニークユーザー数、**MAU（Monthly Active Users）** は30日間で少なくとも1回起動したユニークユーザー数だ。この2つはゲームの規模と活況を示す最も基本的な指標であり、グラフとして可視化したとき、増加傾向か減少傾向かを確認する最初の窓口になる。[[1](#ref-1)][[2](#ref-2)]

**⚠️ 落とし穴：「アクティブ」の定義はスタジオによって異なる**

「アクティブ」の定義は「ゲームを開いた」だけで足りるか、それとも「少なくとも1ゲーム対戦した」や「チュートリアルを完了した」まで求めるか——これに正解はなく、チームで統一する必要がある。定義が曖昧なまま比較すると、競合他社との比較も社内の前期比較も意味をなさなくなる。また、大型アップデートの直後は「起動しただけで離脱したユーザー」も含むため、DAUが急騰しても実態の改善を意味しないことがある。[[3](#ref-3)]

***

### DAU/MAU比率（スティッキネス）——「どれだけ習慣化されているか」

$$ \text{DAU/MAU比率} = \frac{\text{DAU}}{\text{MAU}} \times 100 $$

この比率は「MAU（月に1回以上遊ぶ人）の中で、毎日遊んでいる人の割合」を示す。習慣形成の強さ＝**スティッキネス（粘着性）** の代理指標として使われる。[[4](#ref-4)][[5](#ref-5)]

業界ベンチマークとしては以下が参考になる：[[6](#ref-6)][[5](#ref-5)]

| 水準 | DAU/MAU比率 | 評価 |
|---|---|---|
| 一般的なゲームアプリ | 15〜20% | 普通 |
| 良好なカジュアルゲーム | 20〜35% | 健全 |
| 優れたゲーム（例：ソーシャル系） | 35〜50%+ | 非常に高い |
| Facebook等のSNS | 50%超 | ゲームでは稀 |

**⚠️ 落とし穴：ゲームジャンルで意味が変わる**

毎日プレイすることが設計上の前提になっているデイリーカジュアルゲームと、週1〜2回のセッションを前提とした重厚なRPGやストラテジーゲームでは、DAU/MAU比率の意味が根本的に異なる。「比率が低い＝問題」と早合点せず、自分のゲームが「毎日遊ぶもの」として設計されているかどうかを先に問うべきだ。[[7](#ref-7)]

***

### リテンション率——「プレイヤーが戻ってくるか」

リテンション率は「ある日にインストールしたコホート（集団）のうち、N日後にも起動した割合」だ。D1・D7・D30の3点が最も頻繁に参照される。[[8](#ref-8)]

$$ \text{D7リテンション} = \frac{\text{インストール日から7日後に起動したユーザー数}}{\text{インストール日のユーザー数}} \times 100 $$

2024〜2025年の業界平均ベンチマークは以下の通りだ：[[9](#ref-9)][[10](#ref-10)]

| タイミング | 上位25%の水準 | 中央値 | 下位25%の水準 |
|---|---|---|---|
| D1（翌日） | 26〜33% | 約20〜27% | 10〜11% |
| D7（1週間後） | 7〜8% | 約3〜4% | 1.5%以下 |
| D28/D30（1ヵ月後） | 3%以上 | 3%未満 | ほぼ0% |

ジャンル別では差が顕著だ（以下は「健全」とされる目標値）：[[11](#ref-11)][[12](#ref-12)]

| ジャンル | D1目標値 | D7目標値 | D30目標値 |
|---|---|---|---|
| ハイパーカジュアル | 50%以上 | 15〜20% | 1〜2% |
| カジュアル/パズル | 35〜40% | 12〜15% | 4〜6% |
| ミッドコア（RPG・ストラテジー） | 35% | 10% | 6〜7% |

**なぜD1・D7・D30の3点なのか**

それぞれが異なるプレイヤー行動のフェーズを照らすからだ：[[8](#ref-8)]
- **D1**：チュートリアルとファーストセッションの質。「面白い予感」を感じさせられたか
- **D7**：習慣形成の突破口。「また明日もやろう」という動機が生まれたか
- **D30**：長期的なプロダクト・マーケット・フィット。ゲームループそのものへの飽きが来ていないか

**⚠️ 落とし穴：有料広告ユーザーとオーガニックユーザーを混ぜない**

広告経由でインストールしたユーザーと口コミ・検索でインストールしたユーザーでは、リテンション率が大きく異なる場合がある。この2つを混在させてコホートを切ると、「広告の質の問題」と「ゲーム設計の問題」が区別できなくなる。[[12](#ref-12)]

***

### セッション長・セッション回数——「どれだけ深く遊んでいるか」

1セッション（ゲームを開いてから閉じるまで）の平均時間と、1日あたりの平均セッション回数は、エンゲージメントの深度を示す。

2024年のGameAnalyticsデータによれば：[[10](#ref-10)]
- **1セッションの平均時間**：上位25%のゲームで8〜9分、中央値は5〜6分
- **1日あたりの平均セッション回数**：約4回

**⚠️ 落とし穴：セッション長は「長いほど良い」ではない**

セッションが長い＝エンゲージメントが高いとは限らない。プレイヤーがUIに迷っている、ロード時間が長い、あるいはゲームがテンポを失っているといった「負のエンゲージメント」もセッション長を引き伸ばす。セッション長だけを見るのではなく、セッション中のアクション数や到達ステージ数といった **深度指標** とセットで読む必要がある。

***

## 第2章：マネタイズ指標

### 支払ユーザー転換率（CVR）——「何%が課金するか」

$$ \text{転換率} = \frac{\text{課金ユーザー数}}{\text{DAUまたはMAU}} \times 100 $$

F2Pゲームにおける課金転換率の業界標準は **1〜3%** が「普通」とされる。5%を超えると非常に高く、6%を超えるのは稀だ。[[13](#ref-13)][[12](#ref-12)]

この数字の意味は単純だが、その背後にある事実が重要だ。**無課金プレイヤーが97〜99%を占める** のがF2Pゲームの通常状態であり、ゲームの収益構造は事実上「少数の課金ユーザーによって支えられている」。さらに、上位1%のプレイヤー（課金者を含む全ユーザーの上位1%）だけで全F2P収益の半分前後を占めるとも言われる（ある分析では約58%）。ただしこの数値は出典・年代・ジャンルによって幅があり（上位1%で約24〜58%など）、あくまで「収益が一部のユーザーに集中する」という構造を示す目安として捉えるべきだ。[[13](#ref-13)]

**⚠️ 落とし穴：転換率が高ければ良いとは限らない**

転換率が異常に高い場合（例：10〜20%）、「ゲームの魅力ではなく、ゲームプレイを進めるために課金せざるを得ない設計になっている」可能性を疑う必要がある。強引なP2W（ペイ・トゥ・ウィン）設計は短期的に課金額や転換率を押し上げることがあるが、コミュニティへの反発というコストは大きい。プレミアムタイトルの例ではあるが、Star Wars: Battlefront II（2017）のルートボックス騒動は、P2W的な課金設計への反発が発売直前の課金要素停止にまで発展した象徴的なケースだ。

***

### ARPU・ARPDAU・ARPPU——「どれだけ稼いでいるか」の3つの切り口

この3つは混同しやすいが、それぞれ異なる問いに答える：[[14](#ref-14)][[15](#ref-15)]

| 指標 | 計算式 | 何を問うか |
|---|---|---|
| **ARPU**（Average Revenue Per User） | 期間収益 ÷ 期間ユーザー数 | 全ユーザーを平均したとき1人いくら稼ぐか |
| **ARPDAU**（Average Revenue Per Daily Active User） | 日次収益 ÷ DAU | 1日に遊んでいるユーザー1人あたりの収益 |
| **ARPPU**（Average Revenue Per Paying User） | 期間収益 ÷ 課金ユーザー数 | 課金した人が平均でいくら使っているか |

3者の関係を式で表すと、次のようになる：[[15](#ref-15)]

$$ \text{ARPU} = \text{ARPPU} \times \text{転換率（課金比率）} $$

ジャンル別のARPDAUの目安は以下の通りだ：[[12](#ref-12)]

| ジャンル | ARPDAU目安 |
|---|---|
| ハイパーカジュアル（広告主体） | 2〜5セント |
| カジュアルゲーム | 約10セント |
| ミッドコア（IAP主体） | 30〜40セント |

**⚠️ 落とし穴：ARPPUが高くてもARPUが低ければ構造的に脆い**

「ARPPUが高い＝健全」ではない。ARPPUが高くてARPUが極端に低い場合、「一握りの重課金プレイヤーが支えている構造」を意味する。この構造は重課金プレイヤーが離脱した瞬間に収益が急落するリスクを内包している。幅広いユーザーが少額ずつ課金する設計（中課金・微課金プレイヤーを増やす設計）の方が長期的には安定しやすい。[[14](#ref-14)]

***

### LTV（Lifetime Value）——「1ユーザーが生涯でいくら稼ぐか」

LTV（生涯価値）は「1ユーザーがゲームを遊び続ける期間に生み出す期待収益」だ。マーケティング投資の上限を決める最重要指標で、「LTV > CAC（獲得コスト）」が健全な運営の基本条件となる。[[16](#ref-16)]

LTVの簡易計算式は：

$$ \text{LTV} = \text{ARPDAU} \times \text{平均プレイ日数} $$

より精度の高い方法は、コホートごとの累積ARPUを時系列で追い、収益曲線が収束する値を推定することだ。リテンション曲線が長く続くほどLTVは高くなるため、**LTVの改善はリテンション改善と直結する**。

***

### CAC・CPI——「1人のユーザーを獲得するのにいくらかかるか」

**CPI（Cost Per Install）** は広告費を新規インストール数で割った値だ。**CAC（Customer Acquisition Cost）** はより広い概念で、クリエイティブ制作費・ツール費用・担当者の人件費まで含む総獲得コストだ。[[17](#ref-17)]

2026年現在の業界平均CPI目安は（プラットフォーム別の概算）：[[17](#ref-17)][[18](#ref-18)]
- iOS：約4.70ドル
- Android：約3.70ドル

ジャンル別のCPA（Cost Per Action：インストール後の特定行動まで含むコスト）は：[[17](#ref-17)]
- カジュアルゲーム：1.50〜3.00ドル
- ミッドコアゲーム：4.00〜8.00ドル

**⚠️ 落とし穴：CPIで獲得効率を測ると失敗する**

CPIは「インストールさせるコスト」しか測らない。D30まで残るユーザーの獲得コストを計算する「**D30残存ユーザーあたりのコスト（Cost Per Retained User）**」こそが、実質的な獲得効率を示す最も重要な指標だとされる。CPIが安くてもD1リテンションが低い広告チャネルは、実際には高コストなのだ。[[17](#ref-17)]

**CAC回収期間（Payback Period）** は、1ユーザーのCACを回収するまでに何ヵ月かかるかを示す。モバイルゲームでは6〜12ヵ月以内が健全とされる場合が多いが、ジャンルやゲームの設計寿命によって異なる。[[16](#ref-16)]

***

## 第3章：KPIの「相関関係」で読む全体像

個々のKPIは孤立して意味をなさない。数字の連鎖として読むことが重要だ。以下に「症状と考えられる原因」の関係を整理する。

### よくある「数字の組み合わせ診断」

| 観察される状態 | 考えられる原因 | 次に見るべき指標 |
|---|---|---|
| DAUは伸びているがARPDAUが下落 | 課金ユーザーが相対的に減っている、または無課金ユーザーが増えている | 転換率・ユーザー獲得チャネル別コホート |
| D1リテンションは良いがD7が急落 | チュートリアル後のゲームループに魅力が足りない | D3リテンション・チュートリアル離脱ポイント |
| ARPPUが高いがARPUが低い | 重課金プレイヤー依存。課金ユーザーの裾野が広がっていない | 転換率・初回課金のタイミング |
| DAU/MAU比率が低下 | ゲームが「毎日やる理由」を失っている | デイリーコンテンツの消費率・ログインボーナス受取率 |
| LTVがCACを下回り始めた | 収益化が弱いか獲得コストが上昇している | ARPDAU・リテンション曲線・CPI by チャネル |

***

## コラム：「数字が良い＝ゲームが良い」ではない

KPIへの過度な依存が生む弊害として、「指標の最適化がゲームの楽しさを壊す」現象がある。

代表的な例が **セッション長の最大化を目指した設計** だ。セッション長を増やすことだけを目的にロードや演出を引き伸ばすと、短時間でプレイしたいユーザーが離脱し、D7・D30リテンションが逆に悪化する。数字はあくまで「プレイヤー体験の結果」であり、数字そのものをターゲットにした設計変更は本末転倒になりやすい。

もう一つの落とし穴は **「平均値への過信」** だ。例えばARPPUが高くても、その内訳が「上位10人が大半を稼ぎ、残りの課金ユーザーはわずか数百円」という分布であれば、ARPPUという平均値は実態を隠してしまう。分布を見ずに平均値だけを追うと、問題の所在を見誤る。

KPIは「問いを立てるための道具」であり、「答えを与える道具」ではない。「なぜこの数字が動いたのか」という問いを立て、その答えを実際のプレイやユーザーフィードバックで検証することが、プランナーに求められる姿勢だ。

***

## 新米プランナーへの実践的チェックリスト

プロジェクトに参加した初期段階で確認しておくべき問い：

- **「アクティブユーザー」の定義は社内で統一されているか？**
- **リテンションはオーガニックと有料広告ユーザーで分けて計測しているか？**
- **ARPUとARPPUの両方を追っているか？片方だけに偏っていないか？**
- **CACとLTVを同じ時間軸で比較できる仕組みがあるか？**
- **CPIだけでなく「D30残存ユーザーあたりのコスト」を計算しているか？**
- **DAU/MAU比率は自社ゲームのジャンルに合った基準で評価しているか？**
- **KPIの変動の原因を「施策」と「外部要因（季節性・競合の新作）」で切り分けられているか？**

数字を正確に読む技術と、数字を過信しない判断力は、どちらが欠けても機能しない。この2つをセットで持つプランナーが、データドリブンな開発現場で最も価値を発揮できる。

***

## References

<a id="ref-1"></a>1. [Mobile App Performance Metrics: Essential KPIs to Track][1] - モバイルアプリの主要KPIと業界ベンチマーク（DAU/MAU 20%超など）。

<a id="ref-2"></a>2. [Mobile game analytics: 6 essential metrics & how to track them][2] - DAUなどモバイルゲーム分析の基本指標とトラッキング方法。

<a id="ref-3"></a>3. [How to calculate ARPU, ARPPU, ARPDAU and more][3] - ARPU/ARPPU/ARPDAUの計算方法と比較の留意点（GameAnalytics）。

<a id="ref-4"></a>4. [The Essential Guide to The DAU/MAU Ratio][4] - スティッキネスの代表的指標としてのDAU/MAU比率の解説（Gainsight）。

<a id="ref-5"></a>5. [Stickiness (DAU/MAU Ratio) — How Often Users Return][5] - カジュアルゲーム0.15〜0.35などカテゴリ別のスティッキネス目安。

<a id="ref-6"></a>6. [What is a "good" DAU/MAU for mobile apps?][6] - ゲームのDAU/MAUは約20〜30%が良好、SNSはさらに高いとの見解。

<a id="ref-7"></a>7. [What you should know before tracking DAU/MAU Ratio][7] - DAU/MAU比率のベンチマークと解釈上の注意点。

<a id="ref-8"></a>8. [Mobile App Retention Benchmarks by Industry (2026)][8] - 業界別のリテンションベンチマークとD1/D7/D30の意味。

<a id="ref-9"></a>9. [Mobile Game Retention Benchmarks - Maf.ad][9] - D1/D7/D30リテンションの定義と業界水準。

<a id="ref-10"></a>10. [GameAnalytics: Mobile gaming benchmarks in 2025][10] - 1日平均4セッション、セッション長や上位25%/中央値の水準。

<a id="ref-11"></a>11. [App Retention Benchmarks for 2026][11] - D1は約26〜28%など2026年のリテンション傾向。

<a id="ref-12"></a>12. [Key Metrics for Mobile App Success][12] - 転換率・ARPDAU・リテンションなどジャンル別の主要指標。

<a id="ref-13"></a>13. [Turning Users into Customers: Why Conversion Rate is So Important][13] - プレイヤーの約5%が課金し、上位1%が大きな収益シェアを占めるとの分析。

<a id="ref-14"></a>14. [ARPU vs ARPPU: Which Metric Best Explains Your App][14] - ARPPUが高くARPUが低い場合の重課金プレイヤー依存構造の解説。

<a id="ref-15"></a>15. [Main Metrics. ARPU and ARPPU: What's the Difference?][15] - ARPUとARPPUの違いと相互関係（devtodev）。

<a id="ref-16"></a>16. [Winning the Growth Game: CAC Payback Period and Flywheels][16] - CAC回収期間の計算と成長フライホイールの考え方。

<a id="ref-17"></a>17. [Mobile App User Acquisition Cost: Benchmarks, Formula & Why Intent Matters (2026)][17] - プラットフォーム別CPI（iOS約$4.70/Android約$3.70）とジャンル別CPA、Cost Per Retained Userの重要性。

<a id="ref-18"></a>18. [The Cost of User Acquisition in Mobile Games - Maf.ad][18] - 2026年のUAコストとCPIの platform/region/genre による違い。

[1]: https://www.plotline.so/blog/mobile-app-performance-metrics-essential-kpis-to-track
[2]: https://www.smartlook.com/blog/mobile-game-analytics/
[3]: https://www.gameanalytics.com/blog/how-to-calculate-arpu-arppu-arpdau-and-more
[4]: https://www.gainsight.com/essential-guide/product-management-metrics/dau-mau/
[5]: https://mwm.ai/glossary/stickiness
[6]: https://clarity.fm/questions/755/what-is-the-generally-agreed-upon-good-dau-mau-for-mobile-apps/2220
[7]: https://metricstack.substack.com/p/eleventh-edition
[8]: https://uxcam.com/blog/mobile-app-retention-benchmarks/
[9]: https://maf.ad/en/blog/mobile-game-retention-benchmarks/
[10]: https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks
[11]: https://enable3.io/blog/app-retention-benchmarks-2025
[12]: https://mirigrowth.com/blog/which-metrics-really-matter/
[13]: http://brightblack.co/blog/2018/12/10/player-to-payer-why-f2p-conversion-rate-is-so-important-to-your-games-success
[14]: https://apptrove.com/arpu-vs-arppu/
[15]: https://www.devtodev.com/resources/articles/main-metrics-arpu-and-arppu-what-s-the-difference
[16]: https://appagent.com/blog/winning-the-growth-game-the-cac-payback-period-and-flywheels/
[17]: https://www.adaction.com/blog/mobile-app-user-acquisition-cost
[18]: https://maf.ad/en/blog/the-cost-of-user-acquisition/

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
