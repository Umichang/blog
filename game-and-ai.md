# コンピューターゲームにおけるAIの歴史

## 概要

コンピューターゲームにおける人工知能（AI）の歴史は、ハードウェア制約の中でいかにリアルなキャラクター行動を実現するかという実装工学として始まり、やがて深層強化学習によってゲーム環境そのものが研究の場となり、2020年代にはLLMとの融合という新段階へと進化してきた。「制約が創造性を生む」という一貫したテーマが、半世紀にわたるゲームAI史の底流を流れている。

---- 

## 1. 黎明期：制約から生まれたAI (1970年代〜1980年代)

### パックマンと有限状態機械 (1980)

家庭用ゲームAIの最初期の代表格がナムコの『パックマン』（1980年）だ。ゴーストたちはそれぞれ「追跡（Blinky）」「待ち伏せ（Pinky）」「気まぐれ（Inky）」「おとぼけ（Clyde）」という異なる個性を持ち、**有限状態機械（FSM: Finite State Machine）**で実装されていた。FSMとは「現在の状態」と「遷移条件」をあらかじめ定義し、イベントに応じて状態を切り替えることでキャラクターの行動を表現する手法で、黎明期のゲームAIの大半がこれを採用した。「追う→逃げる→死ぬ→復活」という状態遷移はその典型例で、実装はシンプルながらプレイヤーには「AIが思考している」という感覚を与えた。[^1][^2]

パックマン以降、FSMはあらゆるジャンルに波及した。アドベンチャーゲームのNPCが昼夜のサイクルで行動を変える仕組み、RPGの敵が「待機→発見→攻撃→撤退」と状態を切り替えるパターンなど、1990年代末にいたるまでFSMはゲームAIの事実上の標準技術だった。しかし、ゲームの複雑化とともに「状態の数が膨大になり蜘蛛の巣のように複雑化する」という問題が露呈していくことになる。[^3]

### MSX2『メタルギア』と視野・聴覚のAI設計 (1987)

1987年7月13日、コナミはMSX2向けに小島秀夫監督作品『メタルギア』をリリースした。MSX2は同時表示できるスプライト数に厳しい制限があり、プレイヤーキャラクター・敵兵・銃弾を同時に画面に出すことさえ困難だった。この技術的制約に直面した小島監督は「敵との戦闘を極力避ける」というステルスゲームの概念を着想する。[^4]

ゲームデザインの観点から見ると、MSX2版メタルギアの敵NPCは「視野（field of vision）」という概念を導入した初期の事例だ。スクロールもバックグラウンドローディングも持てないMSX2の制約の中で、敵がプレイヤーを発見した瞬間に攻撃するシンプルなアルゴリズムが採用された。これは「ゲームの制約がAI設計を生み出した」という歴史的事例として特筆に値する。[^5]

続編の『メタルギア2 ソリッドスネーク』（MSX2, 1990年7月20日）では敵AIが大幅強化された。視界が直線から45度の扇形に進化し、「聴覚」という概念が加わって足音やノックを敵が感知するようになった。さらに「危険モード」「警戒モード」「通常モード」という状態遷移が整備され、現代のステルスゲームの原型となるAI設計が確立された。「制約から生まれたステルス」というアイデアが、状態遷移AIの成熟によって本格的なゲームプレイへと昇華した瞬間だった。[^6]

---- 

## 2. ルールベースAIの成熟：ドラゴンクエストIVの衝撃 (1990)

### AI戦闘システムの誕生

1990年2月11日、エニックスからファミコン向けに発売された『ドラゴンクエストIV 導かれし者たち』は、日本のゲーム史において「AI」という言葉を一般プレイヤーに普及させた作品として特筆される。シリーズ初のAI戦闘システムとして、第5章以降では主人公以外の仲間キャラクターが、プレイヤーが選んだ「作戦」に基づいてAIで自動行動する仕組みが採用された。第1章〜第4章まではNPCのみAIが担当するという段階的な導入がなされており、プレイヤーに少しずつAIの挙動を体験させる設計だった。[^7][^8][^9]

プレイヤーが選べる作戦はファミコン版オリジナルで「ガンガンいこうぜ」「みんながんばれ」「いろいろやろうぜ」「じゅもんをせつやく」「じゅもんつかうな」「いのちだいじに」の6種類だった。このシステムの全体構想を主導したのはシナリオ・ゲームデザイン担当の堀井雄二氏で、AIの実装プログラミングを担ったのは山名学氏だ。1988年6月に目処が立ち、完成まで約1年を要した。設計者たちが込めた思想は「最善の選択＝敵集団の恐怖度を削り取る、効率の最も高い行動」であり、当時のファミコン本体のメモリ容量わずか2KBの中でこのロジックを実装することは技術的快挙だった。[^10][^11][^12][^7]

