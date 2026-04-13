# コンピューターゲームにおけるAIの歴史

## 概要

コンピューターゲームにおける人工知能（AI）の歴史は、「チェスや囲碁を解く知能」と「ゲーム内NPCを動かす知能」という二つの文脈で並行して発展してきた。前者は学術的な問題解決AIの挑戦として、後者は限られたハードウェア資源の中でどれだけリアルなキャラクター行動を実現するかという実装工学として進化した。そして2020年代、大規模言語モデル（LLM）の台頭によって、この二つの流れが融合しつつある。

---- 

## 1. 黎明期：制約こそが創造性を生んだ (1970年代〜1980年代)

### パックマンとルールベースAI (1980)

家庭用ゲームAIの最初期の代表格がナムコの『パックマン』（1980年）だ。ゴーストたちはそれぞれ「追跡」「待ち伏せ」「迂回」「気まぐれ」という異なる個性を持ち、有限状態機械（FSM: Finite State Machine）で実装されていた。これはプレイヤーから見ると「AIが考えている」という印象を与えるが、実際には各ゴーストの移動先タイルを決めるシンプルな条件分岐の集合体である。

FSMは「現在の状態」と「遷移条件」をあらかじめ定義することで、キャラクターの行動を表現する。「待機→発見→追跡→攻撃」といったパターンが典型例であり、黎明期のゲームAIの大半がこの手法を採用していた。[1](#ref-1)

### MSX2『メタルギア』と視野・聴覚のAI設計 (1987)

1987年7月13日、コナミはMSX2向けに小島秀夫監督作品『メタルギア』をリリースした。MSX2は同時表示できるスプライト数に厳しい制限があり、プレイヤーキャラクター・敵兵・銃弾を同時に画面に出すことさえ困難だった。この技術的制約に直面した小島監督は「敵との戦闘を極力避ける」というステルスゲームの概念を着想する。[2](#ref-2)

ゲームデザインの観点から見ると、MSX2版メタルギアの敵NPCは「視野（field of vision）」という概念を導入した初期の事例だ。公式資料によれば、スクロールもバックグラウンドローディングも持てないMSX2の制約の中で、敵がプレイヤーを発見した瞬間に攻撃するシンプルなアルゴリズムが採用された。これは「ゲームの制約がAI設計を生み出した」という歴史的事例として特筆に値する。[3](#ref-3)

続編の『メタルギア2 ソリッドスネーク』（MSX2, 1990年）では敵AIが大幅強化された。まず視界が直線から45度の扇形に進化し、「聴覚」という概念が加わって足音やノックを敵が感知するようになった。さらに「危険モード」「警戒モード」「通常モード」という状態遷移が整備され、現代のステルスゲームの原型となるAI設計が確立された。コナミの公式サイトでも「敵兵がスネークの足音を感知し、壁ノックで引きつける聴覚設計」を第二作の特徴として挙げている。[4](#ref-4)[5](#ref-5)

### 日本ファルコム『イース』の背景グラフィック技法 (1987)

日本ファルコムが1987年6月21日にPC-8801mkIISR向けに発売した『イース』は、その美麗な背景グラフィックで当時のユーザーを驚かせた。特に画面を彩る樹木や森の背景は、ゲームデザイナーがひとつづつおいたものではなく、**乱数と再帰的アルゴリズムの組み合わせ**によって事前生成（プリレンダリング）したとされる。1993年のコンピュータ専門誌「Oh!X」には「乱数と再帰的な処理の組み合わせによって記述した木の例」というグラフィック生成の記事が掲載されており、当時のPC-88時代における手続き型グラフィック生成の技術的潮流が確認できる。[6](#ref-6)[7](#ref-7)

これはいわゆる「プロシージャル生成（Procedural Generation）」の一形態であり、現代の生成AIとは根本的に異なるものの、「コンピュータがアルゴリズムによってコンテンツを自動生成する」という思想の先駆として位置づけられる。

---- 

## 2. ルールベースAIの成熟：ドラゴンクエストIVの衝撃 (1990)

### AI戦闘システムの誕生

1990年2月11日、エニックスからファミコン向けに発売された『ドラゴンクエストIV 導かれし者たち』は、日本のゲーム史において「AI」という言葉を一般プレイヤーに普及させた作品として特筆される。[8](#ref-8)[9](#ref-9)

シリーズ初のAI戦闘システムとして、第5章以降では主人公以外の仲間キャラクターが、プレイヤーが選んだ「作戦」に基づいてAIで自動行動する仕組みが採用された。第1章〜第4章まではプレイヤー自身がコマンドを入力するが、NPCのみAIが担当するという段階的な導入がなされていた。[9](#ref-9)[10](#ref-10)

### 作戦システムの設計思想

プレイヤーが選べる作戦は「ガンガンいこうぜ」「いのちだいじに」「じゅもんつかうな」「みんながんばれ」の4種類。このシステムの設計を提案したのは堀井雄二氏で、1988年6月に目処が立ったのち、完成まで約1年を要した。[11](#ref-11)[12](#ref-12)

技術的な詳細を見ると、AIは「敵の耐性」をレベル0〜3の4段階で**学習**する仕組みを持っていた（ランダムなターン経過で蓄積、期待値7ターンでレベル0→3に到達）。一方で、敵のHPや防御力、攻撃手段は最初から完全把握済みで、メラで倒せる敵をメラゾーマでオーバーキルするような非効率な行動は取らなかった。[13](#ref-13)

設計者が込めた思想は「最善の選択＝敵集団の恐怖度を削り取る、効率の最も高い行動」だったという。本体RAMの少なさとカートリッジ容量の制約の中で、これだけの判断ロジックを実装したことは技術的快挙だった。[14](#ref-14)[8](#ref-8)

ただし実プレイでは、クリフトがボスにも「ザラキ（即死呪文）」を使い続けるなどの問題も話題になった。これはAIに例外ルールを追加するほどのメモリ余裕が無かったためで、**制約から生まれるAIの「愛嬌」**として語り継がれている。また、ボス戦（逃走不可の戦闘）では「みんながんばれ」「ガンガンいこうぜ」のどちらを選んでも、裏では共通の「対ボス戦」作戦に切り替わっていたという実装も後に解析で判明している。[10](#ref-10)[13](#ref-13)

---- 

## 3. FSMからビヘイビアツリーへ：NPCAIの設計革命 (2000年代)

ゲームの複雑化とともに、FSMだけでは「状態の数が膨大になり蜘蛛の巣のように複雑化する」という限界が露呈してきた。そこで登場したのが**ビヘイビアツリー（Behavior Tree）**だ。[15](#ref-15)

ビヘイビアツリーはBungie社の開発者によって『Halo 2』（2004年）のAI設計として考案・実装された。ツリー状の非循環グラフで行動の優先順位と条件分岐を管理するこの手法は、拡張性と可読性の高さから急速に業界標準となり、大規模ゲームやモバイルゲームの7割超で、少なくとも1つのビヘイビアツリーが使われている[16](#ref-16)[15](#ref-15)

ビヘイビアツリーは現在も主要ゲームエンジンやミドルウェアで広くサポートされていり、ゲームAI開発のデファクトスタンダードである。一方、2015年以降のオープンワールドゲームの飛躍的なスケール拡大に伴い、ビヘイビアツリー自体が肥大化し「人間が手動で意思決定を記述する方法の限界」も見え始めている。[16](#ref-16)

---- 

## 4. FPSにおけるプレイヤー接待とメタAI (2000年代〜2010年代)

### 動的難易度調整（DDA）の系譜

「プレイヤーの腕前を見て難易度を自動調整する」技術は、Dynamic Difficulty Adjustment（DDA）と呼ばれ、意外に長い歴史を持つ。最古の事例の一つはMidwayのアーケードゲーム『Gun Fight』（1975年）で、撃たれたプレイヤー側にオブジェクト（サボテン）が追加されて有利にする仕組みがあった。[17](#ref-17)

1986年のコンパイル作品『ザナック』では、プレイヤーのスキルレベル・射撃速度・防御状況に応じて難易度を自動調整するADAPTIVE AIが搭載されていた。これはゲームAIの歴史においても早期のDDA実装例として注目される。[17](#ref-17)

より洗練されたDDAの代表例が三上真司監督の『バイオハザード4』（2005年）だ。「Difficulty Scale」という非公開のシステム（1〜10の評価値）が内部で稼働しており、プレイヤーの死亡回数・クリティカル攻撃の成功率などに基づいて敵の行動や耐久力をリアルタイムに調整していた。このシステムは公式攻略本にのみ記載され、プレイヤーには意図的に非公開とされていた。[17](#ref-17)

同年（2005年）の三上監督作品『ゴッドハンド』（Capcom）は逆に、画面上にリアルタイムで難易度メーターを表示し、プレイヤーが自分の実力を直視しながらゲームを進める設計を採用した。プレイヤーが敵を回避・攻撃するとメーターが上がり、より強い戦術を使う敵が出現するという「見える形のDDA」として対照的な設計思想を体現している。[18](#ref-18)

### Left 4 Deadの「AIディレクター」

2008年にValveが発売した『Left 4 Dead』は、DDAの概念を「メタAI」の形で結実させた歴史的作品だ。この作品の「AIディレクター」は、4人の生存者それぞれの「感情強度（Intensity）」を常時監視し、ゾンビの出現数・配置・アイテムの場所・BGMまでを動的に制御する。[19](#ref-19)[20](#ref-20)

感情強度が低ければ敵の数を増やして緊張感を高め、強度が高い状態が続けば敵の出現を抑制してプレイヤーに休息を与えるというサイクルで、「ビルドアップ→ピーク→リラックス」のリズムを繰り返す。AIディレクターは目に見えない存在でありながら、プレイヤーが「絶妙な難しさ」を感じる体験を演出する黒幕として機能した。[21](#ref-21)[20](#ref-20)

2024年のCEDEC（日本最大のゲーム開発者会議）では、プレイヤーの能力を「アビリティグラフ」で多次元的に分析し、分野別に難度を動的調整する「ゲームマスターAI」の研究が発表された。得意分野なのに難しいと感じている場合は味方NPCが協力し、苦手だが課題が易しい場合はTIPSを表示するという細やかなフォローが可能になり、難易度調整はさらに個人最適化の方向へ進んでいる。[22](#ref-22)

---- 

## 5. ボードゲームAIの頂点到達：人間を超えたAI (1997〜2017)

### チェス：ディープ・ブルーの衝撃 (1997)

IBMが開発した「ディープ・ブルー」は1997年、当時のチェス世界王者ガルリ・カスパロフを2勝1敗3引き分けで下し、トーナメント条件下で人間のチェス世界チャンピオンに勝利した初のコンピュータープログラムとなった。当時のディープ・ブルーは1秒間に2億手を読むことができ、アルファ・ベータ法と専用ハードウェアを組み合わせた圧倒的な探索能力が武器だった。[23](#ref-23)[24](#ref-24)

特徴的だったのは「人間の思考プロセスを模倣しない」独自の指し手（computer move）で、人間のグランドマスターが読みにくい「非常に異常な手」を選ぶことがあったという。現代のAIに通じる、人間の経験則を超えた計算力の勝利だった。[25](#ref-25)

### 将棋：電王戦とPonanzaの覇業 (2013〜2017)

日本の将棋界では、2012年から「将棋電王戦」と題したプロ棋士とコンピュータソフトの対戦シリーズが始まった。2012年の第1回ではボンクラーズが米長邦雄永世棋聖に勝利。翌2013年、第2回電王戦でPonanza（山本一成氏開発）が現役プロ棋士・佐藤慎一四段に141手で逆転勝ちし、「史上初めて現役プロ棋士に勝利した将棋ソフト」として一躍注目を集めた。[26](#ref-26)[27](#ref-27)[28](#ref-28)

その後、Ponanzaはプロ棋士相手に7連勝という圧倒的な成績を記録。2017年の第2期電王戦二番勝負では当時の名人・佐藤天彦叡王を2連勝で下し、人間とコンピュータの公式対決「電王戦」は幕を閉じた。開発者の山本一成氏は「この一勝は、情報科学としては偉大な一歩」と語った。[29](#ref-29)[27](#ref-27)[28](#ref-28)

### 囲碁：AlphaGoと深層強化学習の革命 (2015〜2017)

囲碁は盤の選択肢が膨大（1手あたり19×19の選択肢）で、チェスより格段に複雑なゲームだ。「AIが人間プロに勝つにはあと10年かかる」と専門家が予測していたにもかかわらず、Google DeepMindのAlphaGoは2015年に欧州王者を、2016年に韓国のイ・セドル九段を4勝1敗で破った。[30](#ref-30)[25](#ref-25)

さらに2017年のAlphaGo Zeroは、人間の棋譜を一切使わず自己対戦のみで学習するという革命的アプローチを採用し、初代AlphaGoより大幅に強くなることを示した。これは「人間の経験知識なしに、アルゴリズムだけで人間を超えることができる」という証明として、AI研究の歴史に刻まれた。続いてAlphaZeroとして囲碁・将棋・チェス全てに対応した汎用型ゲームAIへと発展した。[31](#ref-31)[24](#ref-24)

---- 

## 6. LLM×ゲームという新潮流 (2023〜現在)

### ゲームAIの課題と限界

2015年以降のオープンワールド化の波により、ビヘイビアツリーは肥大化の限界を迎えつつある。また、従来のNPCは「決められたセリフをループする存在」に過ぎず、プレイヤーとの本質的な会話や関係構築は不可能だった。この問題を解決する可能性として注目を集めているのが、大規模言語モデル（LLM）のゲームへの統合である。[16](#ref-16)

### NVIDIA ACE と Convai (2023〜)

NVIDIAは2023年、NPCに知性をもたらす「NVIDIA ACE（Avatar Cloud Engine）for Games」を発表した。音声認識（NVIDIA Riva）、LLMによる対話生成（NVIDIA NeMo）、リアルタイム表情アニメーション（Audio2Face）を組み合わせ、プレイヤーが自然言語でNPCと会話できる基盤を提供する。ConvaiはこのACEを統合し、GDC 2023のデモ「Kairos」でラーメン店主NPCとリアルタイム会話を実現して見せた。[32](#ref-32)

2025年CESではNVIDIA ACEをさらに「自律型ゲームキャラクター」へ拡張すると発表。PUBGでのAIチームメイト「PUBG Ally」（Mistral-Nemo-Minitron-8Bモデル使用）、NARAKA: BLADEPOINT MobileへのACE搭載AIチームメイト（2025年3月リリース）などが具体化している。特にDead Meat（GDC 2025発表）では、殺人ミステリーゲームのNPC容疑者とクラウドではなくデバイス上で自由に対話するため、SLM（小規模言語モデル）をオンデバイスで動かす技術を実現した。[33](#ref-33)[34](#ref-34)

### Ubisoft NEO NPCとTeammates (2024〜2025)

Ubisoftのパリスタジオは2024年3月、GDCにて「NEO NPC」プロジェクトを発表した。Inworld AIのLLMとNVIDIA Audio2Faceを活用し、プレイヤーの音声にリアルタイムで反応して即興対話を行うNPCを開発中だ。NPCには独自の性格・背景・目標・感情が設定され、プレイヤーとの対話がゲームプレイの進行に直接影響する仕組みを目指している。[35](#ref-35)[36](#ref-36)[37](#ref-37)

2025年11月にはさらに進化した「Teammates」プロジェクトが発表された。これはFPS環境でAIチームメイト「Pablo」と「Sofia」がプレイヤーの音声コマンドに反応して射撃・援護・戦術議論をリアルタイムで行うという体験を実現している。GoogleのGeminiと自社ミドルウェアを組み合わせ、約80人のチームが開発した。Ubisoftは「生成AIがゲームに与えるインパクトは3Dへの移行に匹敵する」とその重要性を強調している。[38](#ref-38)[39](#ref-39)[40](#ref-40)

### 進行中の課題と展望

LLMとゲームの融合はまだ実験段階だ。Ubisoftのナラティブディレクターは「LLMが物語制作を楽にするという誤解がある。実際にはキャラクターの設定資料（バイブル）が丸ごとプレイヤーにさらされるリスクが生じ、ガードレールの設計が複雑になる」と指摘する。[41](#ref-41)

また技術面では、クラウドベースLLMの遅延・コスト・オフライン環境での制限という問題を、SLMのオンデバイス動作で解決しようとする動きが進んでいる。専門家たちはAA規模の小中規模ゲームで2026〜2027年頃から実用化が始まり、大型AAA作品では3〜5年後に本格導入される可能性があると見ている。[39](#ref-39)[34](#ref-34)[42](#ref-42)

ルールベースのFSMから始まり、ビヘイビアツリー、メタAI、深層強化学習、そしてLLMへ。ゲームAIの歴史は、技術的制約を創造性に変え続けてきた人間とAIの共同制作の歴史でもある。1987年のMSX2の画面制限がステルスゲームを生み、ファミコンが「AI戦闘」という概念を世に送り出したように、制約と工夫の積み重ねの延長線上に、今日のLLM統合型ゲームキャラクターが立っている。

---

## References

<a id="ref-1"></a>
1. [AIゲームとは何か知りたい方必見！仕組みをわかりやすく紹介][59] - 有限オートマトン（FSM）, あらかじめ定義した状態を条件に応じて切り替える, 敵キャラが「待機→発見→追跡→攻撃」と状態遷移する ; ビヘイビアツリー, 行動を ...

<a id="ref-2"></a>
2. [メタルギアシリーズ - Wikipedia][60] - 小島秀夫監督作品 · メタルギア （1987年7月13日・MSX2） · メタルギア2 ソリッドスネーク （1990年7月20日・MSX2） · メタルギアソリッド （1998年9月3日・PS / 2...

<a id="ref-3"></a>
3. [[PDF] T H E C O M P L E T E O F F I C I ...](https://www.piggyback.com/us/wp-content/uploads/sites/6/2020/04/MGSV\_UE\_003-055\_150903\_ML.pdf) - Metal Gear made its first appearance on the MSX2 hardware 28 years ago. That was the era of the “sho...

<a id="ref-4"></a>
4. [[Metal Gear Solid] The Birth and Evolution of Stealth Action - YouTube](https://www.youtube.com/watch?v=hBSz4MaxV7I) - 元々、メタルギアはアクションゲームとして作っていたのですが、msx2の処理能力では弾を1度に4つ以上表示できなかったので、あえて弾を撃たない、撃て ...

<a id="ref-5"></a>
5. [MASTER COLLECTION 公式サイト (メタルギア ソリッド - Konami][61] - 初代『METAL GEAR』をもとに大幅に内容を改編し、ゲームシナリオやシステムも独自となった異色作。 SNAKE'S ...

<a id="ref-6"></a>
6. [Full text of "Oh!X 1993 02"][62] - ... 日本ファルコムのドル箱ともい うべき人気シリーズである。そして今回，そのなか ... 樹木生成です。ここで tree 0 L いう化理 はどのような動作をするのか想像し ...

<a id="ref-7"></a>
7. [イース for SHARP X68000 (C)1991 電波新聞社/マイコンソフト][63] - 『イース』は日本ファルコムが開発し、NEC PC-8801mkⅡSR以降版をオリジナルとして1987年6月21日に発売したロールプレイングゲーム。 SHARP X68000版はマイコンソフトが ...

<a id="ref-8"></a>
8. [ドラクエIVからChatGPTまで：AIの歴史をスライム並みにやさしく ...][64] - 1990年、ファミコン用ソフト『ドラゴンクエストIV』において、「AI戦闘システム」という新しい仕組みが登場しました。中でも「ガンガンいこうぜ」 ...

<a id="ref-9"></a>
9. [ドラゴンクエストIV 導かれし者たち - Wikipedia][65] - 戦闘時のAIシステムに関しては、最大8人のキャラクターが混在してもスムーズに行えるといった意見や、戦闘シーンが快適であったなど肯定的な意見が散見された。

<a id="ref-10"></a>
10. [「ドラクエ4」35周年！ 延々とザラキを唱えるクリフトにぐぬぬ。AI ...][66] - 第1章～4章までは手動でコマンド入力を行ない、キャラクターの行動を指示するバトルなのだが（NPCはAI）、第5章からは主人公を除く味方キャラクターたちは、 ...

<a id="ref-11"></a>
11. [ドラクエIVの「AI」から始まった空白の30年：懐かしさと未来の物語][67] - 『ドラゴンクエストIV』のAI戦闘システム、覚えてますか？ 1990年、ファミコン版で初登場したこのシステム ... ドラクエIVからChatGPTまで：AIの歴史を ...

<a id="ref-12"></a>
12. [[DQ4] The reason for introducing the AI ​​system and ... - YouTube](https://www.youtube.com/watch?v=yD537GTjH5s) - [DQ4] The reason for introducing the AI ​​system and Clift's verification [Part 2 of 128 - Game N......

<a id="ref-13"></a>
13. [ドラクエ4のAI戦闘と作戦、完全に理解した｜frenchbread - note][68] - 30年ぶりにファミコン版ドラクエ4をプレイしたので、AI戦闘の仕様についてまとめます。ソースは主に下の記事と自分でプレイした検証結果です。

<a id="ref-14"></a>
14. [【解析】ドラクエ4のAI戦闘 - med A - はてなブログ][69] - 今から30年以上前の話となります。 人工知能をテーマとして取り上げ. そのコンセプトをゲームに組み込んだことが. 当時、話題になりました。

<a id="ref-15"></a>
15. [AI最前線の現場から【スクウェア・エニックス】ゲーム ...][70] - ビヘイビア・ツリーは「Halo2」（Bungie, 2004）で新しく開発された技術で、現在ではゲーム産業で最も使用されている手法です。現在のゲームのキャラクター ...

<a id="ref-16"></a>
16. [【記事更新】私のブックマーク「ディジタルゲームの人工知能の ...][71] - ディジタルゲームの人工知能の歴史的変遷─ルールベースからディープラーニングまで ... 「ビヘイビアツリー」はゲーム産業を超えて，ロボティクスのAIなど，リアルタイム ...

<a id="ref-17"></a>
17. [Dynamic game difficulty balancing - Wikipedia][72] - The aim of dynamic difficulty balancing is to maintain the player's interest throughout the game by ...

<a id="ref-18"></a>
18. [Game Changers: Dynamic Difficulty - Game Developer][73] - A breakdown of some different approaches to dynamic difficulty adjustment, including one neat exampl...

<a id="ref-19"></a>
19. [Counter-Strike」から「Left 4 Dead」へ 協力プレイ、リプレイ性][74] - AIディレクターは、ご存じのとおり、本作のゲーム展開を制御する人工知能だ。これについて、巷では「毎回異なるシチュエーションを演出してくれる」こと ...

<a id="ref-20"></a>
20. [バルブのLeft 4 DeadのAIディレクターとは？][75] - AIディレクターは、プレイヤーのストレスレベルやプレイの強度を測定し、ゲームワールドを変更してプレイヤーを刺激します。ディレクターは、ゾンビの出現 ...

<a id="ref-21"></a>
21. [【UE4】L4DのAIDirectorを真似てメタAIを作ってみる その1][76] - Left 4 Deadシリーズ（L4D）ではAIDirector · ルールに基づいた敵の出現（スポーニング） · ドラマチックなペースの生成（ペーシング） · 障害物の配置（ルート作成）

<a id="ref-22"></a>
22. [AIが腕前を分析し，難度を自動調節してくれる日も近い ... - 4Gamer][77] - AIがプレイヤーの腕前を見てきめ細やかに難度を調整し，さらにはステージまで作ってくれる日も近いかもしれない。開発者向けカンファレンス「CEDEC ...

<a id="ref-23"></a>
23. [ゲーム AI の進化と歴史 - News Center Japan][78] - ついに、ディープ ブルーはトーナメントの条件下で、人間のチェス世界チャンピオンに勝利した初のコンピュータープログラムとなったのです。 囲碁 AI の ...

<a id="ref-24"></a>
24. [【徹底解説：AIとボードゲーム】AlphaGoって何がスゴいの？ ...][79] - 「ディープ・ブルー」は打倒カスパロフを掲げ開発が進められており、一 ... AlphaGo Zeroと同様のアプローチでチェスや将棋といった他のゲームに ...

<a id="ref-25"></a>
25. [囲碁チャンピオンを倒した「AlphaGo」について、チェス世界王者 ...][80] - AlphaGoとイ・セドル(李世乭)九段の対局のように、囲碁や将棋、チェスのような知能ゲームの世界トップレベルのプレイヤーと人工知能(AI)が対決する ...

<a id="ref-26"></a>
26. [将棋電王戦で現役プロ棋士に初めて勝った歴史的将棋ソフト 初代 ...][81] - これは、2013年の「第2回 将棋電王戦」において、現役プロ棋士を初めて破った将棋プログラム「Ponanza」（開発：山本一成氏）を思考エンジンとして採用した、 ...

<a id="ref-27"></a>
27. [「ponanza」、現役プロ棋士に史上初めて勝つ！ - 日本将棋連盟][82] - コンピュータソフトが現役プロ棋士に勝ったのは史上初めてです。これで対戦成績は1勝1敗になりました。第3局は4月6日（土）に船江恒平五段 ...

<a id="ref-28"></a>
28. [将棋ソフトの進化は将棋界に何をもたらしたか。これまでの電王戦 ...][83] - 2012年に始まったプロ棋士対コンピュータ将棋ソフトの戦い、将棋電王戦と、それに続く電王戦は、6年の歴史を持って完全終了が宣言された。 今回は、まず ...

<a id="ref-29"></a>
29. [電王戦第2局こぼれ話。プロ棋士対コンピュータソフトの最終対決で ...][84] - 佐藤天彦名人とコンピュータソフトPONANZA（開発者：山本一成さん、下山晃さん）の間で争われた第2期電王戦二番勝負。第2局は兵庫県姫路市にある ...

<a id="ref-30"></a>
30. [AlphaGo][85] - AlphaGo（アルファ碁、アルファご）は、Google DeepMindによって開発されたコンピュータ囲碁プログラムである。 2015年10月に、ヨーロッパ王者ファン・フイ相手に互先（ ...

<a id="ref-31"></a>
31. [ディープマインドやソニーがゲームAIから見出した「人間の知性」 ...][86] - 人間の棋譜に全く頼らず、自己対戦を繰り返して強くなる「AlphaGo Zero」を2017年に開発。続いて囲碁だけでなく将棋やチェスにも対応した「Alpha Zero」、 ...

<a id="ref-32"></a>
32. [NVIDIA、NPCに命を吹き込む新たな生成AIサービスを発表][87] - 「ACE for Games」は、AIを活用した自然言語によるやり取りを通じてNPCに知性をもたらすサービスだ。ミドルウェアやツール、ゲームの開発者は「ACE for ...

<a id="ref-33"></a>
33. [NVIDIA Redefines Game AI With ACE Autonomous Game ...][88] - NVIDIA is now expanding ACE from conversational NPCs to autonomous game characters that use AI to pe...

<a id="ref-34"></a>
34. [Bringing AI NPCs to Life On-Device With NVIDIA ACE ...][89] - Watch a replay of our GDC 2025 Session, presented by Meaning Machine. Dead Meat is a murder mystery ...

<a id="ref-35"></a>
35. [How Ubisoft's New Generative AI Prototype Changes the Narrative ...][90] - Project NEO NPC is only a prototype, and there's still a way to go before it can be implemented in a...

<a id="ref-36"></a>
36. [生成AIで自然に対話できるNPCを作る技術「NEO NPC」をUbisoftが ...][91] - NEO NPCは，ゲーム用途向けAI対話生成エンジンを開発するInworldの大規模言語モデル（LLM）や，NVIDIAの音声および表情合成技術「Audio2Face」を利用して， ...

<a id="ref-37"></a>
37. [プレイヤーがキャラと協力して強盗を計画もーーUbisoft、生成 AI を ...][92] - Ubisoft の Gen AI を搭載した Neo NPC が、会話を創発的でダイナミックなゲームプレイに変える。 Ubisoft は、Game Developers Conference にて、プ...

<a id="ref-38"></a>
38. [Ubisoft debuts playable generative AI experiment - Game Developer][93] - "In the initial prototype from 2024, Neo NPCs displayed novel cognitive and natural language abiliti...

<a id="ref-39"></a>
39. [Ubisoft and Generative AI: Redefining the Role of Teammates ... - 竞核][94] - In a demonstration a year ago, NEO NPCs could already perform real-time analysis of player speech, p...

<a id="ref-40"></a>
40. [ユービーアイ、NPCへの音声指示や会話ができる生成AI研究 ...][95] - なお2024年3月には「NEO NPC」が同社より発表されていました。「NEO NPC」はプレイヤーと対話が行えるNPC技術と説明されていました。 ゲームの中のキャラ ...

<a id="ref-41"></a>
41. [Ubisoft's 'Teammates' Demo & Their New Generative AI Push | 26/11 ...][96] - Ubisoft lays out their new generative AI technology stack. I walk through my experiences playing the...

<a id="ref-42"></a>
42. [NVIDIA Develops ACE AI Models for Autonomous Game ...][97] - NVIDIA Develops ACE AI Models for Autonomous Game Characters; PUBG, inZOI, NARAKA to Utilize ACE in ...


[1]:	https://www.blooktecpc-support.com/useful/ai_game/
[2]:	https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%BF%E3%83%AB%E3%82%AE%E3%82%A2%E3%82%B7%E3%83%AA%E3%83%BC%E3%82%BA
[3]:	https://www.konami.com/mg/mc/asia/ja/
[4]:	https://archive.org/stream/OhX_1993-02/OhX_1993-02_djvu.txt
[5]:	http://gyusyabu.ddo.jp/MP3/1991/YS68.html
[6]:	https://kantanstart.com/entry/dragonquest4-ai-history
[7]:	https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%A9%E3%82%B4%E3%83%B3%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88IV_%E5%B0%8E%E3%81%8B%E3%82%8C%E3%81%97%E8%80%85%E3%81%9F%E3%81%A1
[8]:	https://game.watch.impress.co.jp/docs/kikaku/1660147.html
[9]:	https://kantanstart.com/entry/dragonquest4-ai-30years
[10]:	https://kantanstart.com/entry/dragonquest4-ai-30years
[11]:	https://note.com/frenchbread/n/n7bf90335f5eb
[12]:	https://774buya.hatenablog.com/entry/2023/12/13/083000
[13]:	https://thinkit.co.jp/article/10012
[14]:	https://www.ai-gakkai.or.jp/resource/my-bookmark/my-bookmark_vol37-no6/
[15]:	https://en.wikipedia.org/wiki/Dynamic_game_difficulty_balancing
[16]:	https://game.watch.impress.co.jp/docs/kikaku/1660147.html
[17]:	https://note.com/frenchbread/n/n7bf90335f5eb
[18]:	https://www.ai-gakkai.or.jp/resource/my-bookmark/my-bookmark_vol37-no6/
[19]:	https://www.gamedeveloper.com/design/game-changers-dynamic-difficulty
[20]:	https://game.watch.impress.co.jp/docs/news/080051.html
[21]:	https://www.gamedeveloper.com/design/game-changers-dynamic-difficulty
[22]:	https://game.watch.impress.co.jp/docs/news/080051.html
[23]:	https://www.toolify.ai/ja/ai-news-jp/left-4-deadai-1513323
[24]:	https://www.toolify.ai/ja/ai-news-jp/left-4-deadai-1513323
[25]:	https://www.toolify.ai/ja/ai-news-jp/left-4-deadai-1513323
[26]:	https://qiita.com/Dv7Pavilion/items/cd263f844a56cb168180
[27]:	https://www.4gamer.net/games/999/G999905/20240824014/
[28]:	https://news.microsoft.com/ja-jp/2019/08/19/190819-evolution-and-history-of-game-ai/
[29]:	https://data.wingarc.com/alpha-go-26586
[30]:	https://news.microsoft.com/ja-jp/2019/08/19/190819-evolution-and-history-of-game-ai/
[31]:	https://gigazine.net/news/20160314-deep-blue-developer/
[32]:	https://prtimes.jp/main/html/rd/p/000000493.000002955.html
[33]:	https://www.shogi.or.jp/event/2013/03/post_721.html
[34]:	https://www.shogi.or.jp/column/2017/06/post_183.html
[35]:	https://www.shogi.or.jp/column/2017/06/22_1.html
[36]:	https://ja.wikipedia.org/wiki/AlphaGo
[37]:	https://xtech.nikkei.com/atcl/nxt/column/18/01218/022100002/
[38]:	https://news.denfaminicogamer.jp/news/230530f
[39]:	https://ja.wikipedia.org/wiki/AlphaGo
[40]:	https://xtech.nikkei.com/atcl/nxt/column/18/01218/022100002/
[41]:	https://www.nvidia.com/en-us/geforce/news/nvidia-ace-autonomous-ai-companions-pubg-naraka-bladepoint/
[42]:	https://www.shogi.or.jp/column/2017/06/post_183.html
[43]:	https://www.youtube.com/watch?v=F_Tpfn1LxEA
[44]:	https://www.shogi.or.jp/event/2013/03/post_721.html
[45]:	https://game.watch.impress.co.jp/docs/news/080051.html
[46]:	https://news.ubisoft.com/en-us/article/5qXdxhshJBXoanFZApdG3L/how-ubisofts-new-generative-ai-prototype-changes-the-narrative-for-npcs
[47]:	https://www.4gamer.net/games/999/G999902/20240320007/
[48]:	https://thebridge.jp/2024/03/ubisoft-neo-npcs-nvidia-inworldai-gdc
[49]:	https://www.gamedeveloper.com/business/ubisoft-s-first-playable-generative-ai-experience-is-an-r-d-experiment-called-teammates-
[50]:	https://www.cgames.com/contents/2/9665.html
[51]:	https://www.gamespark.jp/article/2025/11/22/159780.html
[52]:	https://www.aiandgames.com/p/ubisofts-teammates-demo-and-their
[53]:	https://www.reddit.com/r/pcgaming/comments/1i9sq34/nvidia_develops_ace_ai_models_for_autonomous_game/
[56]:	https://www.reddit.com/r/pcgaming/comments/1i9sq34/nvidia_develops_ace_ai_models_for_autonomous_game/
[57]:	https://thebridge.jp/2024/03/ubisoft-neo-npcs-nvidia-inworldai-gdc
[59]:	https://www.blooktecpc-support.com/useful/ai_game/
[60]:	https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%BF%E3%83%AB%E3%82%AE%E3%82%A2%E3%82%B7%E3%83%AA%E3%83%BC%E3%82%BA
[61]:	https://www.konami.com/mg/mc/asia/ja/
[62]:	https://archive.org/stream/OhX_1993-02/OhX_1993-02_djvu.txt
[63]:	http://gyusyabu.ddo.jp/MP3/1991/YS68.html
[64]:	https://kantanstart.com/entry/dragonquest4-ai-history
[65]:	https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%A9%E3%82%B4%E3%83%B3%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88IV_%E5%B0%8E%E3%81%8B%E3%82%8C%E3%81%97%E8%80%85%E3%81%9F%E3%81%A1
[66]:	https://game.watch.impress.co.jp/docs/kikaku/1660147.html
[67]:	https://kantanstart.com/entry/dragonquest4-ai-30years
[68]:	https://note.com/frenchbread/n/n7bf90335f5eb
[69]:	https://774buya.hatenablog.com/entry/2023/12/13/083000
[70]:	https://thinkit.co.jp/article/10012
[71]:	https://www.ai-gakkai.or.jp/resource/my-bookmark/my-bookmark_vol37-no6/
[72]:	https://en.wikipedia.org/wiki/Dynamic_game_difficulty_balancing
[73]:	https://www.gamedeveloper.com/design/game-changers-dynamic-difficulty
[74]:	https://game.watch.impress.co.jp/docs/news/080051.html
[75]:	https://www.toolify.ai/ja/ai-news-jp/left-4-deadai-1513323
[76]:	https://qiita.com/Dv7Pavilion/items/cd263f844a56cb168180
[77]:	https://www.4gamer.net/games/999/G999905/20240824014/
[78]:	https://news.microsoft.com/ja-jp/2019/08/19/190819-evolution-and-history-of-game-ai/
[79]:	https://data.wingarc.com/alpha-go-26586
[80]:	https://gigazine.net/news/20160314-deep-blue-developer/
[81]:	https://prtimes.jp/main/html/rd/p/000000493.000002955.html
[82]:	https://www.shogi.or.jp/event/2013/03/post_721.html
[83]:	https://www.shogi.or.jp/column/2017/06/post_183.html
[84]:	https://www.shogi.or.jp/column/2017/06/22_1.html
[85]:	https://ja.wikipedia.org/wiki/AlphaGo
[86]:	https://xtech.nikkei.com/atcl/nxt/column/18/01218/022100002/
[87]:	https://news.denfaminicogamer.jp/news/230530f
[88]:	https://www.nvidia.com/en-us/geforce/news/nvidia-ace-autonomous-ai-companions-pubg-naraka-bladepoint/
[89]:	https://www.youtube.com/watch?v=F_Tpfn1LxEA
[90]:	https://news.ubisoft.com/en-us/article/5qXdxhshJBXoanFZApdG3L/how-ubisofts-new-generative-ai-prototype-changes-the-narrative-for-npcs
[91]:	https://www.4gamer.net/games/999/G999902/20240320007/
[92]:	https://thebridge.jp/2024/03/ubisoft-neo-npcs-nvidia-inworldai-gdc
[93]:	https://www.gamedeveloper.com/business/ubisoft-s-first-playable-generative-ai-experience-is-an-r-d-experiment-called-teammates-
[94]:	https://www.cgames.com/contents/2/9665.html
[95]:	https://www.gamespark.jp/article/2025/11/22/159780.html
[96]:	https://www.aiandgames.com/p/ubisofts-teammates-demo-and-their
[97]:	https://www.reddit.com/r/pcgaming/comments/1i9sq34/nvidia_develops_ace_ai_models_for_autonomous_game/
