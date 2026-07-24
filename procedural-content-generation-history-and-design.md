---
description: "プロシージャル生成（Procedural Content Generation：PCG）とは、コンテンツをあらかじめ手作業で作るのではなく、アルゴリズムによってその場で自動的に生み出す 手法である。初期のゲームにとってこれは「容量制約への苦肉の策」だった。"
---

# ゲームにおけるプロシージャル生成の技術史と設計論

## はじめに：「無限」はどこから来たのか

プロシージャル生成（Procedural Content Generation：PCG）とは、コンテンツをあらかじめ手作業で作るのではなく、**アルゴリズムによってその場で自動的に生み出す** 手法である。初期のゲームにとってこれは「容量制約への苦肉の策」だった。しかしいまや、それは「無限の体験」を設計するための積極的な選択肢へと変貌した。[[1](#ref-1)][[2](#ref-2)]

本稿では **1970–1999年・2000–2010年・2011年–現在** の3時代に区切り、歴史的変遷をたどりながら、各時代の代表的アルゴリズムと設計指針を整理する。

***

## 第一時代（1970–1999）：制約への解答

### 黎明期——容量という壁

1970年代後半、コンピュータの主記憶はKB単位だった。豊富なマップや多彩なコンテンツをあらかじめ保存しておく余裕など存在しない。プロシージャル生成が最初に採用されたのは、こうした **絶対的なハードウェア制約** に応えるためだった。[[1](#ref-1)]

**1978年：Beneath Apple Manor**（Don Worth）がApple IIで登場した。これは初期パソコン向けのコンピュータRPGで、PCGを使った最初期のゲームのひとつとして記録されている。プレイヤーが「黄金のリンゴ」を求めてランダム生成されたダンジョンを潜る構造は、後のローグライクすべての原型だ。[[3](#ref-3)][[4](#ref-4)]

### Rogue（1980）——ジャンルの始祖

1980年、Michael Toy・Glenn Wichman・Ken Arnoldの3人が *Rogue* をリリースした。アスキーアートで描かれたダンジョンは、階段を下りるたびに新規生成される。アイテム・モンスター・部屋の配置すべてがアルゴリズムで決まる。**「コンピュータ自身が冒険を生み出す」** というコンセプトは革命的であり、当時の米国大学コンピュータ学科で爆発的に広まった。ローグライクというジャンル名そのものがこのゲームから来ており、「手続き型レベル生成」「永続死（パーマデス）」「共通ルールセット」が以降の後継作品すべての柱となった。[[5](#ref-5)][[6](#ref-6)][[7](#ref-7)] ローグライクという言葉の定義や、日本での「不思議のダンジョン」系作品への受容については、別記事「[結局ローグライクってなんなのさ？](what-is-a-roguelike.md)」でも整理している。

### Elite（1984）——6バイトの宇宙

*Elite* は、宇宙を舞台に交易と戦闘を繰り広げる自由度の高いスペースシミュレーションで、いま「オープンワールド」と呼ばれるゲームの始祖的存在だ（日本では動作ハードが流通せず、ほとんど知られていない）。そのハードであるBBCマイクロは、英Acorn Computers社が1981年に「BBCコンピュータ普及プロジェクト」のために開発したイギリス製のマイクロコンピュータ（家庭用パーソナルコンピュータとも位置づけられる）で、英国の学校に広く普及した——米国におけるApple IIのような存在である。そのRAMはわずか32KB。*Elite* はゲーム全体をそのうち22KBに収めて動作したことで、PCG史上最も有名なエンジニアリングの逸話を残した。ケンブリッジ大学の学生Ian BellとDavid Brabenは、8つの銀河・2,048の惑星系・それぞれの名前・経済・政治体制・人口——すべてを **たった6バイトのシードから決定論的に生成** することに成功した。[[8](#ref-8)][[9](#ref-9)]

アルゴリズムの核は **Tribonacci数列**（3項フィボナッチ）。`s2' = s0 + s1 + s2` という単純な漸化式を繰り返すことで、惑星ごとに固有の「乱数列」を生み出す。惑星名は二文字ペア（ダイグラム）を3〜4個連結して生成される——「LAVE」（開始惑星）も「LA」+「VE」の組み合わせに過ぎない。[[9](#ref-9)]

> *「6バイトから2,048の惑星系が全て決定論的に生成される」*[[9](#ref-9)]

このゲームは2015年にギネス世界記録から「手続き型生成の世界を搭載した最初のゲーム」として認定された。ゲーム全体が22KBに収まっているが、その中に3Dワイヤーフレームレンダリング・経済システム・戦闘AIまで内包されていた。[[10](#ref-10)][[11](#ref-11)][[12](#ref-12)][[9](#ref-9)]

### Hack / NetHack / Angband（1980〜90年代）——PCGの深化

Rogueは多くの後継作を生んだ。いずれもアスキー画面でダンジョンを探索するRPGだ。Rogueの直接の影響を受けてJay FenlasonがHackを作り、そこから現在も開発が続く NetHack が派生した。別系統では、トールキンの『指輪物語』に着想を得たMoriaがAngbandへと進化する。これらはRogueより複雑なダンジョン生成と、より豊富なアイテム・モンスターバリエーションを実現した。なかでもAngbandのランダム生成に「多大な影響を受けた」と公言するBlizzard NorthのDavid Brevikが、のちにDiablo（1996）を作ることになる。[[13](#ref-13)][[5](#ref-5)]

### Diablo（1996）——PCGの商業化

*Diablo* は、ローグライクを一般向け商業タイトルへと昇華させた転換点だ。開発者Brevikが取ったアプローチは **「段階分離」**——まず部屋の配置（プレダンジョン）を生成し、次に実際のタイル・装飾・テーマルームを適用するという2段構えの構造だ。[[13](#ref-13)]

Cathedral・Catacombs・Caves・Hellの4ステージそれぞれに専用のアルゴリズムが用意されており、Cathedralでは **再帰的バジェット（Recursive Budding）**、CatacombsではBSPに近い **再帰的分割（CreateRoom）**、Cavesでは **有機的侵食ルーチン** と、ステージごとにまったく異なる雰囲気を作り出した。さらに **セットピース**（手作業で設計したクエスト専用マップ）を手続き生成の中に「埋め込む」手法を確立し、「ランダム性」と「デザインの意図」を共存させた。[[13](#ref-13)]

***

## 第二時代（2000–2010）：多様化とジャンルの確立

### Dwarf Fortress（2006）——歴史を持つ世界

*Dwarf Fortress*（Bay 12 Games）は、アスキー記号で描かれる極めて複雑なドワーフ集落運営シミュレーションで、PCGを「レベル生成ツール」から「**世界シミュレーション**」へと拡張した作品だ。プレイ前に数百〜数千年分の歴史が自動生成される——文明の興亡、戦争、英雄の誕生と死、伝説のアイテム。この生成された「歴史」はLegendsモードで閲覧でき、プレイヤーが介入する以前から世界に固有のストーリーが存在している。[[14](#ref-14)]

設計の根幹は **「現実世界のアナロジーに基づく」** こと。シミュレーションが破綻したとき、現実の物理・社会モデルに立ち返ることで修正できる、というアプローチだ。Dwarf Fortressの影響は現代まで続き、「創発的なナラティブ（Emergent Narrative）」という概念そのものをゲームデザイン界に普及させた。[[14](#ref-14)]

### Spelunky（2008）——「覚えゲー」からの解放

Derek Yuの *Spelunky*（フリー版2008年、HD版2012年）は、洞窟を探索しながら罠や敵を避け、宝を集めて奥へ進む2Dアクションゲームで、PCGの **設計哲学** において重要な転換を示す。Yuがプロシージャル生成を採用した動機は明快だ——「**プラットフォーマーがパターン記憶ゲームになることを防ぐため**」。固定マップを持つゲームでは、プレイヤーはやがてレベルを丸暗記し、スキルよりも知識に頼って進む。PCGはその「攻略本問題」を根本から排除する。[[15](#ref-15)]

SpelunkyのPCGアルゴリズムは **グリッドベースのルームシステム** だ。各レベルは4×4のグリッドで構成され、スタートからゴールへの「必ず通れるパス」がまず確定される。それ以外のグリッドはプールから選んだ手作りルームで埋められ、宝や敵の配置はルールベースで決まる。たとえばジャイアントスパイダーは「2×2の空白スペースが特定の条件を満たすときに40分の1の確率で出現し、かつ1レベルに1体しか出ない」といった具体的な制約が設けられている。[[16](#ref-16)][[17](#ref-17)]

### Minecraft（2009）——「無限の箱庭」の誕生

*Minecraft* がPCG史に残す最大の功績は、「探索の喜び」を **無限スケール** で提供したことだ。Notchが採用したのは **Perlin Noiseを含むノイズ関数** による地形生成。[[18](#ref-18)][[19](#ref-19)]

技術的な仕組みはシンプルだ——プレイヤーがワールドを新規作成すると、ゲームは「シード値」という一つの数字を起点として疑似乱数列を生成する。この数列に決してランダムではない **数学的な構造** を与えるのがPerlin Noiseで、格子点上にランダムなグラディエントベクトルを置き、それを滑らかに補間することで「自然に見えるデコボコ」を生み出す。低周波のノイズが大陸規模の起伏を作り、高周波のノイズが岩場の細かな凹凸を作る——この多重重ね合わせ（オクターブ）によってリアルな地形が実現する。[[20](#ref-20)][[21](#ref-21)][[22](#ref-22)]

**決定論的ランダム性（Deterministic Randomness）** が鍵だ。同じシード値からは必ず同じワールドが生成される。64ビット符号付き整数では約1,800京通り（≒1.8×10¹⁹）ものシードが存在し、実質的に無限のバリエーションを誇る。ワールドは「保存されている」のではなく、プレイヤーが近づいたときに **リアルタイムで計算されて存在するようになる**。[[20](#ref-20)]

***

## 第三時代（2011年–現在）：「無限の体験」の追求と限界

### The Binding of Isaac（2011）——ビルド構築ゲームとPCGの融合

Edmund McMillenの *The Binding of Isaac* は、地下室を舞台に部屋を移動しながら敵を倒し、アイテムで能力を変化させていく見下ろし型アクションゲームで、PCGを「レベル構造」だけでなく **「ビルドそのもの」** に組み込んだ作品だ。マップは「Zelda風グリッド」——フロアプランを生成してから特殊部屋を配置し、最後に各部屋の内容をプールから選択するという3段階構造を取る。[[23](#ref-23)][[24](#ref-24)]

特筆すべきはアイテムシステムだ。数百種のアイテムが互いに作用し合い、意図しなかったシナジー（壊れた強さのビルド）や最悪の組み合わせをランダムに生み出す。「今回のプレイがどんなビルドになるかわからない」という **不確実性そのものが楽しさの源泉** となっている。「スクリプトされた挑戦より、カオスで予測不能なシステムでの選択」がゲームの核心だ。[[23](#ref-23)]

### No Man's Sky（2016）——1,800京の惑星と「空虚さ」の教訓

Hello GamesのSean Murrayが作った *No Man's Sky* は、PCGの「夢の限界」を示した作品としても記録されている。**1,800京（18×10¹⁸）の惑星** がわずか6GBのディスクに収まっており、その技術的背景はEliteの直系だ——Murray自身も、1984年のEliteを直接の源流として繰り返し挙げている。[[25](#ref-25)][[26](#ref-26)][[9](#ref-9)]

惑星の地形はドメインワーピング（ノイズ関数の座標を別のノイズ関数でゆがめる技術）でオーバーハングや洞窟を生成し、バイオームルールが植物・動物の出現を決定する。生物は数百〜数千のベーステンプレートから骨格スケーリング・行動タグ・ポーズを再帰的に組み合わせて生成され、「L-システム」を使った植物生成も含まれる。音楽すら手続き的に生成される。[[27](#ref-27)][[28](#ref-28)]

しかしリリース直後の批判は痛烈だった——**「1,800京の惑星があっても、どれも同じに見える」**。PCGが「バリエーション」を生み出せても、「プレイヤーが感動する一期一会の光景」を保証するわけではない。後のアップデートで大幅な改善が行われたが、「手続き的に生成されたコンテンツは、人間が意図を込めて作ったコンテンツに比べ記憶に残りにくい」という本質的問題は今も議論される。[[29](#ref-29)][[30](#ref-30)]

### Hades（2020）——「手続き的なナラティブ」の到達点

Supergiant Gamesの *Hades* は、ローグライクのPCGをナラティブ領域へと拡張した。通常ローグライクはストーリーの語りと相性が悪い（プレイ順がランダムなため、台詞を出す文脈が定まらない）が、Hadesは **「ランダム性をむしろ受け入れる」** 設計を取った。[[31](#ref-31)]

システムは4つの要素で成り立つ——膨大な台本・優先度システム・ゲームプレイ観察・コンテキスト条件。「今回のランで何を達成したか」「直前のプレイで誰と何を話したか」「重要なストーリーイベントが発生したか」によって次に出る台詞が動的に決まる。重大なストーリーイベントが起きたとき、キャラクターは「いい武器を手に入れたね」ではなく必ずそのイベントについて語る——これを優先度システムが保証する。[[31](#ref-31)]

Supergiant Gamesは、ローグライクという形式の反復性やランダム性を、ナラティブ設計にも取り込んだ。[[31](#ref-31)]

Dead Cells（2018）は別方向のアプローチを示す。**「手作り×手続き」ハイブリッド** だ。世界の全体マップと区画間の接続は固定デザイン。その中を埋める「タイル」は手作りの部屋群から選ばれ、さらに敵配置のみが手続き的に決まる。6段階のプロセス（固定要素配置→手作りタイル設計→バイオームグラフ作成→PCGによるタイル配置→モンスター数量算出→ルートドロップ生成）で、「毎回変わる」と「一貫したクオリティ」を両立した。[[32](#ref-32)][[33](#ref-33)]

***

## アルゴリズム別テクニカルガイド

PCGに使われるアルゴリズムは多岐にわたる。主要なものを用途・特徴・代表的な採用例と共に整理する。

| アルゴリズム | 主な生成対象 | 特徴 | 代表採用例 |
|---|---|---|---|
| **Fibonacci / Tribonacci 数列** | 惑星系・番号・名前 | 超軽量。6バイトで銀河全体を記述可能 | Elite (1984) |
| **BSP（二分空間分割）** | ダンジョン部屋 | 均等に区切った空間に部屋を配置。整然とした印象 | Diablo Catacombs、NetHack系 |
| **再帰的バジェット** | 部屋の増殖 | 既存部屋から「芽吹くように」新部屋を追加 | Diablo Cathedral |
| **Drunkard's Walk（酔歩）** | 洞窟・迷路 | ランダムに掘り進む。有機的でいびつな形状 | 洞窟系ローグライク全般 |
| **セルオートマトン** | 洞窟・地形 | 「生命ゲーム」的ルールで自然な洞窟を生成 | 洞窟系、地形生成 |
| **Perlin Noise / Simplex Noise** | 地形・テクスチャ・バイオーム | 「滑らかなランダム性」。自然な地形の基盤 | Minecraft、No Man's Sky |
| **グリッドベースルームシステム** | ダンジョン間取り | 通過ルートを先に確保し残りをプールで充填 | Spelunky、Binding of Isaac |
| **L-システム** | 植物・枝・フラクタル | 再帰的な置き換えルールで有機的形状を生成 | No Man's Sky（植物）、各種CGツール |
| **WFC（波動関数崩壊）** | タイルマップ・構造物 | 制約伝播でサンプル画像と「同じ見た目」を生成 | 建物生成、タイルベース地形 |
| **Priority Queue + 条件付き台本** | ナラティブ・台詞 | 「条件が合う最高優先度のイベント」を動的に選択 | Hades |

### Perlin Noiseの仕組みをもう少し詳しく

Perlin Noiseは1982年、Ken Perlinが映画 *Tron* の制作中に開発したアルゴリズムだ。格子点にランダムな「グラディエントベクトル」を置き、任意の座標でそのベクトルとの内積を計算、周辺の格子点の値を滑らかに補間することで「連続的なランダムさ」を生み出す。[[21](#ref-21)][[22](#ref-22)]

重要なのは「**白色雑音とは違う**」ことだ。白色雑音は各点が完全にランダムで、隣り合う値に相関がない。Perlin Noiseは近くの点が近い値を持ちながらも、全体的にはランダムに見える——これが「自然に見える地形」を作り出せる理由だ。複数のスケール（オクターブ）を重ね合わせることで、大陸スケールの起伏から岩場の細部まで表現できる。[[21](#ref-21)][[20](#ref-20)]

### Wave Function Collapse（WFC）

比較的新しいアルゴリズムで、「数独を解くような」制約伝播で動作する。サンプル画像から「どのタイルが隣接できるか」のルールを自動学習し、最もエントロピーが低いセル（選択肢が少ないセル）から順に「崩壊」させる。建物や都市のタイルベース生成に特に有効で、人間が「雰囲気」のサンプルを1枚提供するだけで、同じ雰囲気を持つ無数のバリエーションを生成できる。[[34](#ref-34)][[35](#ref-35)]

***

## 設計指針：事例比較で整理する

PCGを実際に設計する際の原則を、事例と共に整理する。

### 原則1：「骨格は手作り、肉付けにPCG」

> *「プレイヤー体験の『骨格』は手動で設計し、『肉付け』をPCGで行うのが現実的」*[[29](#ref-29)]

| ゲーム | 手作り部分 | PCG部分 |
|---|---|---|
| Dead Cells | 世界マップ、区画間の接続、個別部屋タイル | タイルの配置順序、敵の配置 |
| Spelunky | 通路ルートの確保、個別ルームの手作り設計 | ルームの選択と配置、アイテム・敵の出現 |
| Diablo | クエストのセットピース、各ステージのアルゴリズム設計 | 部屋の具体的形状・接続、アイテムドロップ |
| Hades | キャラクター関係・ストーリーの骨格、台本全体 | 台詞の出現順序、ルームの組み合わせ |

Dead Cellsのチームが明示したように、「まず固定要素を配置し、PCGはその枠内で動く」構造が現実的なクオリティを保証する。[[33](#ref-33)][[32](#ref-32)]

### 原則2：評価基準を先に定義する

PCGを導入する前に「**何をもって良い生成とするか**」を決める必要がある。最低限4つを検討すること：[[29](#ref-29)]

1. **プレイアビリティ** — 生成コンテンツはプレイ可能か（出口のないダンジョンは致命的）
2. **多様性** — 十分なバリエーションがあるか
3. **制御性** — デザイナーが意図を反映できるか
4. **速度** — 要件を満たす時間で生成できるか[[29](#ref-29)]

Diabloはこれをコードレベルでも保証し、「フロアが完全に走破可能かどうか」を毎回フラッドフィルでチェックし、失敗なら再生成する。Spelunkyも「ゴールまでの経路確保」をアルゴリズムの最初のステップに置いた。[[16](#ref-16)][[13](#ref-13)]

### 原則3：PCGはゲームデザインの代替ではない

> *「PCGはゲームデザインの代わりにはならない」*[[36](#ref-36)]

プロシージャル生成はランダム性を与えるが、**ランダム性そのものが面白いわけではない**。No Man's Skyのケースは典型的な教訓だ——1,800京の惑星を生成する技術は本物だったが、「各惑星を訪れる体験の設計」が追いつかず、「広大だが空虚」という批判を受けた。「無限に **面白い** コンテンツ」は現時点では実現不可能であり、PCGの価値は「人間だけでは到達できないデザイン空間を探索し、デザイナーの創造性を拡張すること」にある。[[30](#ref-30)][[29](#ref-29)]

### 原則4：確率を「均等」にしないこと

単純なランダムは「同じようなものが続く」感覚を生み出す。優れたPCGは **確率に意図的な重みをつける**。[[36](#ref-36)]

- Spelunkyの宝は「壁に囲まれた位置ほど出やすい」——リスクとリターンの相関
- Binding of Isaacの部屋プールはフロアが深いほど難しい部屋が増えていく
- Hadesの台詞システムは重要なストーリーイベントを最高優先度に置く[[31](#ref-31)]

均等確率（一様分布）ではなく、ゲームデザインの意図を反映した **不均等確率（テーマ・難易度・進行度との相関）** を設計することが重要だ。[[36](#ref-36)]

### 原則5：シミュレーションはシンプルに保つ

Dwarf Fortressから導かれる原則：「**複雑さは必要なところにだけ使え**」。複雑すぎるシステムはデバッグを困難にし、開発を麻痺させる。サブシステムを小さく分解し、個別に理解してから組み合わせる。現実世界のアナロジーを基盤とすることで、破綻したときに「なぜ壊れたか」を把握しやすくなる。[[14](#ref-14)]

***

## 現代と未来：AIとPCGの融合

2020年代、PCGはAI・機械学習との融合フェーズに入っている。ニューラルネットワークによる「プレイしやすいレベルの自動評価」（強化学習エージェントが生成レベルを実際にプレイしてクオリティを判定）や、GANによる地形・テクスチャのリアルタイム生成が研究されている。[[2](#ref-2)]

LLM（大規模言語モデル）と手続き型生成の組み合わせも注目される。LLMが「プレイヤーの行動に基づいてリアルタイムでストーリーを展開する」システムへの応用が検討されており、Hadesが人間の作家が書いた台本で実現したことを、よりスケーラブルな形で実現できる可能性がある。ある市場調査では、AI活用PCGの市場規模は2025年時点で約68億ドルと推定され、2035年にかけて急成長が予測されている。[[37](#ref-37)][[2](#ref-2)]

しかし研究者たちが繰り返し指摘するように、生成の **速度と品質・表現力と信頼性の間には常にトレードオフが存在する**。AIが1秒で1,000のレベルを生成できても、そのなかに「プレイして楽しいレベル」が1つもなければ意味がない。技術の進化と、プレイヤーが感じる「面白さ」の設計は、依然として別次元の問題として存在し続ける。[[29](#ref-29)]

***

## まとめ：PCGの3つの役割の変遷

| 時代 | 主な役割 | 代表タイトル |
|---|---|---|
| 1978–1999 | **容量制約への解答**。22KBで宇宙を作る、パーマデスによるリプレイ価値の確保 | Rogue、Elite、Diablo |
| 2000–2010 | **コンテンツの多様化**。手作りでは不可能なスケール・深度・リプレイ性の実現 | Dwarf Fortress、Spelunky、Minecraft |
| 2011–現在 | **体験設計のツール**。PCGとハンドクラフトの融合、ナラティブへの拡張、AIとの連携 | Binding of Isaac、No Man's Sky、Dead Cells、Hades |

Rogueの設計者たちが1980年に書いたコードは、「コンピュータが冒険を作る」という夢を持っていた。40年後、その夢は実現しつつある——ただし「面白い冒険」を保証するのは、アルゴリズムではなく依然として人間の設計力だ。PCGはデザイナーの意図を「無限倍」にする技術であり、意図のない場所に魔法をかけることはできない。

---

## References

<a id="ref-1"></a>1. [手続き型生成][1] - 手続き型生成（てつづきがたせいせい、英:procedural generation）またはプロシージャル生成とは、コンピュータを用いたデータ処理（コンピューティング）の手法の一つ。

<a id="ref-2"></a>2. [Procedural generation][2] - Procedural generation is a method of creating data algorithmically as opposed to manually, typically...

<a id="ref-3"></a>3. [Beneath Apple Manor][3] - Beneath Apple Manor is a roguelike game written by Don Worth for the Apple II and published by The S...

<a id="ref-4"></a>4. [Beneath Apple Manor][4] - It's claimed to be the first CRPG and cited by Wikipedia as "one of the first video games to use pro...

<a id="ref-5"></a>5. [Rogue - Procedural Content Generation Wiki][5] - Rogue is a single player game that is the progenitor of all roguelikes. It is also one of the earlie...

<a id="ref-6"></a>6. [Procedural Level Generation in 2D Roguelite Games][6] - The roguelite game genre is considered to predate the 1980s game Rogue, which combines procedural ge...

<a id="ref-7"></a>7. [By Design: Procedural Generation - SUPERJUMP Magazine][7] - Procedural generation is a method of creating things with the use of algorithms, as opposed to manua...

<a id="ref-8"></a>8. [Elite: Remembering the Original Open-World][8] - Storing an entire galaxy within the confines of the BBC Micro's 16kB of memory was indeed no small f...

<a id="ref-9"></a>9. [[The Night Games Changed the World Part 4] Two ...][9] - Tribonacci sequence (3-term Fibonacci). s0' = s1, s1' = s2, s2' = s0+s1+s2. 4 twists per planet. 256...

<a id="ref-10"></a>10. [Elite Dangerous Wiki - Fandom][10] - According to Guinness World Records, "Elite was the first game to feature a (3D) procedurally genera...

<a id="ref-11"></a>11. [Elite (video game)][11] - In 2015, Guinness World Records awarded Elite (1984) as the first game to feature a procedurally gen...

<a id="ref-12"></a>12. [Revolutionary British video game Elite turns 40][12] - Squeezing all this groundbreaking experience within the small memory available on the BBC Micro cons...

<a id="ref-13"></a>13. [Dungeon Generation in Diablo 1 - BorisTheBrave.Com][13] - Seperation of dungeon generation into a walkability map (predungeon) and tile generation is also ver...

<a id="ref-14"></a>14. [Simulation Principles from Dwarf Fortress][14] - Dwarf Fortress is a game built on simulation, generating unique game worlds for the player to experi...

<a id="ref-15"></a>15. [Procedural Generation and Information Games][15] - In his book of the same name [3], designer Derek Yu explains that the use of PCG in. Spelunky was in...

<a id="ref-16"></a>16. [How to effectively use procedural generation in games][16] - Two examples from Spelunky. The procedural level generation in Derek Yu's roguelike platformer game ...

<a id="ref-17"></a>17. [Spelunky style procedural generation : r/gamemaker][17] - In the Spelunky version of Boss Fight Books Derek Yu explains exactly what his methodology was. It b...

<a id="ref-18"></a>18. [The Science Behind Minecraft's World Generation][18] - Minecraft relies on procedural generation—a technique where content is created dynamically using mat...

<a id="ref-19"></a>19. [Understanding Perlin Noise - an in-depth look at the ...][19] - Perlin Noise is an extremely powerful algorithm that is used often in procedural content generation....

<a id="ref-20"></a>20. [How Minecraft Terrain Generation Works][20] - Conclusion. The generation of a Minecraft world is essentially an algorithms that takes a set of num...

<a id="ref-21"></a>21. [Perlin Noise: Implementation, Procedural Generation, and ...][21] - Perlin noise is a foundational algorithm in CGI, widely used to create organic textures and naturali...

<a id="ref-22"></a>22. [Perlin noise][22] - Perlin noise is a type of gradient noise developed by Ken Perlin in 1982. It has many uses, includin...

<a id="ref-23"></a>23. [Game Design Lessons from The Binding of Isaac - KokuTech][23] - Progression is built around randomness: item drops can create brokenly powerful builds, disastrous m...

<a id="ref-24"></a>24. [Dungeon Generation in Binding of Isaac - BorisTheBrave.Com][24] - The maps get slightly larger for later levels, and the contents of rooms change, but the layout algo...

<a id="ref-25"></a>25. [Maths, No Man's Sky, and the problem with procedural ...][25] - No Man's Sky is a an astonishing mathematical algorithm for procedurally generating 18 quintillion w...

<a id="ref-26"></a>26. [No Man's Sky is only 6GB on disc][26] - Even with its monstrously huge procedurally generated galaxies, No Man's Sky will only be 6GB in its...

<a id="ref-27"></a>27. [How No Man's Sky Creates 18 Quintillion Planets With Just ...][27] - Temperature, humidity, and elevation determine what plants and animals spawn. These rules are also p...

<a id="ref-28"></a>28. [Procedural generation - No Man's Sky Wiki - Fandom][28] - No Man's Sky features a procedurally generated open universe of 18 quintillion planets, which means ...

<a id="ref-29"></a>29. [プロシージャル生成で「無限のコンテンツ」は本当に作れるのか][29] - 本記事では、PCG（Procedural Content Generation：プロシージャルコンテンツ生成）の学術的理論に基づき、「無限のコンテンツ」という夢と現実のギャップを ...

<a id="ref-30"></a>30. [It's not just No Man's Sky – procedural generation doesn't work][30] - Even worse is when your possible actions in that world are dictated by procedural generation – you c...

<a id="ref-31"></a>31. [The System Behind Hades' Astounding Dialogue][31] - How does Hades always know what to say and when to say it? Grab a free trial of Skillshare Premium: ...

<a id="ref-32"></a>32. [Building the Level Design of a procedurally generated ...][32] - A hybrid approach between procedural generation and handmade levels, giving them that consistent fee...

<a id="ref-33"></a>33. [Building the Level Design of a procedurally generated ...][33] - A hybrid approach between procedural generation and handmade levels, giving them that consistent fee...

<a id="ref-34"></a>34. [Procedural Generation: Wave Function Collapse][34] - In this blog, I wanted to explore a procedural generation algorithm called Wave Function Collapse (W...

<a id="ref-35"></a>35. [Wave Function Collapse][35] - The Wave Function Collapse Algorithm operates on a matrix of cells, which translates really well to ...

<a id="ref-36"></a>36. [Making the Most out of Procedural Generation - Jan Orlowski][36] - Procedural generation gives developers the ability to use random number generation to automatically ...

<a id="ref-37"></a>37. [AI-Powered Game Development and Procedural Content ...][37] - AI-Powered Game Development and Procedural Content Creation market size was worth around USD 6.8 bil...

[1]: https://ja.wikipedia.org/wiki/%E6%89%8B%E7%B6%9A%E3%81%8D%E5%9E%8B%E7%94%9F%E6%88%90
[2]: https://en.wikipedia.org/wiki/Procedural_generation
[3]: https://en.wikipedia.org/wiki/Beneath_Apple_Manor
[4]: https://www.roguebasin.com/index.php/Beneath_Apple_Manor
[5]: http://pcg.wikidot.com/pcg-games:rogue
[6]: https://www.theseus.fi/bitstream/10024/873015/2/Sepanmaa_Tomi.pdf
[7]: https://www.superjumpmagazine.com/by-design-procedural-generation/
[8]: https://www.gamespot.com/articles/elite-remembering-the-original-open-world/1100-6419961/
[9]: https://note.com/gstate_kamiya/n/n775c7ab83141?hl=en
[10]: https://elite-dangerous.fandom.com/wiki/Elite
[11]: https://en.wikipedia.org/wiki/Elite_(video_game)
[12]: https://blog.sciencemuseumgroup.org.uk/revolutionary-british-video-game-elite-turns-40/
[13]: https://www.boristhebrave.com/2019/07/14/dungeon-generation-in-diablo-1/
[14]: http://www.gameaipro.com/GameAIPro2/GameAIPro2_Chapter41_Simulation_Principles_from_Dwarf_Fortress.pdf
[15]: https://ieee-cog.org/2020/papers/paper_87.pdf
[16]: https://www.gamedeveloper.com/design/how-to-effectively-use-procedural-generation-in-games
[17]: https://www.reddit.com/r/gamemaker/comments/kao357/spelunky_style_procedural_generation/
[18]: https://www.linkedin.com/pulse/science-behind-minecrafts-world-generation-apoorv-garg-xp8mc
[19]: https://www.reddit.com/r/gamedev/comments/2d284n/understanding_perlin_noise_an_indepth_look_at_the/
[20]: https://cybrancee.com/blog/how-minecraft-terrain-generation-works/
[21]: https://garagefarm.net/blog/perlin-noise-implementation-procedural-generation-and-simplex-noise
[22]: https://en.wikipedia.org/wiki/Perlin_noise
[23]: https://www.kokutech.com/blog/gamedev/design-patterns/unique-mechanics/the-binding-of-isaac
[24]: https://www.boristhebrave.com/2020/09/12/dungeon-generation-in-binding-of-isaac/
[25]: https://www.thumbsticks.com/no-mans-sky-problem-procedural-generation/
[26]: https://www.tweaktown.com/news/52967/mans-sky-6gb-disc/index.html
[27]: https://dev.to/dubeykartikay/how-no-mans-sky-creates-18-quintillion-planets-with-just-math-3fgf
[28]: https://nomanssky-archive.fandom.com/wiki/Procedural_generation
[29]: https://zenn.dev/dsgarage/articles/procedural-content-generation
[30]: https://extremelyroomypockets.wordpress.com/2016/08/30/its-not-just-no-mans-sky-procedural-generation-doesnt-work/
[31]: https://www.youtube.com/watch?v=bwdYL0KFA_U
[32]: https://www.moddb.com/news/the-level-design-of-a-procedurally-generated-metroidvania
[33]: https://www.gamedeveloper.com/design/building-the-level-design-of-a-procedurally-generated-metroidvania-a-hybrid-approach-
[34]: https://blog.ptidej.net/procedural-generation-using-wave-function-collapse/
[35]: https://www.uproomgames.com/dev-log/wave-function-collapse
[36]: https://janorlowski.com/blog/2020/2/20/when-everything-is-random-nothing-is-interesting
[37]: https://www.sphericalinsights.com/blogs/ai-powered-game-development-and-procedural-content-creation

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