### AIが「学習」した仕組み

技術的な詳細を見ると、AIは「敵の耐性」をレベル0〜3の4段階で学習する仕組みを持っていた（ランダムなターン経過で蓄積し、期待値7ターンでレベル0→3に到達）。一方で敵のHPや攻撃手段は初見から完全把握済みで、メラで倒せる敵をメラゾーマでオーバーキルするような非効率は取らない設計になっていた。また、ボス戦（逃走不可の戦闘）では「みんながんばれ」「ガンガンいこうぜ」のどちらを選んでも、裏では共通の「対ボス戦」作戦に自動切替するという実装も、後の解析で判明している。[^13]

実プレイでは、クリフトがボスにも「ザラキ（即死呪文）」を連発するなどの問題も話題となった。これはAIに例外ルールを追加するほどのメモリ余裕がなかったためで、**制約から生まれるAIの「愛嬌」**として今も語り継がれている。[^9]

---- 

## 3. 動的難易度調整の黎明期：ゲームがプレイヤーを「観察」し始めた (1986〜2000年代)

「プレイヤーの腕前を見て難易度を自動調整する」技術は、Dynamic Difficulty Adjustment（DDA）と呼ばれ、ビヘイビアツリーよりも早く、1980年代に萌芽を見せていた。

### ザナックのALC (1986)

コンパイルが1986年7月にリリースした『ザナック』は、MSX向けを皮切りにファミコンディスクシステム版（同年11月）、翌年には北米NES版もリリースされたシューティングゲームだ。タイトル画面に堂々と「**A.I.**」と記載し、「A.L.C.（Auto Level Control／自動難易度調整）」システムをゲームの主要なセールスポイントとして打ち出した。コンパイル社長の仁井谷正充氏自身が「多分、世界で初めて『AI』という言葉を使ったゲームだと思います」と語っており、ゲームAIの名称的な起点とも言える作品だ。[^14][^15][^16]

ALCの仕組みは現在のビューで見てもユニークだ。プレイヤーが**弾を高速連射する**・**偵察機（ゾルバグ）を見逃す**・**特殊アイテムを取得する**といった行動を判断し、それに応じて敵の攻撃パターンや出現数がリアルタイムで劇的に変化する。難易度は画面右上に16進数で常時表示されており、プレイヤーが自分でALC値を確認しながらゲームを進めることができた。一方で「うまくないプレイヤーほど難易度が上がってしまう傾向がある」という逆説的な問題も内包していた。偵察機を逃したり弾を外したりするのが初心者の典型的なミスであるため、意図せずALC値が上がるケースがあったのだ。[^17][^18][^16]

### スーパーアレスタの難易度調整 (1992)

コンパイルのSTGシリーズ後継作として1992年にSFCで発売された『スーパーアレスタ』もまた、難易度自動調整機能を搭載していた。広告でも「AIを搭載した難易度自動調節」を前面に押し出しており、ザナックで確立したコンパイルのDDAの哲学がSFCへ受け継がれた形だ。ただし詳細な実装の一次資料は現時点では確認できておらず、ALCのような数値表示が維持されたかどうかは不明である。[^19][^20]

### バイオハザード4とLeft 4 Dead：DDAの成熟 (2005〜2008)

三上真司監督の『バイオハザード4』（2005年）では「Difficulty Scale」という非公開システム（1〜10段階の評価値）が内部で稼働しており、プレイヤーの死亡回数・クリティカル成功率などに基づいて敵の行動と耐久力をリアルタイムに調整していた。このシステムは公式には非公開とされており、プレイヤーが意識しないところで「ちょうど良い難しさ」を作り出す設計思想だった。翌年2006年にリリースされた同社の『ゴッドハンド』（Capcom）では逆に、難易度メーターを画面上にリアルタイム表示し、プレイヤーが難易度の変化を直視する設計を採用した。「見えないDDA」と「見えるDDA」という対照的な設計哲学が相次いで登場したことは興味深い。[^21][^22]

2008年のValve『Left 4 Dead』は、DDAの概念を「**メタAI**」の形で結実させた。「AIディレクター」は4人の生存者それぞれの「感情強度（Intensity）」を常時監視し、ゾンビの出現数・配置・アイテムの場所・BGMまでを動的に制御する。「ビルドアップ→ピーク→リラックス」のリズムを繰り返すことで、毎回異なる体験を生み出しながらも、つねに「絶妙な難しさ」をプレイヤーに与えることに成功した。AIディレクターは目に見えない存在でありながら、プレイ体験全体を演出する黒幕として機能した。[^23][^24][^25]

