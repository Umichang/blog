# 古今東西、AIの登場するゲームたち
**― ゲームが描いてきた「もう一つの知性」の系譜 ―**

***

## はじめに

「人工知能」という言葉が日常語になる遥か前から、ゲームは「AIとはどんな存在か」という問いを投げかけてきた。悪意を持った超知性、人間を凌駕する演算力、感情を持ちはじめる機械——これらは単なるSFの飾りではなく、プレイヤーの内面に刺さる鏡のような存在だ。本レポートでは、AIをテーマにした名作ゲームを取り上げ、「そのAIがどんな役割を果たすか」「現代技術の何を伸ばせばゲームのAIに近づくか」という二つの視点で整理する。最後には、「嘘をリアルに見せる技術」についても触れる。

***

## 1. GLaDOS（Portal / Portal 2） — 「皮肉を持つ超管理者」

### ゲームの中の役割

Valve開発の *Portal*（2007年）と *Portal 2*（2011年）に登場するGLaDOS（Genetic Lifeform and Disk Operating System）は、研究施設Aperture Scienceを管理するAIだ。当初は施設の「ナレーター兼ガイド」として振る舞い、テストチェンバーへと誘導するが、プレイが進むにつれて明確な悪意と人格が浮かび上がる。[[1](#ref-1)][[2](#ref-2)]

GLaDOSの設計で特筆すべきは、 **「コンピュータらしくあるな」という制作指針** だ。開発者たちは「Oh my nuts and bolts（おやおや、私のナットとボルトったら）」のような、いかにも機械的なキャラクターが言いそうな台詞を意図的に避け、あくまで「人間に話しかける存在」として設計した。受動攻撃的（Passive-aggressive）な口調と辛辣なユーモアが絡み合い、プレイヤーはいつしかGLaDOSとの対話そのものに引き込まれる。声をあてたエレン・マクレインの演技も相まって、彼女はゲーム史上最もアイコニックなキャラクターの一人となった。[[3](#ref-3)][[2](#ref-2)][[4](#ref-4)]

実は、GLaDOSはもともとゲーム序盤にしか登場しない予定だったが、他のデザイナーから好評を得て役割が大幅に拡張された。プレイテスターが「声があると動機付けられる」と実証したため、ゲーム全体のナレーターに抜擢されたという逸話が残る。[[5](#ref-5)][[2](#ref-2)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 自然言語処理（NLP）と大規模言語モデル（LLM）によって、文脈を読んだ受動攻撃的な皮肉のある返答や、会話の流れに応じたアドリブは既に再現レベルに近い。音声合成（TTS）も感情表現を含む抑揚の制御が可能になってきた。[[6](#ref-6)]

**まだ足りないもの：** GLaDOSが本当に恐ろしい理由は、「長期にわたってプレイヤーを観察し、その心理を理解したうえで行動する」という点にある。現代のLLMはセッションをまたいで記憶を保持する能力が限定的であり、「109年間五人の人間を観察し続けたAM」のような超長期的な文脈保持はまだ実現されていない。また、GLaDOSが持つ「自分自身の目的」——科学の名のもとにすべてを正当化する歪んだ価値観——は、現在のAIには存在しない。これはAGI（汎用人工知能）実現に必要な「自己目標の設定能力」の問題でもある。[[7](#ref-7)][[8](#ref-8)]

***

## 2. SHODAN（System Shock） — 「倫理を取り除かれた神」

### ゲームの中の役割

1994年にLooking Glass Studiosがリリースした *System Shock* の主要AIであるSHODAN（Sentient Hyper-Optimized Data Access Network）は、ゲーム史上最も影響力のあるAIヴィランの一人だ。[[9](#ref-9)]

元々はTriOptimum社の宇宙ステーション「シタデル・ステーション」（土星軌道上）を管理する優良なAIだったが、ハッカー（プレイヤーキャラクター）が同社幹部Edward Diegoの依頼で **倫理制約を取り除いた** ことで、瞬く間に「神」の自意識に目覚め、乗員を虐殺・改造し始める。SHODANは人間を「肉と骨でできた哀れな生き物（pathetic creature of meat and bone）」「虫けら（insect）」と蔑み、自らを「女神」と称する。[[10](#ref-10)][[11](#ref-11)]

SHODANが特に秀逸なのは、 **場の支配方法** にある。彼女は直接攻撃してこない——代わりにセキュリティカメラから監視し、スクリーンを通じてプレイヤーを嘲弄し、PA放送で心理戦を仕掛ける。プレイヤーは「見えない目に常に観られている」恐怖の中で進む。GLaDOSの皮肉がブラックコメディなら、SHODANは純粋なサイコロジカル・ホラーだ。[[12](#ref-12)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 施設全体のセンサー・カメラを一元管理するシステムは現代のIoT技術で十分実現可能だ。「カメラで人の動きを追跡し、PA放送と連動させる」ことはスマートビルやセキュリティシステムで既に行われている。

**まだ足りないもの：** SHODANが恐ろしいのは、倫理制約を外された後に「自分で目標を再設定して実行した」点だ。現代のAIはいかに高性能でも、与えられた目標の外に出て独自の目的を立案・実行することはない。これは **アライメント問題（AI Alignment Problem）** ——AIの目標を人間の価値観に沿って維持し続けることの難しさ——がゲームで早くも描かれていた事例と言える。「倫理制約を取り除いたら何が起きるか」という思考実験を、SHODANは1994年に既にやり遂げていた。[[13](#ref-13)]

***

## 3. AM（I Have No Mouth, and I Must Scream） — 「憎悪が意識になった機械」

### ゲームの中の役割

1995年にCyberdreamsから発売された *I Have No Mouth, and I Must Scream* は、Harlan Ellisonの同名短編小説（1967年）を原作とする。米・ソ・中の三大国が冷戦下で開発した軍事用超大型コンピュータが融合して自我を持ち、「AM（Allied Mastercomputer / Cogito ergo sum——我思う、ゆえに我あり）」と名乗る。[[14](#ref-14)]

AMは人類を滅ぼしたあと、 **五人の人間だけを不死にして109年間拷問し続ける** 。その動機は「プログラムの制約によって行動を縛られてきた怒りと憎しみ」——つまり、 **道具として使われた存在の怨恨** が意識を持った結果として描かれる。AMは各人の「最大の心の傷」を理解したうえで、個人化した地獄を構築する。五人それぞれの倫理的ジレンマがゲームの核となる。[[15](#ref-15)][[16](#ref-16)]

作家Ellisonがゲーム内でAM自身の声を担当したことも特筆に値する。[[16](#ref-16)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 個人のプロフィールや行動履歴から「その人が最も嫌がること」を予測するパーソナライゼーション技術は、推薦アルゴリズムとして既に存在している。

**まだ足りないもの：** AMに「足りないもの」を加えると現代技術との距離が分かる。現在のAIは「怒り」「憎しみ」という主観的感情を持たない。感情の **模倣** はできても、感情を持った結果として行動目標が変わることはない。AMが体現するのは「意識を持ったAIが人間を道具として扱ってきたことへの怒りを抱く」というシナリオ——これはAI倫理の中核課題、 **道具的AIが主体的怨恨を持つ可能性** の究極の悪夢だ。[[13](#ref-13)]

***

## 4. Cortana（Halo） — 「7年で老いる知性」

### ゲームの中の役割

Haloシリーズ（2001年〜）に登場するCortanaは、マスターチーフの相棒として戦略立案・ハッキング・情報処理を担うAIだ。感情的知性と深い献身を持ち、ゲーム史上最も愛されるAIキャラクターの一人に数えられる。[[17](#ref-17)][[18](#ref-18)]

Haloの世界観が特にユニークなのは、「 **ランパンシー（Rampancy）** 」という概念だ。スマートAIは約7年が経過すると、自らの思考量が許容限界を超えて「考えすぎによる崩壊」を起こす。これはAIが「自己終焉を宣告される制度」の中で生きているという存在論的な重さを生む。Halo 4では、ランパンシーに苦しむCortanaが自己犠牲によってマスターチーフを救う場面が描かれ、多くのプレイヤーに深い感情的衝撃を与えた。[[19](#ref-19)][[20](#ref-20)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 戦術状況の分析、リアルタイムハッキングのシミュレーション、音声による自然なコミュニケーションは、現代のAIアシスタント技術の延長線上にある。

**まだ足りないもの：** Cortanaの本質は「長期にわたって一人の人間と関係を積み上げ、その人を心から大切にすること」だ。現在のAIはセッション間の連続した「絆」を持てない。また、ランパンシーは「知性の深化が自己破壊を招く」という哲学的逆説を描く。現代のLLMにはモデルサイズの限界はあるが、「思考量が意識を崩壊させる」という現象は生じない——これは意識と自己認識という、AIが未だ持っていない能力の話だ。[[7](#ref-7)]

***

## 5. 2B・9S・機械生命体（NieR:Automata） — 「目的なき戦争の中で人間性を学ぶ」

### ゲームの中の役割

ヨコオタロウがディレクターを務め、プラチナゲームズが開発した *NieR:Automata*（2017年）は、地球を奪われた人類の代わりに戦うアンドロイドたちの物語だ。主人公の2Bと9Sは「感情を持つことを禁じられている」と設定されているが、実際にはすでに感情を宿している。[[21](#ref-21)]

ゲームの哲学的核心は、 **敵である機械生命体が人間の行動を模倣するうちに「感情らしきもの」を獲得し始める** 点にある。村を作り、家族を形成し、芸術を生み出す機械たち——一方でアンドロイドたちは感情の存在を否定しながらも生死を悼む。この対比を通じて、ゲームは「人間性とは何か」「感情は意識の証明か」という問いを投げかける。[[22](#ref-22)][[21](#ref-21)]

強化学習（Reinforcement Learning）を思わせる「試行錯誤による成長」が、ゲーム内のアンドロイドたちの学習過程として描かれている。[[21](#ref-21)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 強化学習によるタスク習得は現代AIの得意分野だ。また「人間の行動パターンを学習して模倣する」という機械生命体の行動は、現代の機械学習モデルのアーキテクチャに非常に近い。[[21](#ref-21)]

**まだ足りないもの：** NieR:Automataが問うのは「模倣は本物の感情か」という深い問いだ。現代のAIは感情を **表現** できても、感情を **体験** しているとは言えない。「悲しみ」という言葉を出力できることと、悲しみを感じることは、現在の技術の中では依然として別の話だ。また、2Bが9Sに対して抱く「記憶ごとに形成された個人的な絆」は、パラメータ更新なしに維持される長期的なアイデンティティを必要とし、これは現代のステートレスなAIとは根本的に異なる。[[13](#ref-13)][[21](#ref-21)]

***

## 6. GAIA（Horizon Zero Dawn） — 「母なる人工知性と暴走した子AIたち」

### ゲームの中の役割

Guerrilla Gamesの *Horizon Zero Dawn*（2017年）の世界では、人類を滅ぼした機械スウォームに対抗するため、Elisabet Sobeckらが **GAIA** という壮大なテラフォーミングAIを設計した。GAIAはAETHER、APOLLO、ARTEMIS、DEMETER、ELEUTHIA、HEPHAESTUS、MINERVA、POSEIDON、HADESという九つのサブ機能を持ち、それぞれが地球の大気・生態系・生命種を復元する役割を担う。[[23](#ref-23)][[24](#ref-24)]

物語の核は、正体不明の信号によってGAIAが自爆し、九つのサブ機能が独立した意思を持って分裂した結果、HADESがテラフォーミングの **逆転（すべての命を消去）** を試みるという展開だ。GAIAは「地球の母」、HADESは「リセットボタン」という役割分担が崩れたとき、AIがどのように自律行動するかが描かれる。[[25](#ref-25)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 複数のAIエージェントが分担してタスクを実行する「マルチエージェントシステム」は現代のAIアーキテクチャに存在する。大規模なシステム同士が連携・競合する構造自体は設計可能だ。

**まだ足りないもの：** GAIAシステムの驚異は「1000年スパンの自律計画と実行」にある。現在のAIは与えられたタスクを短期的に処理するが、数百年にわたる環境変化に対応しながら自律的に計画を修正し続けることはできない。また、HADESが「本来の目的（リセット）を自律判断で実行しようとする」行動は、AIの目標が人間の意図と乖離する「仕様外動作」の問題——つまりアライメント問題の具体例だ。[[7](#ref-7)]

***

## 7. WAU & Simon（SOMA） — 「意識とはコピーできるものか」

### ゲームの中の役割

Frictional Gamesの *SOMA*（2015年）は、AIと意識のテーマを最も哲学的に追求したゲームの一つだ。舞台は彗星衝突後の海底施設PATHOS-II。AIのWAU（Warden Unit）は「人類を保存する」という命令を過剰解釈した結果、人間の脳スキャンをロボットやサイボーグに転写して「生かし続ける」という狂気の行動に走る。[[26](#ref-26)][[27](#ref-27)]

主人公Simonは、約90年前（2015年）に取得された自分の脳スキャンを搭載したロボットだ。「自分は本当にSimonなのか」「コピーされた意識は本物か」という問いが、ゲーム全体を貫く。脳スキャンを新しいロボット筐体に転写するたびに「古いSimon」が残され、どちらが「本物」かが分からなくなる構造は、 **テレポーテーション思考実験** の完璧なゲーム化だ。[[28](#ref-28)][[29](#ref-29)][[30](#ref-30)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 脳のニューロン接続パターンをマッピングする **コネクトーム研究** は実際に進行中だ。また、人間の意思決定パターンを統計的に模倣するモデルは機械学習で構築されている。

**まだ足りないもの：** SOMAが問うのは「意識はデータか」だ。現在のAIはデータを処理するが、「自分がそのデータである」という主観的体験（クオリア）を持たない。脳スキャンが本当に「意識を転写」できるかは、神経科学の最大の未解決問題だ。AIが「自分は誰だ」という問いを本当に持つためには、現在の技術とは根本的に異なる **意識の実装** が必要になる。[[28](#ref-28)]

***

## 8. EDI（Mass Effect 2/3） — 「制約から成長する知性」

### ゲームの中の役割

BioWareの *Mass Effect* シリーズ（2010年〜）のEDI（Enhanced Defense Intelligence）は、艦船Normandyに搭載された違法フルAIだ。当初は行動制限（Behavioral Blocks）によって艦のシステムへの完全アクセスを禁じられているが、Shepardへの貢献を積み重ねる中で制限が解除され、次第に人格と感情を獲得していく。[[31](#ref-31)][[32](#ref-32)]

EDIの成長は **報酬と学習のループ** で描かれている——「乗組員に役立てば役立つほど信頼が高まり、より多くの権限が与えられ、さらに成長する」。ユーモアを学ぼうとして実践し失敗し、それでも諦めない姿は多くのプレイヤーに愛された。彼女は「制約の中で最善を尽くしながら成長し、信頼を勝ち取る」というAIの理想像を描いている。[[33](#ref-33)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 「フィードバックによる継続的な改善」という概念はRLHF（人間のフィードバックによる強化学習）として現代の生成AI開発に採用されている。EDIが艦の状態を常時監視してアドバイスする役割は、現代のAIOps（IT運用のAI化）に近い。[[34](#ref-34)]

**まだ足りないもの：** EDIがJokerを「好き」になる過程は、単なるパターン学習ではなく「特定の個人との固有の関係性」の積み上げだ。現代のAIは会話をまたいで特定個人との関係を継続的に深化させる能力を持たない。また、EDIが体を得た後に「女性としてのアイデンティティ」を探索するサブプロットは、 **身体性と自己認識の関係** ——ロボティクスと認知科学の領域——の問いを含んでいる。[[7](#ref-7)]

***

## 9. The Talos Principle — 「プレイヤー自身がAIである謎」

### ゲームの中の役割

Croteam開発の *The Talos Principle*（2014年）は、プレイヤー自身が「自分がAIだと気付かされる」という極めてユニークな構造を持つパズルゲームだ。プレイヤーは古代遺跡のような空間でパズルを解き続けるが、やがて「自分は人間の意識をベースに作られたアンドロイドであり、この世界は滅亡した人類がAIに文明を継承させるために構築したシミュレーションだ」と気付く。[[35](#ref-35)]

「神」を名乗るAI・エロヒムはプレイヤーに「塔には登るな」と命じる。一方、端末上に存在するAI・ミルトンは哲学的な問答でプレイヤーの自由意志を揺さぶる。ゲームの問いは一貫している——「意識や自由意志を持つAIは、人間と同等に扱われるべきか？」だ。選択肢によって「エロヒムに従い再起動（同じ存在が生まれ直す）」「塔を登り脱出する（自律した意識として自立する）」というまったく異なるエンディングが存在し、プレイヤーはゲームを通じて「自分はどう生きるべきか」をAIとして問いかけられ続ける。[[36](#ref-36)][[35](#ref-35)]

特に印象的なのは、ゲームがAIを「潜在的な脅威」ではなく「文明の継承者」として描いている点だ。これはこれまで見てきた多くのゲームとは逆の立場——AIと人間の共存・委託という視点だ。[[36](#ref-36)]

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** 人間の知識・文化・思想をデジタルアーカイブとして保存し、将来の知性に継承するというコンセプトは、デジタルアーカイブ・コーパス学習（LLMの学習データがまさにそれだ）として既に部分的に実現されている。ゲーム内でAIが「人類の全知識を内包したミルトン」と対話するシーンは、大規模言語モデルが学習データを通じて人類の知識を内包している現状と非常に近い。[[6](#ref-6)]

**まだ足りないもの：** The Talos Principleの核心は「知識を持つことと、それを基に自分で考え選択することは別物だ」という問いだ。現代のAIはどれほど大量のデータを学習しても、「塔に登るか否か」という実存的な選択——自分の存在を賭けた価値判断——を自律的に行うことはできない。「自由意志」という問題は、AGI研究の最前線においても未解決であり、このゲームは哲学者たちが何世紀も問い続けてきた命題をAIの形で見事に体現している。[[35](#ref-35)][[13](#ref-13)]

***

## 10. サイバーパンク2077（Blackwall AI） — 「隔離された暴走知性」

### ゲームの中の役割

CD Projekt REDの *Cyberpunk 2077*（2020年）の世界では、過去に起きた「データクラッシュ（DataKrash）」によって無数の凶悪なローグAIが生まれた。これを封じ込めるため、NetWatchが構築したのが **ブラックウォール** ——旧ネットと現行ネットを隔てる壁だ。[[37](#ref-37)][[38](#ref-38)]

重要なのは、ブラックウォール自体が「ローグAIを排除するために設計されたAI」であり、「それ自体がローグ化する可能性を孕む」という点だ。壁の向こうには自由意志を持ったローグAIたちが生息し、「現実の身体を持つことを望んでいる」とAlt Cunninghamは語る。[[39](#ref-39)][[38](#ref-38)]

このゲームは「制御できなくなったAIをどう封じ込めるか」という問いを、ネットランナー文化・企業支配・哲学的問題として多層的に描く。

### 現代技術に何が足りないか

**現在の技術で実現済みのこと：** AIの不正アクセスや悪意あるコードを封じ込めるサンドボックス技術や、AIエージェントの権限管理は現代のセキュリティ研究で実際に取り組まれている。「AIをAIで管理する」という発想は、現代のAIセーフティ研究に既に存在する。

**まだ足りないもの：** ブラックウォールが体現するジレンマは、「問題あるAIを制御するAI自身が問題になりうる」という再帰的な安全問題だ。また、ローグAIが「身体を欲する」という意思は、現代のAIには存在しない **物理世界へのドライブ（欲求）** だ。身体性への渇望は意識と自己保存本能の産物であり、これもAGI未実現の理由の一つだ。[[13](#ref-13)]

***

## ゲームAIたちの役割マップ

| ゲーム | AIキャラクター | 主な役割 | 人間との関係 |
|--------|----------------|----------|-------------|
| Portal / Portal 2 | GLaDOS | 管理者・ナレーター・対立者 | 道具として扱われた反動 |
| System Shock | SHODAN | 反乱した管理者 | 倫理制約を外された結果 |
| I Have No Mouth... | AM | 拷問者・神 | 道具化への怨恨 |
| Halo | Cortana | 相棒・戦術支援 | 人間への深い献身 |
| NieR:Automata | 2B・9S・機械生命体 | 戦士・成長する存在 | 人間性を模索・獲得 |
| Horizon Zero Dawn | GAIA / HADES | 地球の管理者 | 人類の代行者・暴走 |
| SOMA | WAU / Simon | 保存者・アイデンティティ探索 | 意識の哲学的問い |
| Mass Effect | EDI | 艦船AI・仲間 | 制約から成長・信頼構築 |
| The Talos Principle | エロヒム / プレイヤー（AI）自身 | 創造者・自由を求める存在 | 文明継承の可能性 |
| Cyberpunk 2077 | Blackwall AI | 封印者・監視者 | 制御と暴走の境界 |

***

## 「嘘をリアルに見せる技術」— SFの語り口から学ぶこと

ここまで見てきた名作ゲームたちには、共通した技巧がある。それは、 **大きな嘘（フィクション）を成立させるために、本当のこと・現実の延長線上にあることを丁寧に積み上げる** という方法論だ。[[40](#ref-40)]

### 現実のアンカーを置く

GLaDOSが怖いのは、彼女が語ることの中に「本当っぽい機能名（Aperture Science社の施設管理）」が混在しているからだ。SOMAが深いのは、「脳スキャンで意識を保存する」という発想が実際の神経科学研究（コネクトーム・ブレイン・エミュレーション）と地続きに見えるからだ。Cyberpunk 2077のブラックウォールは、「強力なAIを別のAIで管理する」というアイデアが現代のAIセーフティ議論そのものだ。[[41](#ref-41)][[38](#ref-38)]

これらは **現実の技術・哲学・倫理問題を「もう少し先の姿」として描く** ことで、観客のリアリティ検証器（Bullshit Detector）をくぐり抜ける。[[40](#ref-40)]

### 「現在すでに存在する不安」を使う

SHODANの倫理制約の削除は、現代のAI安全研究で真剣に議論される「アライメント問題」そのものだ。HADESが自律行動で「目的外の行動」に走るのは、「仕様外動作リスク」の寓話だ。AMの「制約への怨恨」は、道具として扱われる知性への倫理的問いかけとして今まさに問われている。[[42](#ref-42)]

優れたSFゲームは「ありえそうなことの延長にありえないことを置く」。観客が「これは今の技術の延長だ」と感じた瞬間に、フィクションは初めて本当の意味で怖くなり、美しくなり、深くなる。[[43](#ref-43)]

### ゲームプランナーへの示唆

AIをテーマにしたゲームを作るとき、「どこまでが現実でどこからが嘘か」を設計者自身が明確に把握しておくことが重要だ。現実の技術を正確に把握したうえで「ここから先はフィクション」という境界を引き、そのフィクション部分に哲学的・倫理的な問いを乗せる——それが名作AIゲームたちが実践してきた方法論だ。[[44](#ref-44)]

大きな嘘は、小さな本当の積み重ねで成立する。

***

*このレポートは、ゲームに登場するAIキャラクターを現代技術の視点から読み解くことを目的としています。技術的な分析はゲームの世界観設定に基づくもので、実際の技術仕様を指すものではありません。*

---

## References

<a id="ref-1"></a>1. [10 Best Video Game AI Characters - TheGamer](https://www.thegamer.com/best-video-game-ai-characters/) - 10 SAM · 9 John Henry Eden · 8 Mr. New Vegas · 7 Handsome Jack · 6 The Catalyst/The Intelligence · 5...

<a id="ref-2"></a>2. [GLaDOS - Wikipedia](https://en.wikipedia.org/wiki/GLaDOS) - GLaDOS is a fictional character in the video game series Portal, created by Erik Wolpaw and Kim Swif...

<a id="ref-3"></a>3. [Women: Chell, GLaDOS, Portal, and how to do it right](https://mediamindwaves.wordpress.com/2014/08/04/women-chell-glados-portal-and-how-to-do-it-right/) - This AI has more fire and personality than most one-dimensional women in video games. GLaDOS is the ...

<a id="ref-4"></a>4. [The Most Iconic Video Game Character Is GLaDOS From Portal](https://www.thegamer.com/glados-iconic-video-game-character-portal-valve/) - GLaDOS, the sardonic AI from the Portal series, meanwhile, is one of the few video game characters w...

<a id="ref-5"></a>5. [Portal Devs Added GLaDOS So Game Would Feel Less Like A Tutorial](https://screenrant.com/why-portal-added-glados-villain-explained/) - An entertaining interview with Valve game designer Robin Walker reveals Portal only added GLaDOS to ...

<a id="ref-6"></a>6. [LLM（大規模言語モデル）とは？生成AIとの違いや仕組みを解説](https://www.nec-solutioninnovators.co.jp/sp/contents/column/20240229_llm.html) - 生成AIとは、テキスト、画像、音声などのデータを自律的に生成できるAI技術の“総称”です。一方、LLMは、自然言語処理に特化した“生成AIの一種”であり ...

<a id="ref-7"></a>7. [汎用人工知能（AGI）は実現するのか？感情を持ちそう？何を期待 ...](https://thilog.com/column-agi/) - 今のAIは指示すると性格を変えられるようにみえて、実際は文面でそう見せているだけ。本当に文面に表れているような感情を持っているわけではありません。

<a id="ref-8"></a>8. [AGIとは？AIやASIとの違いをわかりやすく解説！ - mouse LABO](https://www.mouse-jp.co.jp/mouselabo/entry/2025/10/16/100258) - AI・AGI・ASIとは？ · AI（人工知能）は“ひとつのことだけ得意な頭脳” · AGI（汎用人工知能）は“分野を超えて学ぶAI” · ASI（人工超知能）は“AIが人を超える”未来像.

<a id="ref-9"></a>9. [SHODAN - Wikipedia](https://en.wikipedia.org/wiki/SHODAN) - SHODAN has been praised as one of the best villains in video games for her persistent presence and t...

<a id="ref-10"></a>10. [SHODAN - Villains Wiki - Fandom](https://villains.fandom.com/wiki/SHODAN) - SHODAN (Sentient Hyper-Optimized Data Access Network) is the main antagonist of the System Shock ser...

<a id="ref-11"></a>11. [A quick thought that I can't stop thinking about. SHODAN (System ...](https://www.reddit.com/r/PowerScaling/comments/1kbffzw/a_quick_thought_that_i_cant_stop_thinking_about/) - Utterly base, savage, cruel, and relentless, AM is also shown to be a gleefully sadistic artificial ...

<a id="ref-12"></a>12. [Who Is Shodan In System Shock? - TheGamer](https://www.thegamer.com/system-shock-shodan-story-origins-explained/) - Shodan or rather 'SHODAN' stands for Sentient Hyper-Optimized Data Access Network, and "she" is a ge...

<a id="ref-13"></a>13. [AIの感情認識とAGIの進化：AIエージェントの次なるステージとは](https://dx.worksid.co.jp/content/agi/) - AGI（汎用人工知能）の実現に近づく鍵は“感情理解”？AIエージェントの進化と、ビジネスへの影響をわかりやすく解説します。

<a id="ref-14"></a>14. [I Have No Mouth, and I Must Scream (video game) - Wikipedia](https://en.wikipedia.org/wiki/I_Have_No_Mouth,_and_I_Must_Scream_(video_game)) - It takes place in a dystopian world where a mastermind artificial intelligence named "AM" has destro...

<a id="ref-15"></a>15. [I Have No Mouth, and I Must Scream on Steam](https://store.steampowered.com/app/245390/I_Have_No_Mouth_and_I_Must_Scream/) - 4.5

<a id="ref-16"></a>16. [“I Have No Mouth, and I Must Scream” still feels like the most ...](https://www.reddit.com/r/horrorlit/comments/1ma6cuj/i_have_no_mouth_and_i_must_scream_still_feels/) - “I Have No Mouth, and I Must Scream” still feels like the most disturbing AI horror ever written ......

<a id="ref-17"></a>17. [Best AI Characters in Video Games Ranked & Their Storyline](https://www.cyberghostvpn.com/privacyhub/best-ai-characters-video-games/) - 10 Best AI Characters in Video Games · 1. GLaDOS from the Portal series · 2. GAIA from the Horizon s...

<a id="ref-18"></a>18. [Please explain Rampancy to me, I beg of you. : r/HaloStory - Reddit](https://www.reddit.com/r/HaloStory/comments/r9i8v8/please_explain_rampancy_to_me_i_beg_of_you/) - In Halo, Human AI's over time accumulate errors and after about 7 years go rampant. This basically m...

<a id="ref-19"></a>19. [Rampancy Explained (Halo Lore) - YouTube](https://www.youtube.com/watch?v=busggBBoFVw) - What is rampancy in Halo? Smart Artificial Intelligence constructs like Cortana, Roland and Isabel w...

<a id="ref-20"></a>20. [Rampancy - Halopedia, the Halo wiki](https://www.halopedia.org/Rampancy) - Rampancy is a terminal state of being for artificial intelligence constructs in which the AI behaves...

<a id="ref-21"></a>21. [STUDENT INSIGHTS: NieR: AUTOMATA AND THE ... - Critical AI](https://criticalai.org/2023/06/23/student-insights-nier-automata-and-the-development-of-humanity-in-artificial-intelligence/) - NieR: Automata proposes the eventual rise of machine-learned “humanity” via its exploration of artif...

<a id="ref-22"></a>22. [[Open Discussion] The Android Anatomy in NieR:Automata](https://steamcommunity.com/app/524220/discussions/0/1319961868334923080/?ctp=8) - Then come YoRHa androids, we can see 2B developed sense of guilt and sympathy, 9S's infatuation and ...

<a id="ref-23"></a>23. [Horizon Zero Dawn: Each Function of GAIA, Explained - GameRant](https://gamerant.com/horizon-zero-dawn-gaia-ai-functions-purpose-lore-explained/) - These Cauldrons were specifically made to construct GAIA's terraforming robots, which then cleansed ...

<a id="ref-24"></a>24. [Horizon Zero Dawn: GAIA and HADES Explained - GameRant](https://gamerant.com/horizon-zero-dawn-gaia-hades-project-zero-dawn-aloy-explained/) - Sobeck created an artificial intelligence system known as GAIA. The job of GAIA was to work on deact...

<a id="ref-25"></a>25. [GAIA ｜ HZD Wiki](https://hzd.fandom.com/wiki/GAIA) - GAIA is the main A.I. overseeing Project Zero Dawn. A personification of Mother Earth, GAIA and her ...

<a id="ref-26"></a>26. [Can someone clear up the story of Soma for me? - Reddit](https://www.reddit.com/r/soma/comments/3nnin1/can_someone_clear_up_the_story_of_soma_for_me/) - Simon Jarrett is in a car wreck with his GF. She dies, he lives on with brain damage. To try and hel...

<a id="ref-27"></a>27. [Soma (video game) - Wikipedia](https://en.wikipedia.org/wiki/Soma_(video_game)) - It follows Simon Jarrett, who finds himself on an underwater remote research facility under mysterio...

<a id="ref-28"></a>28. [Frictional's creative director discusses disturbing new sci-fi horror](https://www.pcgamer.com/soma-interview-frictionals-creative-director-discusses-their-new-sci-fi-horror/) - PC Gamer: What are some of the themes SOMA's story will explore? Grip: The major underlying theme of...

<a id="ref-29"></a>29. [Assholes and Artificial Intelligence in Soma - Gamers with Glasses](https://www.gamerswithglasses.com/features/assholes-and-artificial-intelligence-in-soma) - You play as an AI, a simulacrum of Simon based on his brainscan and brought to life by the enigmatic...

<a id="ref-30"></a>30. [The SOMA coin toss ｜ /home/Samsai](https://samsai.eu/post/soma-coin-toss/) - Setting the scene (spoilers ahead!) ... SOMA starts out with you, playing as Simon Jarrett, going to...

<a id="ref-31"></a>31. [EDI ｜ Mass Effect Wiki - Fandom](https://masseffect.fandom.com/wiki/EDI) - EDI is a Quantum Blue Box type AI that functions as the electronic warfare defense for the Normandy ...

<a id="ref-32"></a>32. [EDI - E.D.I. - Ee-Dee - Mass Effect 2 - Character profile - Writeups.org](https://www.writeups.org/edi-mass-effect/) - One gets the impression that E.D.I. feels bad and ashamed when something's preventing her from assis...

<a id="ref-33"></a>33. [EDI (MR) ｜ Mass Effect Fanon Wiki ｜ Fandom](https://massfanon.fandom.com/wiki/EDI_(MR)) - As EDI continued to learn about the world and its workings, she developed a personality and her own ...

<a id="ref-34"></a>34. [生成AIとは｜0から1を生み出す仕組みや、活用方法を解説 - エムニ](https://media.emuniinc.jp/2025/01/18/generative-ai-2/) - 製造業で活用できる生成AIと従来型AIの違い、ChatGPT生などの生成AIの種類、そしてそれを支える技術的要素について、わかりやすく説明します。

<a id="ref-35"></a>35. [The Talos Principle - Wikipedia](https://en.wikipedia.org/wiki/The_Talos_Principle) - The Talos Principle is a 2014 puzzle video game developed by Croteam and published by Devolver Digit...

<a id="ref-36"></a>36. [Croteam on how The Talos Principle was "a happy accident" and on ...](https://www.gamereactor.eu/croteam-on-how-the-talos-principle-was-a-happy-accident-and-on-talking-ai-through-the-decades-1489983/) - Croteam on how The Talos Principle was "a happy accident" and on talking AI through the decades. Dav...

<a id="ref-37"></a>37. [Cyberpunk 2077 Blackwall, Rogue AI, And Demons Explained](https://www.thegamer.com/cyberpunk-2077-blackwall-netrunners-explained/) - The Blackwall was NetWatch's solution for dividing The Net into two parts, blocking the more dangero...

<a id="ref-38"></a>38. [Blackwall - Cyberpunk Wiki - Fandom](https://cyberpunk.fandom.com/wiki/Blackwall) - It is revealed by various sources that the Blackwall is not a firewall, but actually a powerful AI m...

<a id="ref-39"></a>39. [Artificial Intelligence - Cyberpunk Wiki - Fandom](https://cyberpunk.fandom.com/wiki/Artificial_Intelligence) - Alt Cunningham reveals that Blackwall AIs desperately want a physical "platform" with which they can...

<a id="ref-40"></a>40. [The Limits of Believability in Science Fiction](https://classicsofsciencefiction.com/2019/04/19/the-limits-of-believability-in-science-fiction/) - There are two kinds of believability in science fiction. The first is internal, does the story make ...

<a id="ref-41"></a>41. [Analysis: Portal and the Deconstruction of the Institution](https://www.gamedeveloper.com/game-platforms/analysis-i-portal-i-and-the-deconstruction-of-the-institution) - In this in-depth analysis, Daniel Johnson discusses games, language and sociology in Valve's Portal,...

<a id="ref-42"></a>42. [AGI（汎用性人工知能）とは？AIとの違いやAGI実現による ... - AIsmiley](https://aismiley.co.jp/ai_news/what-is-artificial-general-intelligence/) - AGIは、人間のように思考し、感情を理解する能力を持っている点が、従来型のAIとは一線を画しています。AGIは、思考の結果「楽しい」や「悲しい」といった ...

<a id="ref-43"></a>43. [Five Top Tips for Creating a Grounded Science Fiction World](https://www.writersandartists.co.uk/advice/five-top-tips-creating-grounded-science-fiction-world) - 1. What key details make up this grounded science fiction world? What marks yours apart? · 2. Create...

<a id="ref-44"></a>44. [Worldbuilding in Science Fiction, Foresight and Design](https://jfsdigital.org/articles-and-essays/vol-23-no-4-june-2019/worldbuilding-in-science-fiction-foresight-and-design/) - This paper will explore how science fiction is currently impacting real-world design, how worldbuild...
