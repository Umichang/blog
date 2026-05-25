# なぜゲームはF2Pモデルに依存するようになったのか
## ——旧来のパッケージ・DL版との比較と「海賊版神話」の検証——

***

## エグゼクティブサマリー

ゲーム産業は過去30年で、「物を売る産業」から「体験を継続課金させる産業」へと根本的に変容した。現在、グローバルゲーム市場の収益の約60%以上がゲーム内課金（IAP：In-App Purchase）などF2P関連収益で占められており、F2Pセグメント全体では世界ゲーム収益の約85%を占めるという推計もある。この変化を「マジコンなどの不正機器による海賊版流通がゲームを無料にした」という一言で説明しようとする言説が広まっているが、実証研究を精査すると、この因果関係は著しく過度に単純化されていることが分かる。F2Pモデルへの移行は、アジア発のMMORPG実験、スマートフォン普及によるプレイヤー層の拡大、AAA開発費の高騰、そして課金心理の設計的進化という複数の力が重なり合った結果である。[[1](#ref-1)][[2](#ref-2)]

***

## 第1章：F2Pとは何か——ビジネスモデルの基本構造

### 1-1. 定義と仕組み

F2P（Free-to-Play）とは、ゲームの核となる体験を無料で提供し、収益をゲームプレイ中の任意購入から得るビジネスモデルである。従来の「買い切り型（Pay-to-Play）」モデルが初回に一定の固定価格を徴収し、そこで収益が完結するのに対し、F2Pは収益の重心を「一回限りの取引」から「長期的なプレイヤーの定着と顧客生涯価値（LTV：Lifetime Value）の最大化」へと移行させる。[[3](#ref-3)]

F2Pの収益構造は「ARM（Acquisition → Retention → Monetization）」モデルに基づく：[[3](#ref-3)]

- **獲得（Acquisition）**：無料という参入障壁ゼロの設計により、有料ゲームとは比較にならない規模のユーザーを集める
- **継続（Retention）**：長期間プレイし続けてもらえるよう、コンテンツ更新やコミュニティ運営を行う
- **収益化（Monetization）**：定着したごく一部のプレイヤーから課金を得る

### 1-2. 主な収益化手法

現代のF2Pゲームは多様な収益源を組み合わせる：

| 手法 | 概要 | 代表例 |
|------|------|--------|
| アイテム課金（IAP） | スキン・キャラクター・アイテムの個別販売 | フォートナイト（スキン）、原神（ガチャ） |
| バトルパス | 期間限定の段階的報酬を販売するサブスクリプション的モデル | フォートナイト、エーペックスレジェンズ |
| ガチャ | ランダム要素を含む報酬抽選 | 日本のモバイルゲーム全般 |
| アプリ内広告（IAA） | 非課金プレイヤーに広告を表示して収益化 | カジュアルモバイルゲーム |
| サブスクリプション | 月額制によるコンテンツアクセス | 各種オンラインゲームのプレミアム会員 |

なお、ここでいうガチャは通常のランダム型課金を指す。特定のアイテムをそろえることで別の景品を得る「コンプガチャ」は、消費者庁が2012年に景品表示法上の「カード合わせ」に当たり得るとの考え方を示しており、現在の代表的な収益化手法として並べるべきものではない。[[39](#ref-39)]

***

## 第2章：歴史的経緯——F2Pはどこから来たのか

### 2-1. 起源：2000年前後の韓国・アジア

F2Pモデル（基本プレイ無料＋アイテム課金）の起源は、2000年前後の韓国・東アジアに求められる。世界初のアイテム課金型F2Pとされるのは、ネクソンが1999年にサービスを開始したマルチプレイ型オンラインクイズゲーム『QuizQuiz』であり、2000年10月ごろに月額課金から基本プレイ無料へ転換し、アバター課金を導入した。続いて2001年に同社が発表した『クレイジーアーケード（BnB）』は、ゲームデザインの段階からF2Pを前提に作られたタイトルとして知られている。当時の欧米MMORPGが『Ultima Online』や『EverQuest』のように月額課金制（サブスクリプション）を採用していたのとは対照的に、韓国発のこれらのタイトルは初期費用ゼロでプレイ可能にし、課金はアバターやカスタマイズアイテムに限定した。[[4](#ref-4)]

**なぜアジアでF2Pが先行したのか？** 学術的見地からは、東アジア・東南アジアでは正規版ゲームソフトに対するオンライン海賊版の流通が欧米より深刻であったため、ゲームをそもそも無料にすることで海賊版への動機を減じるという対策として機能したという側面がある。ただし、これが主たる原因ではなく、インターネットカフェ（PC房）文化の定着や、所得水準に見合わないパッケージ価格など、複合的な社会・経済的要因が重なっていた。[[5](#ref-5)]

2004年〜2005年にかけて、韓国・中国・日本でサービスを開始した無料カジュアルオンラインゲームが、それまでの月額課金型の市場飽和に対抗する形で躍進する。決定打となったのは2005年8月、ネクソンが当時運営していた月額課金制MMORPG5タイトル（『風の王国』『闇の伝説』『テイルズウィーバー』『アスガルド』『マビノギ』）を一斉に基本プレイ無料化した「基本プレイ無料化宣言」だ。この前後の2005年〜2007年には大作MMOまでF2Pへ転換し、「オンラインゲームのビジネスモデルはF2P」という潮流が確立した。[[6](#ref-6)][[7](#ref-7)]

### 2-2. グローバル展開：2007年以降

F2Pがグローバルに普及した決定的な契機はいくつかある：

1. **スマートフォンの登場（2007〜）**：App StoreおよびGoogle Playの「無料アプリ」文化がF2Pを一般消費者の常識にした
2. **Zynga・ソーシャルゲームの台頭（2009〜）**：Facebook上の『FarmVille』等が、それまでゲームをしなかった層を取り込んだ
3. **リーグ・オブ・レジェンド（2009）・フォートナイト（2017）の成功**：「高品質なゲームが完全無料で提供される」という消費者の期待値を固定した

***

## 第3章：パッケージ・DL販売モデルとの比較

### 3-1. ビジネスモデルの構造比較

| 比較軸 | パッケージ/DL販売（買い切り型） | F2Pモデル |
|--------|--------------------------|----------|
| 初期収益 | 販売時に確定（高） | ゼロ（参入コストなし） |
| 継続収益 | DLC・続編販売に限定 | 無期限のゲーム内課金 |
| ユーザー獲得コスト | 広告→購入という高い障壁 | 「無料」なので障壁が低い |
| 開発コスト回収 | 発売後数ヶ月が勝負 | 長期にわたって回収可能 |
| 課金プレイヤー比率 | 100%（全員が支払う） | 約2〜5%（少数が支払う） |
| ARPU（1人あたり平均収益） | 小（定価÷生涯） | 少数の高額課金者が牽引 |
| 課金転換の障壁 | 定価が参入障壁 | 無料なので試用可能 |
| ライフサイクル（製品寿命） | 発売後に収益が急減 | 継続的なアップデートで延命 |

パッケージゲームでは全プレイヤーが支払うが、F2Pでは課金者は全体の2〜5%に過ぎない。にもかかわらずF2Pが収益的に優勢なのは、 **一部の高額課金者** の存在が大きい。モバイルF2Pゲームでは、上位2%のプレイヤーが収益の最大90%を担うという分析がある。Unity社の2025年レポートによれば、プレイヤーの5%が全ゲーム内課金収益の65%を生み出す。[[8](#ref-8)][[9](#ref-9)][[2](#ref-2)][[10](#ref-10)]

### 3-2. 実際の数値で見る比較

#### F2P代表タイトルの収益規模

| タイトル | モデル | 累計収益 | 主な収益源 |
|----------|--------|----------|-----------|
| リーグ・オブ・レジェンド | F2P（スキン・ガチャ） | 189億ドル（2009〜2024）[[11](#ref-11)] | 装飾アイテム課金（スキン等） |
| フォートナイト | F2P（スキン・バトルパス） | 推定250〜300億ドル（2017〜）[[12](#ref-12)] | スキン・バトルパス |
| 原神 | F2P（ガチャ中心、紀行あり） | モバイル累計63億ドル（〜2024年）[[13](#ref-13)] | ガチャ課金（紀行はバトルパス相当の補助的課金）[[40](#ref-40)] |

**リーグ・オブ・レジェンドは2017年に単年21億ドル** のピーク収益を記録し、その後毎年14〜18億ドルを安定的に生み出している。これは完全無料ゲームとして、単一タイトルが長年にわたって大手パブリッシャー並みの収益を維持していることを示す。[[11](#ref-11)][[14](#ref-14)]

#### 買い切り型ゲームとの対比

- フォートナイトの2023年単年収益は **35億ドル** で、Epic Games全体収益の約80%を占める[[15](#ref-15)]
- モバイルゲーム市場（大半がF2P）の2024年規模は **約1,394億ドル**[[16](#ref-16)]
- グローバルゲーム市場2024年の総収益は **約1,877億ドル** で、ゲーム内課金が全体の **58%** を占める[[17](#ref-17)][[2](#ref-2)]

#### プレイ時間における比較（Steam、2023年）

Steamプラットフォームでは2023年、プレイヤーの時間の51%がF2Pゲームに費やされた（2022年は56%）。一方、PCおよびコンソールでは有料ゲームが収益の56〜57%を担っており、プレイ時間の支配と収益化効率が必ずしも連動しないことが分かる。[[18](#ref-18)][[19](#ref-19)]

### 3-3. 開発コストの構造変化

F2P移行を後押しした背景として、AAA（超大作）ゲームの開発費高騰がある：

| 年代 | AAA開発費の目安 |
|------|----------------|
| 1995年頃 | 約200万ドル |
| 2000年頃 | 約400万ドル |
| 2005年頃 | 約1,200万ドル |
| 2010年頃 | 約4,000万ドル |
| 2015年頃 | 約1億2,000万ドル以上 [[20](#ref-20)] |
| 2020年代 | 2億5,000万〜6億ドルが標準 [[21](#ref-21)] |

この指数関数的な費用増大によって、パッケージゲームの販売価格（2005年のXbox 360世代以降、北米市場では約60ドルで固定されていた）は実質的な開発投資対比でペイしにくくなった。買い切り型ゲームの定価は2020年代に入って70ドルへの値上げが進んでいるが、インフレ調整後では1990年代のスーパーファミコン時代の価格に達していないという分析もある。[[22](#ref-22)][[23](#ref-23)]

F2Pモデルは、発売時に収益を確定させる必要がなく、コンテンツ更新を続けることで開発費を長期回収できるため、費用構造との親和性が高い。逆に言えば、 **開発費が高騰し続けるほど、買い切り型販売モデルは経営リスクが高まる**。

***

## 第4章：「マジコン神話」の検証

### 4-1. 言説の内容と広まり方

「マジコンなどのニンテンドーDS用不正機器によって消費者に『ゲームはタダ』という誤った認識が広まり、F2Pへの移行を余儀なくされた」という言説は、業界の一部の関係者や一般ゲーマーの間で広く信じられている。この言説の根拠として挙げられるのは：

- ニンテンドーDSのマジコン（R4等）による大規模な海賊版流通
- ヨーロッパでのニンテンドーDS向けソフト売上の激減
- 業界団体によるマジコン被害額の推計

これらの事実は確認されているが、「だからF2Pに移行した」という因果推論は、実証的に慎重であるべきである。

### 4-2. マジコンの実際の影響：ニンテンドーDSの事例

任天堂は2010年、R4などのニンテンドーDS用マジコンが **ヨーロッパでのニンテンドーDSソフト売上を約50%押し下げた** と主張し、「年間兆円単位の損失」と述べた。さらに2009年6月の1か月間だけで、モニターした10サイトで **計2億3,800万回のROMダウンロード** が確認されたとされる。これに先立つ2008年7月、任天堂はゲームメーカー54社と共同でマジコン業者を東京地裁に提訴し、その後、楽天オークションでのマジコン出品禁止、不正競争防止法の改正、関税法による輸入禁止へと規制が強化された。[[24](#ref-24)][[25](#ref-25)][[26](#ref-26)][[27](#ref-27)]

一方、 **日本・米国では同期間の影響が限定的** だった。任天堂の同じ発表によれば、アメリカでの売上下落は11%、日本では7%に留まっていたとされ、影響の地域差が大きかった。[[25](#ref-25)]

東北大学（福川信也氏）の2009年の実証研究では、ニンテンドーDS・PSPユーザーの **約4割が海賊版を無料入手する方法を知っていた** が、 **海賊版ソフトの無料ダウンロードと正規版ソフトの購入件数との間に統計的有意な負の相関は見られなかった** という結果が得られた。さらに操作変数法を用いて内生性をコントロールしても、同様の結論だった。この研究は「ゲームへの執着心が高い人ほど海賊版もダウンロードし、正規版も購入する」という行動特性を示唆している。[[28](#ref-28)]

### 4-3. EU委員会の大規模調査（2013年・2017年公開）

最も権威ある反証として、欧州委員会が2013年に発注し、2017年に情報公開で明らかになった大規模調査がある。オランダのEcorys社が実施した360,000ユーロ規模の研究で、以下の結論が出た：[[29](#ref-29)][[30](#ref-30)]

- **「オンライン著作権侵害が売上を代替する証拠はない」**（ゲーム・音楽・書籍全般）[[29](#ref-29)]
- ゲームに関しては驚くべき結果で、 **海賊版100本ダウンロードにつき正規版が24本追加で売れる** という **プラスの相関（+24%）** が示された[[31](#ref-31)][[29](#ref-29)]

欧州委員会がこの結果を長期間非公開にしていたという事実自体が、政策的立場とのギャップを示している。ただし研究者たちはこの逆説的な結果に対し、「ブロックバスター映画は例外で、それ以外は有意な変位効果がない」という形で慎重に解釈しており、「海賊版がゲームの売上を増加させる」と断言するものでもない。[[30](#ref-30)][[31](#ref-31)]

### 4-4. 「神話」はなぜ広まったのか

では、なぜ「海賊版がF2Pを生んだ」という言説が広まったのか。その理由として以下が考えられる：

1. **業界側の利害**：ゲームメーカー・業界団体はマジコン規制を求める際に「兆円単位の損失」を強調する動機がある
2. **相関と因果の混同**：海賊版が横行した時期とF2Pが広まった時期が重なるため、因果関係と見誤りやすい
3. **アジア発のF2P起源の見落とし**：F2Pは韓国・中国でマジコン等の不正機器問題とは別の脈絡（インフラ・所得水準・PC房文化）から先行して発展していた
4. **「無料」という概念の混乱**：海賊版への慣れとF2Pへの受容は別の話だが、消費者の感覚として混同されやすい

学術的に確認できるのは「海賊版がゲームを無料だと思わせた」という心理的効果の存在ではなく、むしろ「スマートフォンの普及」「モバイルゲームのF2P主流化」「欧米プラットフォームへのアジアモデルの輸出」という経路がF2P普及の主因であることだ。

***

## 第5章：F2Pが生み出す新たな問題

### 5-1. 高額課金者への依存と課金格差

F2P経済の最大の構造的問題は、収益が一部の高額課金者に極度に集中することだ。モバイルゲームでは上位1%のプレイヤーが収益の50%、上位10%が90%を占めるという分析がある。高額課金者は月に100〜1,000ドル以上を消費し、ゲーム依存（IGD）との強い相関も指摘されている。[[32](#ref-32)][[8](#ref-8)]

ガチャ（日本）はこの構造を代表する仕組みで、ランダム性を活用した価格差別化メカニズムとして機能している。一部のプレイヤーが確率の低いレアリティを求めて過度に課金する現象は、ギャンブル依存との類似性から規制論議を呼んでいる。[[10](#ref-10)]

### 5-2. サブスクリプションという第三の道

F2Pと買い切り型販売の中間に、近年急成長しているのがサブスクリプションモデルだ。英国のデータでは2024年にコンソールサブスクリプション支出が前年比12.2%増の5億5,950万ポンドに達した。[[33](#ref-33)] 一方、日本ではXbox Game Passが月額850〜1,550円、PC Game Passが月額1,300円で数百本規模のゲームライブラリを提供しており、PlayStation Plusも月額850円のエッセンシャルから月額1,550円のプレミアムまでのプランを持つ。[[34](#ref-34)][[35](#ref-35)][[36](#ref-36)]

このモデルはプレイヤーに「定額で多数のゲームを試せる」体験を与えながら、開発者には安定収益の一部分配を提供する。F2Pと買い切り型のハイブリッドとも言える位置にある。

### 5-3. F2Pの持続可能性の問題

2022年以降、PC（Steamプラットフォーム）でF2Pゲームのプレイ時間シェアが縮小傾向にある（2022年: 56%→2023年: 51%→2024年初頭: 44%）。モバイルゲームのゲーム内課金支出も2023年に若干の収縮を見せた。これは「F2Pの飽和」と「高品質な買い切り型ゲームへの回帰」の兆候とも読める。[[37](#ref-37)][[19](#ref-19)][[18](#ref-18)]

***

## 第6章：日本市場への示唆

### 6-1. 国内市場の構造

2024年の国内ゲームコンテンツ市場規模は **2兆3,961億円**（前年比3.4%増）に拡大した。一方、経産省の調査ではオンラインゲームEC市場は1兆2,553億円（前年比0.58%減）と3年連続でマイナス成長。これはコロナ禍の巣ごもり需要の反動によるリアル回帰の影響だ。[[38](#ref-38)]

日本市場は「ガチャ」という独自の進化を遂げたF2P課金システムを生み出し、国内・海外の両方でその仕組みが定着した。原神はガチャを世界標準に引き上げた好例であり、モバイルでの累計収益は63億ドルを超えた。[[13](#ref-13)]

### 6-2. F2Pが普及した本質的な理由の整理

マジコン等の不正機器による海賊版流通を「F2P移行の主因」とする言説を除いた上で、 **F2Pが支配的になった真の構造的要因** は以下に整理できる：

1. **スマートフォン普及**：ゲーム非経験者が大量参入し、「まず無料で試す」文化が形成された
2. **ネットワーク外部性**：友人・コミュニティが遊んでいれば参入コストゼロは圧倒的な優位性を持つ
3. **AAA開発費高騰**：買い切り型販売での回収リスクが上昇し、長期収益化への需要が高まった
4. **プレイヤー数最大化の論理**：F2Pによる大規模ユーザーベースがeスポーツ・広告・LTVを全方位で強化する
5. **アジア発の成功事例の普及**：韓国・中国発のF2Pモデルが世界に輸出され、検証済みの手本となった
6. **海賊版対策（補足的要因）**：アジアにおいては一定の役割を果たしたが、これはF2P普及の主因ではなく補完的動機にとどまる

***

## 結論

「ゲームがF2Pに依存するようになった理由は海賊版による無料意識の蔓延だ」という言説は、 **部分的な事実と因果の誤解が混在した過度な単純化** である。

マジコンなどのニンテンドーDS用不正機器による海賊版問題は欧州でのニンテンドーDS市場に深刻な打撃を与えたことは事実だが、複数の実証研究（東北大・EU委員会調査）は「海賊版が正規版売上を統計的に有意に押し下げた」という証拠を見出せていない。また、F2Pの起源は海賊版問題よりも早く、韓国・中国のMMORPG市場で2000年前後に萌芽していた。[[28](#ref-28)][[4](#ref-4)][[5](#ref-5)][[29](#ref-29)]

真の変容要因は、 **スマートフォンが切り開いた新市場、上昇し続ける開発コスト、ネットワーク外部性の力学、そして少数の高額課金者が多数の無課金ユーザーを支える新たな収益分担モデルの発明** にある。F2Pはゲームを「無料にした」のではなく、「誰が・いつ・いくら払うか」を根本から再設計した革新的なビジネスモデルなのである。

ゲームプランナーや開発者にとっての示唆は明確だ——F2Pモデルを採用するならば、ARM（獲得・継続・収益化）モデルの精緻な設計と、課金の倫理的な設計（過剰課金・ギャンブル的要素への配慮）が不可欠であり、「無料にすれば勝てる」という誤解もまた、「海賊版が無料化を強いた」という言説と同じく、構造の本質を見誤った危険な思い込みである。

---

## References

<a id="ref-1"></a>1. [How Free-to-Play Reshaped the Gaming Industry - LinkedIn][1] - The free-to-play segment accounts for approximately 85% of total gaming revenue globally. The mobile...

<a id="ref-2"></a>2. [In-Game Purchase Spending Habit Statistics 2026 - Rec0deD:88][2] - Mobile in-app purchase revenue hit $92.6 billion in 2024, with the average paying user spending $27....

<a id="ref-3"></a>3. [オンラインゲームにおける市場力学、収益化戦略、および将来の ...][3] - フリー・トゥ・プレイ（F2P）モデルは、中核となるゲーム体験を無料で提供することで大規模なユーザーベースを獲得し、その中のごく一部のプレイヤーが購入 ...

<a id="ref-4"></a>4. [The history and evolution of free-to-play monetization ...][4] - Context: Early Korean MMOs like The Kingdom of the Winds and later MapleStory introduced the concept...

<a id="ref-5"></a>5. [[PDF] The imbalanced state of free-to-play game research: A literature ...][5] - By examining 21 free-to- play mobile games, the study discovered only a weak relationship between in...

<a id="ref-6"></a>6. [どうしていまの形になっていったか？ 2001年アイテム課金登場の経緯][6] - そしてこれらの結果を受け、2005年～2007年に大作MMOまで含め、「ビジネスモデルはF2P」という時代がやってくる。 というところで、ついにF2Pのビジネス ...

<a id="ref-7"></a>7. [アイテム課金 - Wikipedia][7] - ... ビジネスモデルを採用しているのに対し、欧米ではアイテム課金非依存型のビジネスモデルを採用したF2Pゲームも多い。例えばゲーム内広告を中心とするビジネスモデルや ...

<a id="ref-8"></a>8. [Shouradeep Chakraborty's Post - LinkedIn][8] - 高額課金者の属性や、少数の課金者がF2P収益の大部分を担う構造について述べた投稿。

<a id="ref-9"></a>9. [Turning Users into Customers: Why Conversion Rate is So Important ...][9] - Considering only 5% of players make in-game purchases and the top 1% of mobile players account for 5...

<a id="ref-10"></a>10. [[PDF] Exploring the game-of-chance elements in F2P mobile games][10] - In that sense, this paper is a preliminary one for further research on how Gacha elements, game-of- ...

<a id="ref-11"></a>11. [League Of Legends Statistics 2026 - Rec0deD:88][11] - League of Legends earned an estimated $18.92 billion in total in-game revenue between 2009 and 2024....

<a id="ref-12"></a>12. [How Much Money Has Fortnite Made? Revenue Breakdown (2017 ...][12] - Fortnite has generated an estimated $25–30 billion in total revenue since 2017, placing it among the...

<a id="ref-13"></a>13. [Genshin Impact hits $6.3 billion in time for fourth anniversary, but is it ...][13] - Since September 28th, 2023, the RPG has generated a further $931.4 million, making this its first ye...

<a id="ref-14"></a>14. [How Much Money Has League of Legends Made? (All-Time Stats)][14] - League of Legends made $18.92 billion since 2009. Explore LoL's annual revenue, peak earnings of $2....

<a id="ref-15"></a>15. [Fortnite Usage and Revenue Statistics (2026) - Business of Apps][15] - Fortnite generated $3.5 billion revenue in 2023, it peaked at $5.4 billion in 2018. Fortnite revenue...

<a id="ref-16"></a>16. [Mobile Gaming Market Size & Share ｜ Industry Report, 2030][16] - The free-to-play (F2P) segment accounted for the largest market revenue share in 2024. Free-to-play ...

<a id="ref-17"></a>17. [[PDF] 2024 - Global Games Market Report][17] - We compare revenue shares and dollar amounts (in USD) with 2023, focusing on the main gaming segment...

<a id="ref-18"></a>18. [Video Game Insights: F2P Games on Steam in 2024][18] - In 2023, 51% of gamers' time on Steam was spent on F2P games. 31% on games priced from $10 to $50. 1...

<a id="ref-19"></a>19. [Game Market Overview. The Most Important Reports Published in ...][19] - Paid games accounted for 56% of revenue on PC and 57% of revenue on consoles in the US and UK market...

<a id="ref-20"></a>20. [Some current game economics - Raph Koster][20] - A discussion broke out on all the recent discussions about lootboxes, game development costs, game p...

<a id="ref-21"></a>21. [Gaming's billion-dollar gamble - SuperJoost Playlist][21] - AAA game costs are skyrocketing, risking industry collapse. Explore why bigger budgets aren't buying...

<a id="ref-22"></a>22. [The History of Game Prices: Truth of the Matter][22] - A 4 or 5 hour campaign in "Rogue Warrior" or "Terminator Salvation" was $60, the same as "GTA-5" or ...

<a id="ref-23"></a>23. [Comparing Game Prices Across Generations][23] - We're going to take a look back at video game prices starting from the early Atari games of the 80s ...

<a id="ref-24"></a>24. [“マジコン”規制のゆくえ ～ゲーム海賊版対策の最前線～ 北澤尚登][24] - マジコンは、コピーガードではなくアクセスガード（ゲーム機に内蔵されている、海賊版の起動を防止するセキュリティ）を解除するものであるため、法律上の ...

<a id="ref-25"></a>25. [Piracy Responsible For 50% DS Software Sales Drop In Europe][25] - Compared to Europe, the effects of piracy in the U.S. and Japan were relatively limited, resulting i...

<a id="ref-26"></a>26. [Nintendo Blames DS Piracy For 50% Sales Drop In Europe - Kotaku][26] - The Japanese company is blaming them for a 50% drop in sales of DS games in Europe. https://kotaku.c...

<a id="ref-27"></a>27. [ついにネットオークションで「マジコン」の出品禁止、海賊版対策 ...][27] - すでに「マジコン」の取り扱いを中止するオンラインショップも登場していることから、これでマジコンは市場から一掃されるということなのでしょうか。

<a id="ref-28"></a>28. [[PDF] 海賊版ゲームソフトの普及が携帯型ゲーム産業に与える影響の計量 ...][28] - 本研究では海賊版ゲームソフトのダウンロードが正規版ゲームソフトの売上にどのような影響を与えているかを. 機種別に推計する｡具体的には以下のモデルを推計する ...

<a id="ref-29"></a>29. [EU Commission: "No evidence that piracy affects video ...][29] - A new report from the European Commission has stated there's no statistical evidence that illegal do...

<a id="ref-30"></a>30. [EU withheld a study that shows piracy doesn't hurt sales][30] - The study concluded that there was no evidence that piracy affects copyrighted sales, and in the cas...

<a id="ref-31"></a>31. [EU study finds piracy doesn't hurt game sales, may actually ...][31] - An exhaustive study of piracy's effects by the European Commission found that "illegal consumption [...

<a id="ref-32"></a>32. [Spending Money in Free-to-Play Games: Sociodemographic ... - PMC][32] - The aim of the present study was (1) to describe the profiles and gaming patterns of F2P gamers, and...

<a id="ref-33"></a>33. [The UK Entertainment market in 2024 - games are no longer ...][33] - Physical game sales decreased by 34.5% in monetary terms. The PlayStation 5 accounted for 41% of all...

<a id="ref-34"></a>34. [PC Game Pass — PC Game Pass 1 か月間 を購入 ｜ Xbox][34] - 日本向けページで、PC Game Pass月額1,300円、Xbox Game Pass Ultimate月額1,550円、Premium月額1,300円、Essential月額850円を示している。

<a id="ref-35"></a>35. [PlayStation Plusエッセンシャル : 1ヶ月利用権][35] - PlayStation Plus エッセンシャルは1ヶ月ごとに850円の利用料が決済される定額サービス。

<a id="ref-36"></a>36. [PlayStation Plusプレミアム: 1ヶ月利用権][36] - PlayStation Plus プレミアムは1ヶ月ごとに1,550円の利用料が決済される定額サービス。

<a id="ref-37"></a>37. [The Billion-Dollar Industry: Understanding Mobile Game Player ...][37] - While player spending on in-game purchases and subscriptions is predicted to decline by 3% in 2023, ...

<a id="ref-38"></a>38. [ECよりもゲーム販売プラットフォームが主流][38] - 「ファミ通ゲーム白書2025」によると、2024年の国内ゲームコンテンツ市場規模は前年比3.4％増の2兆3,961億円となりました。主な成長要因として、物価 ...

<a id="ref-39"></a>39. [インターネット上の取引と「カード合わせ」に関するQ&A][39] - 消費者庁は、オンラインゲームで行われていた「コンプガチャ」について、懸賞景品制限告示で禁止される「カード合わせ」に当たり得るとの考え方を示している。

<a id="ref-40"></a>40. [Where can I purchase the Battle Pass?][40] - HoYoverse Help Centerでは、原神を含む各ゲームのBattle Passを公式チャージページなどから購入できると案内している。



[1]: https://www.linkedin.com/pulse/how-free-to-play-reshaped-gaming-industry-kaustubh-atulkar-m0hzf
[2]: https://rec0ded88.com/statistics/in-game-purchase-spending-habit-statistics/
[3]: https://note.com/nifty_cosmos4076/n/n04bf919fef6b
[4]: https://balancy.co/blog/2024/12/12/the-history-and-evolution-of-free-to-play-monetization-model-whats-the-next-big-thing/
[5]: https://dl.digra.org/index.php/dl/article/download/1097/1097/1094
[6]: https://news.denfaminicogamer.jp/column05/190805a
[7]: https://ja.wikipedia.org/wiki/%E3%82%A2%E3%82%A4%E3%83%86%E3%83%A0%E8%AA%B2%E9%87%91
[8]: https://www.linkedin.com/posts/shouradeep-chakraborty_the-economics-of-whale-hunting-why-2-of-activity-7269968136433524736-I4zO
[9]: http://brightblack.co/blog/2018/12/10/player-to-payer-why-f2p-conversion-rate-is-so-important-to-your-games-success
[10]: https://msl.dhw.ac.jp/wp-content/uploads/2020/04/DHUJOURNAL2018_P16.pdf
[11]: https://rec0ded88.com/statistics/league-of-legends/
[12]: https://stepico.com/gaming/how-much-money-has-fortnite-made/
[13]: https://www.pocketgamer.biz/genshin-impact-hits-63-billion-in-time-for-fourth-anniversary-but-is-it-running-on-fumes/
[14]: https://gameboost.com/blog/how-much-money-has-lol-made
[15]: https://www.businessofapps.com/data/fortnite-statistics/
[16]: https://www.grandviewresearch.com/industry-analysis/mobile-games-market
[17]: https://best-of-gaming.be/wp-content/uploads/2024/09/2024_Newzoo_Global_Games_Market_Report.pdf
[18]: https://gamedevreports.substack.com/p/video-game-insights-f2p-games-on
[19]: https://www.devtodev.com/resources/articles/game-market-overview-the-most-important-reports-published-in-april-2024
[20]: https://www.raphkoster.com/2017/11/27/some-current-game-economics/
[21]: https://superjoost.substack.com/p/gamings-billion-dollar-gamble
[22]: https://www.youtube.com/watch?v=qF2FBoPoSPU
[23]: https://www.youtube.com/watch?v=Sm70nbVYVfU
[24]: https://www.kottolaw.com/column/000364.html
[25]: https://www.siliconera.com/piracy-responsible-for-50-ds-software-sales-drop-in-europe/
[26]: https://kotaku.com/nintendo-blames-ds-piracy-for-50-sales-drop-in-europe-5520462
[27]: https://gigazine.net/news/20080828_r4ds_auction/
[28]: https://www.taf.or.jp/files/items/537/File/p053.pdf
[29]: https://www.gamesindustry.biz/eu-commission-no-evidence-that-piracy-affects-video-games-sales
[30]: https://www.engadget.com/2017-09-22-eu-suppressed-study-piracy-no-sales-impact.html
[31]: https://arstechnica.com/gaming/2017/09/eu-study-finds-piracy-doesnt-hurt-game-sales-may-actually-help/
[32]: https://pmc.ncbi.nlm.nih.gov/articles/PMC9737990/
[33]: https://gamedevreports.substack.com/p/era-games-are-no-longer-the-largest
[34]: https://www.xbox.com/ja-JP/games/store/game-pass/CFQ7TTC0KGQ8
[35]: https://store.playstation.com/ja-jp/product/IP9105-PPSA07181_00-PLUS1T01M0000000
[36]: https://store.playstation.com/ja-jp/product/IP9105-PPSA07181_00-PLUS3T01M0000000
[37]: https://blog.kindred.co/kindred-for-business-blog/mobile-game-player-spending-in-2023
[38]: https://ebisumart.com/blog/game/
[39]: https://www.caa.go.jp/policies/policy/representation/fair_labeling/faq/card
[40]: https://support.hoyoverse.com/hc/en-us/articles/50333852088217-Where-can-I-purchase-the-Battle-Pass

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