---- 

## 4. FSMからビヘイビアツリー・GOAPへ：NPCAIの設計革命 (2000年代)

### ビヘイビアツリーの普及 (Halo 2, 2004)

ゲームの複雑化とともに、FSMだけでは「状態の数が膨大になり蜘蛛の巣のように複雑化する」という限界が露呈した。そこでゲームAIに急速に浸透したのが**ビヘイビアツリー（Behavior Tree）**だ。ロボティクス分野で培われてきたこの手法を商用ゲームに本格的に実装・普及させたのが、BungieのDamian Isla氏だ。氏は『Halo 2』（2004年）のAI設計にビヘイビアツリーを導入し、2005年のGDC講演「Handling Complexity in the Halo 2 AI」でその知見を業界に広く共有した。ツリー状の非循環グラフで行動の優先順位と条件分岐を管理するこの手法は、拡張性と可読性の高さから業界標準となった。現在のゲームのキャラクターAIの約7割がビヘイビアツリーで作られているとも言われ、Unreal EngineやUnityの標準機能として搭載されている。なお、FSMとビヘイビアツリーは対立するものではなく、現代の実装では「上層でFSMが状態管理を行い、下層のビヘイビアツリーが具体的な挙動を担う」という組み合わせも一般的だ。[^26][^2][^27][^3]

### GOAP：F.E.A.R.の目標指向型AI (2005)

ビヘイビアツリーと並行して生まれたもう一つの革新がGOAP（Goal-Oriented Action Planning／ゴール指向型アクションプランニング）だ。当時Monolith ProductionsのAIリードだったJeff Orkin氏が『F.E.A.R.』（2005年）に導入し、敵兵士が「ゴール（目標）から逆算して行動計画を立てる」という人間的な思考プロセスをリアルタイムの意思決定（1/60秒単位）で実現した。なお、Orkin氏はF.E.A.R.の開発を終えた2005年以降にMIT Media Labの博士課程に進み、2013年に博士号を取得している。[^28][^26]

GOAPの特徴は、敵NPCがただ「プレイヤーを攻撃する」のではなく、掩蔽物を利用したカバー取得、火力制圧中の仲間との連携、死角からの迂回攻撃、弾切れ時の戦術変更といった複数のアクションを状況に応じて動的に組み合わせることができる点だ。F.E.A.R.のFSMが「わずか3状態」でGOAPと組み合わされていたことは、「GOAPがFSMを置き換えた」のではなく「GOAPがFSMを補完・拡張した」という歴史的経緯を示している。後にMiddle-earth: Shadow of MordorやTomb Raiderといった作品もGOAPを採用しており、ゲームAIの重要な技術系譜として定着している。[^29][^30]

---- 

## 5. 深層強化学習とコンピューターゲーム (2013〜現在)

ボードゲームではなく、**コンピューターゲームそのもの**を対象とした深層強化学習（Deep Reinforcement Learning）の研究は、2013年以降に急速に進展した。

### DeepMind DQNとAtariゲーム (2013〜2015)

2013年、DeepMindが発表した「DQN（Deep Q-Network）」論文は、Atari 2600の7タイトル（ブロック崩し、ピンポンなど）をピクセル画像のみから自律的に学習し、うち6タイトルで先行手法を超えるスコアを達成し、3タイトルで人間のスコアを上回ることを示した。Q学習（行動の価値を評価する強化学習手法）と深層CNN（畳み込みニューラルネットワーク）を組み合わせた手法で、ゲームのルールを一切教えずとも、報酬（スコア）のみを手がかりに戦略を習得するという点が革命的だった。

2015年にはNature誌への掲載版論文（Human-level control through deep reinforcement learning）として拡張され、49タイトルでテストを実施。先行RL手法を43タイトルで上回り、29タイトルで人間スコアの75%以上を達成するという大幅に強化された結果が示された。この一連のDQN研究が現代の深層強化学習ブームの起点となった。[^31][^32][^33][^34][^35]

### AlphaStarとStarCraft II (2019)

DeepMindのAlphaStarは、ブリザードのリアルタイムストラテジーゲーム「StarCraft II」に対して、2019年1月の公開発表イベントで世界トッププレイヤーを相手に通算10-1のスコアを記録し衝撃を与えた。その後さらに訓練を重ねた改良版AlphaStarは、2019年10月に公式ゲームサーバーBattle.netで匿名でプレイし、人間プレイヤー上位0.2%にランクインするグランドマスターレベルを達成した。[^36][^37]

