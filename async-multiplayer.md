# ゲームの非同期オンライン要素：プレイヤー体験視点の分類と設計指針

## はじめに：「非同期」とはなにか

「非同期オンライン要素」とは、 **複数のプレイヤーが同じ時間軸にいなくても、互いの行動が影響し合う仕組み** のことだ。リアルタイムの対戦や協力プレイ（同期型）と異なり、プレイヤーAのプレイの痕跡をプレイヤーBが数時間後・数日後に発見するような、時間的なズレを前提としたインタラクションである。[[1](#ref-1)][[2](#ref-2)]

この概念を現代ゲームに広めた功績の多くはフロム・ソフトウェアにある。宮崎英高は、雪の坂道で立ち往生した自分の車を見知らぬ人々が押し上げてくれ、礼を言う間もなく互いに名乗らぬまま去っていった体験を語っている。「困難な場面で見知らぬ者同士が助け合い、そして消えていく」というこの着想が直接結実したのは協力プレイ（召喚）システムだが、同じ「ゆきずりのつながり」という設計哲学は、『デモンズソウル』（2009年）が確立したメッセージ・血痕といった非同期システムにも通底している。これらは以降の『ダークソウル』シリーズや『エルデンリング』へと受け継がれてきた。[[4](#ref-4)][[5](#ref-5)]

***

## プレイヤー体験視点による5つの分類

非同期要素は「どんな体験をプレイヤーに与えるか」という軸で整理すると、設計の本質が見えやすくなる。以下の5分類は互いに重複することもあるが、設計時の目的意識を明確にする枠組みとして有効だ。

***

### 分類①「痕跡と気配」体験：孤独の中に人の息吹を感じる

**キーワード：世界の生きてる感、孤独感の緩和、間接的な共存**

ソロプレイ中に「誰かがここにいた」という感覚を生む体験カテゴリ。プレイヤーは直接会話することなく、他者の存在を感じる。

**主な事例**

| ゲーム | 要素 | 体験の内容 |
|--------|------|------------|
| エルデンリング / ダークソウルシリーズ | 血痕 | 他プレイヤーの死に様の幻影が再生される。危険地帯の予兆になる[[6](#ref-6)][[3](#ref-3)] |
| エルデンリング | 幻影（ゴースト） | 他プレイヤーの行動の残影が半透明で見える。世界に人の気配が漂う[[6](#ref-6)] |
| デス・ストランディング | 足跡・休憩の痕跡 | 他プレイヤーが通過・休憩した場所が世界に記録される[[7](#ref-7)] |
| 『スカイリム SE』向けMod「LUMIS」 | 魔法の灯明ゴースト | 最大8人の他プレイヤーがリアルタイムで灯明型ゴーストとして視認できる[[8](#ref-8)] |

**設計の核心**：この体験は「生きた世界」への没入感を高める。プレイヤーは自分が唯一の探索者ではないことを感じつつも、他者との直接衝突を避けられる。リソースや開発コストが低いわりに、世界の「密度」が劇的に増すため、コストパフォーマンスが高い非同期手法だ。[[9](#ref-9)]

***

### 分類②「知恵の継承」体験：他者の発見が自分を助ける

**キーワード：情報共有、コミュニティの知恵、信頼と裏切り**

他のプレイヤーが残したヒントや情報を受け取ることで、プレイが変化する体験。「助けてもらった」「騙された」という感情的な振れ幅が設計の醍醐味になる。

**主な事例**

| ゲーム | 要素 | 体験の内容 |
|--------|------|------------|
| エルデンリング / ダークソウルシリーズ | メッセージ | 定型文の組み合わせで攻略ヒントや嘘メッセージを残せる。評価（称賛）で書いた人の体力が回復する[[6](#ref-6)][[10](#ref-10)] |
| デス・ストランディング2 | サイン | 危険・おすすめルートなどを示す記号を設置できる[[11](#ref-11)] |
| フェズ | 隠し文字の解読 | 難解な暗号パズルをコミュニティ全体で解読する文化が生まれた[[12](#ref-12)] |
| ワードル | 共通パズルの共有 | 世界中が毎日同じ問題に挑む。絵文字グリッドのSNSシェアが「知恵の見せ合い」になる[[13](#ref-13)][[14](#ref-14)] |

**設計の核心**：メッセージシステムの絶妙な点は、 **完全な文章が書けない制約** にある。定型文の組み合わせしか使えないため、情報の信頼性が常に曖昧になり、「本物のヒント」か「罠」かをプレイヤー自身が判断する読解ゲームが生まれる。ワードルはこれを逆方向に使い、「自分のスコアをシェアしたい」という欲求がそのままバイラル伝播の燃料になった。[[13](#ref-13)][[3](#ref-3)]

***

### 分類③「インフラ共同構築」体験：見知らぬ誰かと世界を作る

**キーワード：共同作業、付与と受容、ゲーム世界への貢献感**

プレイヤーが建造物や構造物を世界に残し、他のプレイヤーがそれを利用できる体験。「誰かの役に立っている」という実感が特徴。

**主な事例**

| ゲーム | 要素 | 体験の内容 |
|--------|------|------------|
| デス・ストランディング | ラダー・ロープ・橋・ロードなどの構造物 | 自分が設置した構造物が他のプレイヤーの世界に出現し、使われると「いいね！」が届く[[15](#ref-15)][[7](#ref-7)] |
| デス・ストランディング2 | ポータブル・カイラル・コンストラクター（PCC）製の構造物 | 他プレイヤーが未完成で残した橋を、自分が資材を提供して完成させられる。協力作業の感覚[[16](#ref-16)] |
| どうぶつの森シリーズ | マイデザイン共有・島の共有 | セーブデータ単位の共有型世界。複数プレイヤーの行動が同じ島に蓄積される[[17](#ref-17)] |
| ノーマンズスカイ | 基地の共有・発見のシェア | 他プレイヤーの基地を訪問できる。惑星の命名・発見がサーバーに共有される[[18](#ref-18)] |

**設計の核心**：デス・ストランディングの「いいね！」システムは、非同期でありながら **感謝のフィードバックループ** を実現した点が革新的だ。プレイヤーは報酬を期待せずに構造物を建てるが、後から「いいね」が届くことで、他者への貢献行為が時差を超えて完結する。このメカニクスはSNSの「いいね」と本質的に同じ心理的報酬設計だ。[[19](#ref-19)]

どうぶつの森の開発者・野上恒氏は初代から「非同期コミュニケーション」をコアバリューとして位置付けており、「インターネットを使わないオンラインゲーム」として設計していたと語っている。[[17](#ref-17)]

***

### 分類④「共通体験と競争」体験：同じ問題に挑む仲間意識

**キーワード：公平な競争、達成感の共有、コミュニティ形成**

全プレイヤーが同じ条件・同じ問題に挑むことで、「結果の比較」と「体験の共有」が生まれる体験カテゴリ。

**主な事例**

| ゲーム | 要素 | 体験の内容 |
|--------|------|------------|
| スペランキー HD / スペランキー2 | デイリーチャレンジ | 全プレイヤーが毎日同一シードのコースに1回だけ挑戦。死んだら再試行不可。スコアをリーダーボードで競う[[20](#ref-20)] |
| ワードル | 日替わりワード | 全世界が同じ5文字の単語を毎日一度だけ推測する。結果のシェアが共感を生む[[13](#ref-13)] |
| レーシングゲーム各種（ホットラップリーグなど） | ゴーストラップ | 過去の自己ベストや他プレイヤーの最速ラップが半透明の車（ゴースト）として並走する[[21](#ref-21)] |

**設計の核心**：スペランキーのデイリーチャレンジは「**無作為性の統制**」という独特な設計だ。通常のローグライクは毎プレイでランダム生成されるが、デイリーだけは全プレイヤーが同一の条件に挑む。これにより「運の差」が消え、純粋な技術の比較が可能になる。「再試行できない」制約が緊張感を高め、ミスを1回のドラマとして昇華させる。[[20](#ref-20)]

ゴーストシステムはタイムラグのある「並走体験」を実現する。物理的に同じ時間に遊んでいなくても、相手の最善の走りと競えるため、モチベーション維持のループが生まれやすい。[[1](#ref-1)]

***

### 分類⑤「非対称の攻防」体験：自分のいない間に世界が動く

**キーワード：準備と結果、戦略の永続性、防衛設計の楽しさ**

攻撃側と防衛側が非同期で対立する体験。プレイヤーは「自分がオフラインの間も世界で何かが起きている」感覚を得る。

**主な事例**

| ゲーム | 要素 | 体験の内容 |
|--------|------|------------|
| クラッシュ・オブ・クラン | オフライン防衛（AI制御） | オフライン中に他プレイヤーに攻撃され、設置した防衛施設がAI制御で自動的に応戦する。プレイヤーは「守りの設計」を考える[[22](#ref-22)] |
| エルデンリング | 侵入システム（準同期） | 他プレイヤーの世界に侵入者として現れる。侵入された側にとっては「突然の非同期的脅威」[[23](#ref-23)] |
| レット・イット・ダイ | ヘイターシステム | 死亡したプレイヤーのデータが「ヘイター」として他プレイヤーのゲームに出現する[[24](#ref-24)] |
| どうぶつの森 | 島の共有 | 自分がいない間に別の住人がプレイし、島の状態が変化している[[17](#ref-17)] |

**設計の核心**：クラッシュ・オブ・クランの防衛設計は、 **プレイヤーがオフライン中にも継続するゲームプレイ** を生み出した。攻撃は完全に非同期で行われ（攻撃側はAIが守る村を攻める）、プレイヤーは自分が不在の時間も戦略的に関与し続ける感覚を得る。これはモバイルゲームの特性と非常に相性が良い。[[22](#ref-22)]

レット・イット・ダイの「ヘイター」は、死というネガティブなイベントを **他者のゲームへのコントリビューション** に転換した点が秀逸だ。失敗が他者の世界を豊かにするという逆転の発想は、ダークソウルの血痕と同じ哲学を持つ。[[24](#ref-24)]

***

## 体験分類の全体マップ

```
                プレイヤーへの感情的ベクトル
                        │
             孤独感の緩和・帰属感
                        │
     ①痕跡と気配 ───────┼──────── ③インフラ共同構築
    （受動的な共存）     │        （能動的な貢献）
                        │
 ─────────────────────────────────────────
 一方向（受け取る）      │                 双方向（与えあう）
                        │
     ②知恵の継承 ───────┼──────── ⑤非対称の攻防
    （情報の授受）       │        （戦略の衝突）
                        │
             競争心・達成感への欲求
                        │
                  ④共通体験と競争
                        │
```

***

## 体験分類別の設計チェックリスト

### ゲームプランナーへの実装ヒント

| 分類 | 実装上の核心 | よくある落とし穴 | 向いているジャンル |
|------|-------------|-----------------|------------------|
| ①痕跡と気配 | 痕跡の密度調整（多すぎると情報過多） | ゴーストが「邪魔なUI」になる | オープンワールド、ホラー、探索系 |
| ②知恵の継承 | 情報の信憑性を完全にしない制約設計 | 正確すぎて攻略サイト化する | RPG、謎解き、ローグライク |
| ③インフラ共同構築 | 貢献に対するフィードバックループ設計 | 一部プレイヤーによる独占・破壊 | サンドボックス、配達・建設系 |
| ④共通体験と競争 | 全員同一条件の保証と1日1回の制約 | 再試行可能で緊張感が消える | ローグライク、パズル、レーシング |
| ⑤非対称の攻防 | オフライン時でも意味を持つ防衛設計 | 不在時の大敗が離脱の原因になる | ストラテジー、タワーディフェンス |

***

## 設計原則：4つのデザイン指針

### 1. 完全性を奪う制約が体験を深める

メッセージ機能もデイリーチャレンジも、 **完全な自由を与えない制約** がゲームの深みを生む。定型文のみ・1日1回・再試行不可という制約は一見不便だが、プレイヤーの想像力と感情を刺激する。設計者はどの自由を意図的に制限するかを問うべきだ。[[3](#ref-3)][[20](#ref-20)]

### 2. 「失敗」を他者への贈り物にする

ダークソウルの血痕、レット・イット・ダイのヘイターはいずれも、 **死というネガティブな体験を他者への貢献へと転換** している。非同期設計の最も創造的な応用の一つは、失敗イベントを世界の豊かさに変換することだ。[[24](#ref-24)][[3](#ref-3)]

### 3. フィードバックは時間差でも機能する

デス・ストランディングの「いいね！」は、同時接続を要求せずに **感謝を届けるフィードバックループ** を実現した。非同期でも報酬が届くと分かれば、プレイヤーは他者のために行動する動機を持ち続ける。[[15](#ref-15)][[19](#ref-19)]

### 4. ナラティブと整合させる

デス・ストランディングの「つながりを取り戻す」という物語テーマと、ソーシャル・ストランド・システムは完全に一致している。非同期要素が「なぜこの世界に存在するか」をゲームの設定やテーマと繋げると、プレイヤーはシステムをゲームの一部として自然に受け入れる。[[25](#ref-25)][[15](#ref-15)]

***

## まとめ：非同期はゲームを「生きた世界」にする

非同期オンライン要素の本質は、「常時接続しなくても、世界が他者の存在で満たされている」感覚の創出だ。宮崎英高が雪嵐の夜に感じた「助けてもらったが相手は消えた」という体験の本質が、そのままゲームのデザイン原理になっている。[[5](#ref-5)][[9](#ref-9)]

現代においてこの手法は、モバイルゲームのセッション設計、SNSとの連携設計、オープンワールドの密度向上など、多様な文脈で応用されている。新しいゲームを設計するとき、「このゲームで他者とどんな体験を共有させたいか」という問いから非同期要素を逆算することが、最も確実な設計アプローチと言えるだろう。[[16](#ref-16)][[22](#ref-22)][[13](#ref-13)]

---

## References

<a id="ref-1"></a>1. [What I've learned about designing multiplayer games so far][1] - A retail game like Dark Souls assume very low concurrency and plays almost entirely as a single play...

<a id="ref-2"></a>2. [An async multiplayer question : r/gamedesign - Reddit][2] - Anything that involves multiple players not needing to be present in real time at the same time is a...

<a id="ref-3"></a>3. [『ELDEN RING』ネットワークテスト先行レビュー！ 探索・戦闘の ...][3] - ネットワークテストで体験できた範囲ではあるが、探索や戦闘など本作のゲームプレイ要素についてご紹介していこう。 ... 他のプレイヤーの死に様やメモなど ...

<a id="ref-4"></a>4. [Demon's Souls - Wikipedia][4] - Demon's Souls makes use of asynchronous multiplayer for those connected to the PlayStation Network. ...

<a id="ref-5"></a>5. [The story of how a car breakdown led Hidetaka Miyazaki to create ...][5] - The father of soulslike games revealed that his famous multiplayer system was born out of a mishap h...

<a id="ref-6"></a>6. [【エルデンリング】マルチプレイ(オンライン)のやり方 - ゲームウィズ][6] - 非同期マルチ要素 ... オンライン可能な状態だと、他プレイヤーのメッセージや痕跡、幻影を見る場合がある。これらはゲームプレイに直接的な影響はないが、 ...

<a id="ref-7"></a>7. [「Death Stranding」はMMOの煩わしい部分を排除した非同期型の ...][7] - Death Strandingは、他のプレイヤーと同じ世界を共有することはしないが、間接的に影響を与えることができる「非同期型のMMOゲーム」だと考えられる。

<a id="ref-8"></a>8. [『スカイリム SE』向け非同期型マルチプレイModリリース間もなく ...][8] - 「LUMIS」とは、『No Man's Sky』初期のような要素を備えたパッシブなマルチプレイヤー体験ができるModです。 ... 国内外、様々なジャンルのゲームを分け ...

<a id="ref-9"></a>9. [Why "single player" games are secretly becoming multiplayer. - Reddit][9] - The Loneliness myth: Why "single player" games are secretly becoming multiplayer. ... In design, thi...

<a id="ref-10"></a>10. [The Joy of Player Generated Messages in Elden Ring][10] - Players are able to leave cryptic messages scattered across the game world that rival the ambiguity ...

<a id="ref-11"></a>11. [How Death Stranding 2's Asynchronous Multiplayer Changes the ...][11] - Once you've connected a terminal to the Chiral Network and 'bring it online', you'll be able to buil...

<a id="ref-12"></a>12. [Fez (video game) - Wikipedia][12] - The player rotates between these four 2D views to realign platforms and solve puzzles. The objective...

<a id="ref-13"></a>13. [Wordle: Why a Simple Word Game Went Viral, According to Experts][13] - Wordle has become the first viral game of 2022, with millions of players sharing their daily scores....

<a id="ref-14"></a>14. [The Wordle Phenomenon: A Deep Dive into the Daily Delight][14] - Wordle, a daily word puzzle that asks players to guess a five-letter word in six attempts, emerged f...

<a id="ref-15"></a>15. [Social Strand System - Death Stranding Wiki - Fandom][15] - The Social Strand System is the core framework that embodies Death Stranding's central theme of "con...

<a id="ref-16"></a>16. [Everything You Need To Know About Death Stranding 2's ... - Kotaku][16] - Once an area is online, you'll be able to see structures that other players have left behind. This f...

<a id="ref-17"></a>17. [「どうぶつの森」は第3世代へ！ 世界が認めるコミュニケーション ...][17] - 今回のセッションで語られたのは、「ゲームデザインの変遷」、「開発体制の変遷」の2つ。野上氏が最初に携わったNINTENDO64「あつまれ どうぶつの森」から ...

<a id="ref-18"></a>18. [Multiplayer and Crossplay Explained 2023 - No Man's Sky Beginner ...][18] - ... community-focused journeys with shared objectives. Player Interaction: When playing in Online Mu...

<a id="ref-19"></a>19. [【デススト】人類はやさしさでいいね！を回すことが出来るのか ...][19] - お使いゲーではありますがその道のりを、快適に効率よく最適化するためにインフラを整備していくシミュレーション要素や、道中のストーリー、難所を ...

<a id="ref-20"></a>20. [The understated genius of the Spelunky Daily Challenge][20] - Players are swapping Steam friend details to get their daily leaderboards filled up, and subscribing...

<a id="ref-21"></a>21. [Hot Lap League: Deluxe Edition on Steam - Racing Games][21] - Competitive time trial racing action · Daily events and challenges for rewards · Visual customisatio...

<a id="ref-22"></a>22. [Multiplayer On Mobile: 3 Approaches][22] - Faked Synchronous; Simultaneous Multiplayer; Asymmetrical Asynchronous. Each can create strong sessi...

<a id="ref-23"></a>23. [ネットワークプレイ2 - ELDEN RING ｜ エルデンリング][23] - プレイヤー同士で協力して攻略することができます。一度に召喚できる協力ゲストは2人までです。 ホストがエリアボスを倒すことで目的を達成し協力プレイが終了し ...

<a id="ref-24"></a>24. [Let It Die (video game) - Wikipedia][24] - Let It Die is a free-to-play online hack and slash video game developed by Grasshopper Manufacture a...

<a id="ref-25"></a>25. [システムで人々を魅了したゲームたち：『デス・ストランディング ...][25] - 本稿では、小島秀夫監督が独立後に初めて手がけたゲーム『DEATH STRANDING（デス・ストランディング）』を取り上げ、本作に実装されている“ソーシャル・ ...

[1]: https://www.gamedeveloper.com/design/what-i-ve-learned-about-designing-multiplayer-games-so-far
[2]: https://www.reddit.com/r/gamedesign/comments/197396a/an_async_multiplayer_question/
[3]: https://blog.ja.playstation.com/2021/11/11/20211111-eldenring/
[4]: https://en.wikipedia.org/wiki/Demon's_Souls
[5]: https://en.as.com/meristation/news/the-story-of-how-a-car-breakdown-led-hidetaka-miyazaki-to-create-the-dark-souls-summoning-system-f202603-n/
[6]: https://gamewith.jp/eldenring/320654
[7]: https://kultur.jp/oldpost-4550/
[8]: https://www.gamespark.jp/article/2026/01/19/161755.html
[9]: https://www.reddit.com/r/ItsAllAboutGames/comments/1sz86vm/the_loneliness_myth_why_single_player_games_are/
[10]: https://frostilyte.ca/2022/08/11/the-joy-of-player-generated-messages-in-elden-ring/
[11]: https://uperfect.com/blogs/portable-gaming-monitor/death-stranding-2-on-the-beach
[12]: https://en.wikipedia.org/wiki/Fez_(video_game)
[13]: https://www.businessinsider.com/wordle-game-viral-experts-psychology-sharing-twitter-2022-1
[14]: https://factspark.blog/posts/the-wordle-phenomenon-a-deep-dive-into-the-daily-delight
[15]: https://deathstranding.fandom.com/wiki/Social_Strand_System
[16]: https://kotaku.com/death-stranding-2-chiral-network-multiplayer-connect-1851785246
[17]: https://game.watch.impress.co.jp/docs/kikaku/1275162.html
[18]: https://www.youtube.com/watch?v=weSHtGhL5Ic
[19]: https://www.underpolar.com/entry/2019/11/17/143000
[20]: https://www.gamedeveloper.com/design/the-understated-genius-of-the-i-spelunky-i-daily-challenge
[21]: https://store.steampowered.com/app/2068710/
[22]: https://mobilefreetoplay.com/multiplayer-on-mobile-3-approaches/
[23]: https://www.fromsoftware.jp/manual/eldenring/ps5/networkplay2.html
[24]: https://en.wikipedia.org/wiki/Let_It_Die_(video_game)
[25]: https://realsound.jp/tech/2022/10/post-1145218.html