注目すべきは「より人間らしい条件での制約設定」だ。以前のバージョンはゲームデータを直接読み込んでいたが、改良版はカメラを通じて画面を見る形式に制限され、行動頻度にも人間と同等の上限が課された。これにより「人間と全く同じ条件下でも勝てる」ことが証明された。AlphaStarは教師あり学習（人間の棋譜模倣）と強化学習によるセルフプレイ、マルチエージェント学習を組み合わせる手法を採用しており、ゲーム環境は汎用的な機械学習研究のベンチマークとして機能した。[^38][^36]

### OpenAI FiveとDota 2 (2018〜2019)

同時期にOpenAIもDota 2を対象とした「OpenAI Five」を開発した。2018年6月には制限ルール下でアマチュア〜セミプロレベルのチームへの5対5チーム戦勝利を達成し、2019年4月にはDota 2世界チャンピオンチーム「Team OG」を2-0で破った。OpenAI Fiveは訓練初期には1日に180年分相当のゲームプレイを学習しており（最終段階では1日250年分超に拡大）、256台のGPUと12万8000個のCPUコアを投入した大規模なインフラで訓練されていた。StarCraft IIとDota 2という二大eスポーツ両方でAIが世界チャンピオンを超えたことで、2019年は深層強化学習の「頂点到達の年」として記憶されている。[^39][^40][^41]

### Gran Turismo Sophy (2022)

コンピューターゲームを舞台にした深層強化学習の成果として、2022年にポリフォニー・デジタルとSony AIが発表した「Gran Turismo Sophy（GTソフィー）」も特筆に値する。1000台以上のPS4を学習環境に投入し、累計走行距離30万km相当の学習を経て、グランツーリスモの世界トップドライバーと対等に競争できるAIへと成長した。[^42][^43]

GTソフィーが他のゲームAI研究と異なるのは、「速さ」だけでなく「フェア精神」も学習対象としたことだ。初期のSophyは他のレーサーにぶつかることも辞さない荒れた走りだったが、報酬設計に「レースとしてのフェアさ」を加味することで、人間と協調し参加者が「楽しい」と感じられるAIへと変化した。これはゲームAIが「勝利の最大化」だけでなく「体験の共創」を目標に設計されうることを示す事例だ。[^43]

---- 

## 6. LLM×ゲームという新潮流 (2023〜現在)

### ゲームAIが直面していた課題

2015年以降のオープンワールド化の波により、ビヘイビアツリーは肥大化の限界を迎えつつあった。また従来のNPCは「決められたセリフをループする存在」に過ぎず、プレイヤーとの本質的な会話や関係構築は不可能だった。この問題を解決する可能性として注目を集めているのが、大規模言語モデル（LLM）のゲームへの統合である。[^26]

### NVIDIA ACE (2023〜)

NVIDIAは2023年、NPCに知性をもたらす「NVIDIA ACE（Avatar Cloud Engine）for Games」を発表した。音声認識（NVIDIA Riva）・LLMによる対話生成（NeMo）・リアルタイム表情アニメーション（Audio2Face）を組み合わせ、プレイヤーが自然言語でNPCと会話できる基盤を提供する。2025年CESではさらに「自律型ゲームキャラクター」への拡張が発表され、PUBG向けAIチームメイト「PUBG Ally」（Mistral-Nemo-Minitron-8Bモデル使用）、NARAKA: BLADEPOINT MobileへのACE搭載AIチームメイト（2025年3月リリース）が具体化した。GDC 2025で発表された殺人ミステリーゲーム「Dead Meat」では、容疑者NPCとの自由対話をクラウドではなくオンデバイスのSLM（小規模言語モデル）で実現する技術も披露されている。[^44][^45][^46]

### Ubisoft NEO NPCとTeammates (2024〜2025)

Ubisoftのパリスタジオは2024年3月、GDCにて「NEO NPC」プロジェクトを発表した。Inworld AIのLLMとNVIDIA Audio2Faceを活用し、プレイヤーの音声にリアルタイムで反応して即興対話を行うNPCを開発中だ。NPCには独自の性格・背景・目標・感情が設定され、プレイヤーとの対話がゲームプレイの進行に直接影響する仕組みを目指している。[^47][^48][^49]

2025年11月にはさらに進化した「Teammates」プロジェクトが発表された。FPS環境でAIチームメイト「Pablo」と「Sofia」がプレイヤーの音声コマンドに反応して射撃・援護・戦術議論をリアルタイムで行うという体験を実現し、GoogleのGeminiと自社ミドルウェアを組み合わせた約80人のチームが開発した。Ubisoftは「生成AIがゲームに与えるインパクトは3Dへの移行に匹敵する」とその重要性を強調している。[^50][^51]

### 進行中の課題と展望

LLMとゲームの融合はまだ実験段階だ。Ubisoftのナラティブディレクターは「LLMが物語制作を楽にするという誤解がある。実際にはキャラクターの設定資料（バイブル）が丸ごとプレイヤーにさらされるリスクが生じ、ガードレールの設計が複雑になる」と指摘する。技術面ではクラウドベースLLMの遅延・コスト・オフライン環境での制限という問題を、SLMのオンデバイス動作で解決しようとする動きが進んでいる。[^52][^46][^53]

FSMから始まり、DDA・メタAI・ビヘイビアツリー・GOAP・深層強化学習、そしてLLMへ。ゲームAIの歴史は技術的制約を創造性に変え続けてきた。1987年のMSX2の画面制限がステルスゲームを生み、2KBのファミコンが「AI戦闘」という概念を世に送り出したように、制約と工夫の積み重ねの延長線上に、今日のLLM統合型ゲームキャラクターが立っている。

---

## References

1. [AIゲームとは何か知りたい方必見！仕組みをわかりやすく紹介][1] - 有限オートマトン（FSM）, あらかじめ定義した状態を条件に応じて切り替える, 敵キャラが「待機→発見→追跡→攻撃」と状態遷移する ; ビヘイビアツリー, 行動を ...

2. [Halo2 におけるHFSM(階層型有限状態マシン) - t-pot][2] - ゲームAIでは、意思決定に状態を使用する。 イベントによって内部状態が変化 例 パックマンの敵AIでは、「追う」、「逃げる」、「死ぬ」、「復活」の状態を遷移 （実際 ...

3. [AI最前線の現場から【スクウェア・エニックス】ゲーム ...][3] - ビヘイビア・ツリーは「Halo2」（Bungie, 2004）で新しく開発された技術で、現在ではゲーム産業で最も使用されている手法です。現在のゲームのキャラクター ...

4. [メタルギアシリーズ - Wikipedia][4] - 小島秀夫監督作品 · メタルギア （1987年7月13日・MSX2） · メタルギア2 ソリッドスネーク （1990年7月20日・MSX2） · メタルギアソリッド （1998年9月3日・PS / 2...

5. [[PDF] T H E C O M P L E T E O F F I C I ...](https://www.piggyback.com/us/wp-content/uploads/sites/6/2020/04/MGSV\_UE\_003-055\_150903\_ML.pdf) - Metal Gear made its first appearance on the MSX2 hardware 28 years ago. That was the era of the "sho...

6. [[Metal Gear Solid] The Birth and Evolution of Stealth Action - YouTube](https://www.youtube.com/watch?v=hBSz4MaxV7I) - 元々、メタルギアはアクションゲームとして作っていたのですが、msx2の処理能力では弾を1度に4つ以上表示できなかったので、あえて弾を撃たない、撃て ...

7. [ドラクエIVからChatGPTまで：AIの歴史をスライム並みにやさしく ...][5] - 1990年、ファミコン用ソフト『ドラゴンクエストIV』において、「AI戦闘システム」という新しい仕組みが登場しました。中でも「ガンガンいこうぜ」 ...

8. [ドラゴンクエストIV 導かれし者たち - Wikipedia][6] - 戦闘時のAIシステムに関しては、最大8人のキャラクターが混在してもスムーズに行えるといった意見や、戦闘シーンが快適であったなど肯定的な意見が散見された。

9. [「ドラクエ4」35周年！ 延々とザラキを唱えるクリフトにぐぬぬ。AI ...][7] - 第1章～4章までは手動でコマンド入力を行ない、キャラクターの行動を指示するバトルなのだが（NPCはAI）、第5章からは主人公を除く味方キャラクターたちは、 ...

10. [ドラクエIVからChatGPTまで：AIの歴史をスライム並みにやさしく ...][8] - 『ドラゴンクエストIV』のAI戦闘システム、覚えてますか？ 1990年、ファミコン版で初登場したこのシステム ...

11. [[DQ4] The reason for introducing the AI ​​system and ... - YouTube](https://www.youtube.com/watch?v=yD537GTjH5s) - [DQ4] The reason for introducing the AI ​​system and Clift's verification [Part 2 of 128 - Game N......

12. [【解析】ドラクエ4のAI戦闘 - med A - はてなブログ][9] - 今から30年以上前の話となります。 人工知能をテーマとして取り上げ. そのコンセプトをゲームに組み込んだことが. 当時、話題になりました。

13. [ドラクエ4のAI戦闘と作戦、完全に理解した｜frenchbread - note][10] - 30年ぶりにファミコン版ドラクエ4をプレイしたので、AI戦闘の仕様についてまとめます。ソースは主に下の記事と自分でプレイした検証結果です。

14. [仁井谷正充氏に訊く『ザナック』にAIが導入された理由][11] - 『ザナック』とは、どのようなゲームだったのか？「多分、世界で初めて『AI』という言葉を使ったゲームだと思います.

15. [ザナック (シューティングゲーム)とは？ わかりやすく解説][12] - A.L.C.（Auto Level Control/自動難易度調整）というシステムを採用しており、プレイする都度に、またプレイヤーの技量次第で展開と難易度が変化するようになっている。MSX版 ...

16. [「ゲームニクス」で考えるゲームの魅力 第三十八回 ゲームAI][13] - そこで、例えば敵キャラの思考レベルやパラメーターを、最初は低めに設定して段階的に上げていく、あるいはプレイヤーの実力を自動で見定めて難易度を調整 ...

17. [『ZANAC』の真髄：自動難易度調整 - YouTube][14] - 『ZANAC』の真髄：自動難易度調整.

18. [『ザナック』快適な高速スクロールと人工知能による自動難易度 ...][15] - ちなみにALCの値は特定の敵を見逃してしまう、特殊なアイテムを使用するなどの行動により大きく上昇しましたが、プレイヤーが弾を連射する事でも徐々に ...

19. [COMPILE - SMS Power!][16] - メインショットと8種類のサブウエポンを駆使して12ステージ（だったかな）を戦います。 このゲーム、当時では珍しくウリの一つでもあった難易度自動調節（AI）のゲームで、

20. [COMPILE][17] - メインショットと8種類のサブウエポンを駆使して12ステージを戦います。 このゲームのウリの一つでもあった、当時では珍しい難易度自動調節機能（広告などではAIって呼んで ...

21. [Game Changers: Dynamic Difficulty - Game Developer][18] - A breakdown of some different approaches to dynamic difficulty adjustment, including one neat exampl...

22. [Dynamic game difficulty balancing - Wikipedia][19] - The aim of dynamic difficulty balancing is to maintain the player's interest throughout the game by ...

23. [【UE4】L4DのAIDirectorを真似てメタAIを作ってみる その1][20] - Left 4 Deadシリーズ（L4D）ではAIDirector · ルールに基づいた敵の出現（スポーニング） · ドラマチックなペースの生成（ペーシング） · 障害物の配置（ルート作成）

24. [Counter-Strike」から「Left 4 Dead」へ 協力プレイ、リプレイ性][21] - AIディレクターは、ご存じのとおり、本作のゲーム展開を制御する人工知能だ。これについて、巷では「毎回異なるシチュエーションを演出してくれる」こと ...

25. [バルブのLeft 4 DeadのAIディレクターとは？][22] - AIディレクターは、プレイヤーのストレスレベルやプレイの強度を測定し、ゲームワールドを変更してプレイヤーを刺激します。ディレクターは、ゾンビの出現 ...

26. [【記事更新】私のブックマーク「ディジタルゲームの人工知能の ...][23] - ... ゲーム産業にもたらしたDamian Isla氏の仕事と，「ゴール指向型アクションプランニング」（GOAP：Goal-Oriented Action Planning）を導入した Jef Ork...

27. [【ゲーム開発】プレイヤーAIを制御する方法の紹介｜トイロジック][24] - FSMとBTの組み合わせは、AIの制御を柔軟かつ効果的に行うために適しています。 具体例を挙げて説明します.

28. [GOAP（ゴール指向プランニング） - hasht's notes - はてなブログ][25] - ... GOAP（ゴール指向プランニング、Goal-Oriented Action Planning）と呼ばれるが、起源は「F.E.A.R.」にあるようだ。 元々人工知能分野でプランニング ...

29. [FEAR基于GOAP的AI系统GDC分享（中英双语）][26]

30. [Gamasutra: Building the AI of F.E.A.R. with Goal Oriented Action Planning][27]

31. [Playing Atari with Deep Reinforcement Learning(2013) - Blanket][28] - 概要. 深層強化学習をAtari2600の7つのゲームに応用し、うち6つについて先行手法の性能を超えたDeep Q-Networks(DQN)を提案した論文である。

32. [【5分講義・深層強化学習#1】深層強化学習そしてDQN手法][29] - 深層強化学習の圧倒的に代表的な手法は DeepMind社が開発したDQN（Deep Q-Network）です。DQNは、従来の強化学習モデルにおけるQ学習を基本的な思想 ...

33. [【強化学習】表形式Q学習とDQNの違い - Qiita][30] - DQNは、Q学習の考え方を拡張し、Q値をニューラルネットワークで近似する手法です。2013年にDeepMind社の研究チームによって発表され、2015年には「Nature ...

34. [これさえ読めばすぐに理解できる強化学習の導入と実践 - DeepAge][31] - DeepMind社が有名になったのは、2013年にAtariのゲームを攻略する論文を公開してからです。この論文では、Atariの6ゲームで人間の能力を上回ることが示 ...

35. [DQN | AI主要論文 | hatohato.jp][32] - DQN（Deep Q-Network）は、CNNを用いてQ関数を近似し、生の画像入力からAtariゲームをプレイする深層強化学習手法である。Experience ReplayとTarget ...

36. [AlphaStar : マルチエージェント強化学習を使用したStarCraft IIの ...][33] - 「AlphaStar」は、「ニューラルネットワーク」「強化学習によるセルフプレイ」「マルチエージェント学習」「模倣学習」などの汎用機械学習手法を使用して ...

37. [プロゲーマーに大勝したAI「AlphaStar」が「スタークラフト2」で ...][34] - しかし、今回DeepMindが発表した新しいAlphaStarは、マルチエージェント強化学習 ... AlphaStarの3つのエージェントはすべてグランドマスターリーグに昇格。

38. [AlphaStar: Mastering the real-time strategy game StarCraft II][35] - AlphaStar's behaviour is generated by a deep neural network that receives input data from the raw ga...

39. [How StarCraft and Dota were stepping stones for Reinforcement ...][36] - In 2019, DeepMind's AlphaStar achieved grandmaster status in StarCraft II, decisively beating some o...

40. [Dota 2で人間チームに勝利したOpenAIの人工知能「OpenAI Five ...][37] - Dota 2で人間チームに勝利したOpenAIの人工知能「OpenAI Five」が今度は著名プレイヤーチームと対戦することを発表.

41. [OpenAIの人工知能「OpenAI Five」がDota 2の5対5バトルで人間 ...][38] - OpenAI Fiveは180日間毎日Dota 2をプレイし続けた ...

42. [深層強化学習によって進化したレーシングAIエージェント「Gran ...][39] - このAIエージェントを、実時間での 判断や意思決定が絶えず求められるリアルなレースシミュレーションに導入することで、機械学習を次のレベルへと ...

43. [1000台超のPS4で強化学習。ソニーのAI「Sophy」は何がすごい ...][40] - レースゲームAIとSophyとの大きな違いと言っていい。 グランツーリスモを開発する、ポリフォニー・デジタル 代表の山内一典氏は、「グランツーリスモのAI ...

44. [NVIDIA Redefines Game AI With ACE Autonomous Game ...][41] - NVIDIA is now expanding ACE from conversational NPCs to autonomous game characters that use AI to pe...

45. [NVIDIA、NPCに命を吹き込む新たな生成AIサービスを発表][42] - 「ACE for Games」は、AIを活用した自然言語によるやり取りを通じてNPCに知性をもたらすサービスだ。

46. [Bringing AI NPCs to Life On-Device With NVIDIA ACE ...][43] - Watch a replay of our GDC 2025 Session, presented by Meaning Machine. Dead Meat is a murder mystery ...

47. [How Ubisoft's New Generative AI Prototype Changes the Narrative ...][44] - Project NEO NPC is only a prototype, and there's still a way to go before it can be implemented in a...

48. [生成AIで自然に対話できるNPCを作る技術「NEO NPC」をUbisoftが ...][45] - NEO NPCは，ゲーム用途向けAI対話生成エンジンを開発するInworldの大規模言語モデル（LLM）や，NVIDIAの音声および表情合成技術「Audio2Face」を利用して， ...

49. [プレイヤーがキャラと協力して強盗を計画もーーUbisoft、生成 AI を ...][46] - Ubisoft の Gen AI を搭載した Neo NPC が、会話を創発的でダイナミックなゲームプレイに変える。

50. [Ubisoft debuts playable generative AI experiment - Game Developer][47] - "In the initial prototype from 2024, Neo NPCs displayed novel cognitive and natural language abiliti...

51. [ユービーアイ、NPCへの音声指示や会話ができる生成AI研究 ...][48] - なお2024年3月には「NEO NPC」が同社より発表されていました。「NEO NPC」はプレイヤーと対話が行えるNPC技術と説明されていました。

52. [Ubisoft's 'Teammates' Demo & Their New Generative AI Push | 26/11 ...][49] - Ubisoft lays out their new generative AI technology stack.

53. [NVIDIA Develops ACE AI Models for Autonomous Game ...][50] - NVIDIA Develops ACE AI Models for Autonomous Game Characters; PUBG, inZOI, NARAKA to Utilize ACE in ...

[1]:	https://www.blooktecpc-support.com/useful/ai_game/
[2]:	https://t-pot.com/program/140_GameAISeminar4/index.html
[3]:	https://thinkit.co.jp/article/10012
[4]:	https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%BF%E3%83%AB%E3%82%AE%E3%82%A2%E3%82%B7%E3%83%AA%E3%83%BC%E3%82%BA
[5]:	https://kantanstart.com/entry/dragonquest4-ai-history
[6]:	https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%A9%E3%82%B4%E3%83%B3%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88IV_%E5%B0%8E%E3%81%8B%E3%82%8C%E3%81%97%E8%80%85%E3%81%9F%E3%81%A1
[7]:	https://game.watch.impress.co.jp/docs/kikaku/1660147.html
[8]:	https://kantanstart.com/entry/dragonquest4-ai-30years
[9]:	https://774buya.hatenablog.com/entry/2023/12/13/083000
[10]:	https://note.com/frenchbread/n/n7bf90335f5eb
[11]:	https://morikatron.ai/2020/05/gameai_history_02/
[12]:	https://www.weblio.jp/content/%E3%82%B6%E3%83%8A%E3%83%83%E3%82%AF+(%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%82%B2%E3%83%BC%E3%83%A0)
[13]:	https://igcc.jp/game-nics-38/
[14]:	https://www.youtube.com/watch?v=9gYzqDI2rWA
[15]:	https://towerofclassicgame.com/zanac_remake
[16]:	https://www.smspower.org/sites/Momochi-20030921/untiku/u_comp.htm
[17]:	https://www.higenekodo.jp/untiku/u_comp.htm
[18]:	https://www.gamedeveloper.com/design/game-changers-dynamic-difficulty
[19]:	https://en.wikipedia.org/wiki/Dynamic_game_difficulty_balancing
[20]:	https://qiita.com/Dv7Pavilion/items/cd263f844a56cb168180
[21]:	https://game.watch.impress.co.jp/docs/news/080051.html
[22]:	https://www.toolify.ai/ja/ai-news-jp/left-4-deadai-1513323
[23]:	https://www.ai-gakkai.or.jp/resource/my-bookmark/my-bookmark_vol37-no6/
[24]:	https://note.com/toylogic/n/nf6d1a676f80e
[25]:	https://hasht.hatenablog.com/entry/2019/05/24/200613
[26]:	https://www.lfzxb.top/gdc-sharing-of-ai-system-based-on-goap-in-fear-simple-cn/
[27]:	https://www.reddit.com/r/gamedev/comments/gfppla/gamasutra_building_the_ai_of_fear_with_goal/
[28]:	https://ryotaro.dev/posts/playing_atari_with_deep_reinforcement_learning/
[29]:	https://gri.jp/media/entry/733
[30]:	https://qiita.com/yonaka15/items/517592497d8c921c02ae
[31]:	https://deepage.net/machine_learning/2017/08/10/reinforcement-learning.html
[32]:	https://hatohato.jp/ai/papers/detail/dqn.php
[33]:	https://note.com/npaka/n/nb719e603b4aa
[34]:	https://gigazine.net/news/20191031-alphastar-grandmaster-starcraft-ii/
[35]:	https://deepmind.google/blog/alphastar-mastering-the-real-time-strategy-game-starcraft-ii/
[36]:	https://www.warburg.ai/blog/how-starcraft-is-informing-financial-ai
[37]:	https://gigazine.net/news/20180719-openai-five-benchmark/
[38]:	https://gigazine.net/news/20180626-openai-five-dota-2-defeating/
[39]:	https://www.gran-turismo.com/jp/news/00_1704246.html
[40]:	https://www.businessinsider.jp/article/250516/
[41]:	https://www.nvidia.com/en-us/geforce/news/nvidia-ace-autonomous-ai-companions-pubg-naraka-bladepoint/
[42]:	https://news.denfaminicogamer.jp/news/230530f
[43]:	https://www.youtube.com/watch?v=F_Tpfn1LxEA
[44]:	https://news.ubisoft.com/en-us/article/5qXdxhshJBXoanFZApdG3L/how-ubisofts-new-generative-ai-prototype-changes-the-narrative-for-npcs
[45]:	https://www.4gamer.net/games/999/G999902/20240320007/
[46]:	https://thebridge.jp/2024/03/ubisoft-neo-npcs-nvidia-inworldai-gdc
[47]:	https://www.gamedeveloper.com/business/ubisoft-s-first-playable-generative-ai-experience-is-an-r-d-experiment-called-teammates-
[48]:	https://www.gamespark.jp/article/2025/11/22/159780.html
[49]:	https://www.aiandgames.com/p/ubisofts-teammates-demo-and-their
[50]:	https://www.reddit.com/r/pcgaming/comments/1i9sq34/nvidia_develops_ace_ai_models_for_autonomous_game/