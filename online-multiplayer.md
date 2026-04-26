# 家庭用ゲーム機のネット対戦：物理的制約と遅延隠蔽技術の完全解説

## はじめに

オンライン対戦ゲームを快適に遊べているとき、実は目には見えない複雑な「嘘」がいくつも重なり合っている。あなたが今まさに戦っている相手キャラクターの位置は、物理的には「少し前の状態」であり、あなた自身の操作結果でさえも、ゲーム機がサーバーの返答を待たずに「先回りして予測した映像」を表示していることがある。本レポートでは、なぜこうした仕組みが必要なのかを物理法則から解き明かし、それを乗り越えるために開発者が積み上げてきた技術を体系的に解説する。

---- 

## 第1章：光速という絶対的な壁

### 1-1. 光速の壁とは何か

通信の遅延（レイテンシ）を理解するうえで最初に押さえるべきことは、「どんな技術を使っても光速は超えられない」という物理法則だ。真空中の光速は約 **299,792 km/s** （秒速約30万km）であり、電気信号も電磁波の一種であるためこれに縛られる。[[1](#ref-1)]

光ファイバーケーブルの内部では、コアの屈折率（一般的に約1.46〜1.47）の影響で信号の伝搬速度はさらに落ち、光速の約 **2/3（およそ7割、20万km/s前後）** になる。つまり光ファイバーを使っても、信号は真空中の光速より3割以上遅くなる。[[2](#ref-2)][[3](#ref-3)]

### 1-2. 地球の大きさとPingの下限

「地球の裏側とのネット対戦は技術的にどうにもならない」ことを、数字で確認しておこう。

地球の直径を通る最短ルート（理論上は不可能だが）でも、往復Ping（RTT）の物理的な下限は **約85ms** と計算される。現実的な地球表面の経路（光ファイバーの屈折率＋迂回ルート込み）では、この下限は **約190ms** 以上に跳ね上がる。格闘ゲームで「まともに戦える」とされる上限Pingがおよそ150〜200msであることを考えると、たとえ回線が無限に速くなっても、日本からブラジルとの対戦は快適にならない可能性がある。[[4](#ref-4)]

下表は距離ごとの光速ベースの理論的往復Ping（光ファイバー、屈折率1.46を考慮、伝搬速度約20万km/s）の目安である：[[1](#ref-1)][[2](#ref-2)]

| 区間          | 直線距離       | 理論的RTT下限（光速換算） |
| ----------- | ---------- | -------------- |
| 東京 〜 大阪     | 約500 km    | 約5 ms          |
| 東京 〜 北京     | 約2,100 km  | 約20 ms         |
| 東京 〜 ロンドン   | 約9,600 km  | 約95 ms         |
| 東京 〜 ニューヨーク | 約10,800 km | 約108 ms        |
| 地球の真裏（表面経路） | 約20,000 km | 約190 ms（最短理論値） |

現実のPingはここにルーターの処理時間、パケットの中継ホップ数、輻輳（混雑）などが加わるため、さらに高くなる。光信号は通信基地局やサーバーから **1kmごとに5マイクロ秒（0.005ms）** の遅延が発生するとされている。[[5](#ref-5)][[2](#ref-2)]

### 1-3. なぜ「回線速度（Mbps）」より「Ping（ms）」が大事か

オンラインゲームで実際に送受信するデータ量は、それほど多くない。ほとんどのゲームでは **10Mbps程度** の帯域があれば十分とされる。問題は「どれだけ速くデータが届くか（レイテンシ）」であり、「一度にどれだけ大量に送れるか（帯域幅）」ではない。競技レベルのゲームでは **20ms以下** が理想とされており、50msを超えると体感で差が出始め、100〜200msを超えると操作への反応遅れが明確になる。[[6](#ref-6)][[7](#ref-7)][[8](#ref-8)]

---- 

## 第2章：物理的遅延の構造

### 2-1. レイテンシを構成する4つの要素

通信遅延は「光速の壁」だけではなく、複数の層が積み重なって発生する：

1. **伝搬遅延** （Propagation Delay）：信号が物理的に距離を移動する時間。唯一、技術では原理的に解決できない部分。[[1](#ref-1)]
2. **処理遅延** （Processing Delay）：ルーターやサーバーがパケットを解析し、送り先を決定する時間。[[9](#ref-9)]
3. **キューイング遅延** （Queuing Delay）：パケットが送信待ちで行列に並ぶ時間。ネットワーク混雑時に増加。[[2](#ref-2)]
4. **伝送遅延** （Transmission Delay）：データをケーブルに乗せるのにかかる時間（通常は無視できるレベル）。[[6](#ref-6)]

ゲームの場合、 **サーバーのティックレート** も実効的なレイテンシに影響する。ティックレートとはサーバーがゲーム状態を更新する頻度のことで、例えば64Hzなら約15.6ms、128Hzなら約7.8msごとに状態が更新される。どれほど自分のPingが低くても、次のティックまで待たなければ入力は反映されない。[[10](#ref-10)][[11](#ref-11)]

### 2-2. ジッターとパケットロス

遅延の「大きさ」だけでなく「ばらつき」も問題だ。パケットの到着時間が毎回変動する現象を **ジッター（Jitter）** と呼ぶ。Pingが安定して80msなら慣れで対応できる場合もあるが、40msと120msが不規則に混在すると体感が最悪になる。[[12](#ref-12)]

また、パケットが途中でロスト（消失）する **パケットロス** も深刻だ。ゲームが使うUDPプロトコルは信頼性よりも速度を優先した設計であり、ロストしたパケットの再送を行わない。パケットが届かなければキャラクターの動きが止まり、操作が効かないように見える現象が発生する。[[13](#ref-13)][[14](#ref-14)]

### 2-3. P2P方式と専用サーバー方式の違い

オンライン対戦の通信方式には大きく2つある：

| 比較項目  | P2P（ピアツーピア）           | 専用サーバー（デディケーテッド） |
| ----- | --------------------- | ---------------- |
| ホスト役  | プレイヤーの端末が兼任           | 中立なサーバー機         |
| ホスト有利 | **あり** （ホスト側のPingはほぼ0） | なし               |
| チート耐性 | 弱い（プレイヤーが主導権を持つ）      | 強い（サーバーが権威を持つ）   |
| コスト   | 低い（プレイヤーのリソースを活用）     | 高い（サーバー運営費が必要）   |
| 信頼性   | ホストが回線を切ると崩壊          | ホストの影響を受けにくい     |

出典：[[15](#ref-15)][[16](#ref-16)]

P2P方式では「ホスト有利」と呼ばれる不公平が生じる。接続が切れにくく回線も速いホスト側のプレイヤーは実質的にPingゼロで戦え、他の参加者は一方的に遅延のハンデを背負う。家庭用ゲーム機の初期のオンラインゲームではこの問題が多発し、より公平な専用サーバー方式への移行が進んでいった。[[15](#ref-15)]

---- 

## 第3章：遅延を「隠す」技術

ここからが本レポートの核心だ。物理的な遅延は削減こそできても、ゼロにはできない。そこでゲームエンジニアたちは、遅延があることをプレイヤーに「気づかせない」ための技術を開発した。

### 3-1. クライアントサイド予測（Client-Side Prediction）

最も基本的な遅延隠蔽技術だ。プレイヤーがボタンを押した瞬間、クライアント（手元のゲーム機）はサーバーの返事を **待たずに** 、自分でゲームの結果を計算して画面に表示する。[[17](#ref-17)][[18](#ref-18)]

例えば「右に移動」ボタンを押したとき：

1. クライアントは即座にキャラクターを右に動かして画面を更新する（これが「予測」）
2. バックグラウンドでサーバーに「右に移動した」という入力を送信する
3. サーバーが演算して確定結果を返してきたとき、クライアントの予測と一致していれば何も起きない
4. 予測と一致しなかった場合（ズレが発生）は、サーバーの正しい状態に修正する（ **サーバーリコンシリエーション** ）[[19](#ref-19)][[17](#ref-17)]

この技術により、プレイヤーはPingが50ms〜100msあっても「即座に反応している」ように感じることができる。

### 3-2. ラグ補償（Lag Compensation）—「時間を巻き戻す」技術

FPSゲームで特に重要な技術だ。プレイヤーAがPingを持った状態で敵を照準して射撃したとする。プレイヤーAが「今ここにいる」と見ている敵の位置は、実際には「少し前の状態」だ。[[20](#ref-20)][[10](#ref-10)]

もしサーバーが「射撃した瞬間の現在位置」で判定したら、照準が正しくても当たらない。これは不公平だ。そこでValveのYahn Bernier氏が2001年に体系化・公表した手法では、サーバーは **プレイヤーAのPing分だけ過去に時間を巻き戻し** 、そのときの全プレイヤーの位置でヒット判定を行う。これにより「見えている敵に向けて撃てば当たる」という直感的なゲームプレイが成立する。[[20](#ref-20)]

ただし、この技術にはトレードオフがある。プレイヤーBから見ると、「明らかに隠れ場所に移動した後なのに撃たれた」という体験が発生することがある。レイテンシを気にしなくてよいプレイヤーAが有利になり、Pingが高いプレイヤーBが不利になるという非対称性はどうしても残る。[[10](#ref-10)]

### 3-3. 推測航法（Dead Reckoning）—「動きを予測して補間する」

ネットワークゲームの歴史の中でも長く使われてきた技術で、もともとは航海術の「デッドレコニング（推測位置計算）」に由来する。[[21](#ref-21)][[22](#ref-22)]

基本的な考え方は「次のデータが届くまでの間、最後にわかっている速度・方向で自分の計算でキャラを動かし続ける」というものだ。例えば：[[23](#ref-23)]

- 前回の更新：「敵は時速20kmで北に向かっている」
- 次の更新が来るまでの間、クライアントは勝手に「敵は北に進み続けているはず」と計算して表示する
- 実際のデータが届いたとき、ズレがあれば滑らかに位置を修正（補間）する

補間の方法にも線形補間（直線的に補正）、指数関数的補間（ズレが大きいほど速く修正）など複数の手法がある。Half-Life 2では100msの補間バッファを使用していることで知られる。[[24](#ref-24)][[23](#ref-23)]

### 3-4. ディレイベース方式 vs ロールバック方式（格闘ゲームの場合）

格闘ゲームは通信同期の問題が特に難しいジャンルだ。1フレーム（1/60秒＝約16.7ms）単位の入力が勝敗を分けるため、少しのズレも致命的になる。この問題に対して、2つの異なるアプローチが存在する。

#### ディレイベース方式（Delay-Based Netcode）

従来の方式。双方のPingを考慮して、 **全プレイヤーの入力にあらかじめ遅延（フレーム遅延）を加える** ことで同期を取る。[[25](#ref-25)][[26](#ref-26)]

- ✅ ゲームの整合性が保たれる（全員が同じフレームで同じ状態を見る）
- ❌ 入力遅延がゲームプレイに直接影響する（「もたり感」が生じる）
- ❌ Pingが高いと操作感が著しく悪化する

#### ロールバック方式（Rollback Netcode）

近年の格闘ゲームで主流になりつつある方式。入力遅延を最小限にし、代わりに **予測と巻き戻し** で対処する。[[27](#ref-27)][[28](#ref-28)]

仕組みの流れ：

1. プレイヤーの入力を **即座に画面に反映** する（入力遅延ゼロ）
2. 相手の入力が届いていない場合、「前回と同じ入力だろう」と **予測してゲームを進める**
3. 実際の入力が届いたとき、予測が当たっていれば何もしない
4. 予測が外れていた場合、 **正しい状態に「ロールバック（巻き戻し）」** して再シミュレーションする[[29](#ref-29)][[27](#ref-27)]

- ✅ 自分の操作への反応は即座（入力遅延がほぼない）
- ✅ Ping差が大きい相手とも比較的快適に対戦できる
- ❌ 予測が外れるとキャラクターが突然ワープしたように見えることがある
- ❌ ゲームのシミュレーションが完全に **決定論的（同じ入力→同じ結果）** でなければ機能しない[[27](#ref-27)]

ロールバックネットコード自体は、Tony Cannon氏が2006年に開発した **GGPO（Good Game Peace Out）** によって格闘ゲーム界隈で広く認知された技術だ。実装例としては『Killer Instinct』（2013年）、『Skullgirls』、『MORTAL KOMBAT 11』、『ストリートファイターV』、『ギルティギア ストライヴ』などがある。日本メーカーはロールバック方式の採用がやや遅れていたが、近年は急速に普及している。[[30](#ref-30)][[28](#ref-28)][[26](#ref-26)]

実際の実装では、ディレイとロールバックをハイブリッドで組み合わせる場合が多い。小さな固定フレーム遅延を入れつつ、残りのズレはロールバックで処理することで、両方の弱点を補う。[[25](#ref-25)]

| 比較項目      | ディレイベース    | ロールバック                                                                       |
| --------- | ---------- | ---------------------------------------------------------------------------- |
| 自分の入力遅延   | あり（Ping依存） | ほぼなし                                                                         |
| 相手のワープ感   | 少ない        | Ping差が大きいと発生しやすい                                                             |
| Ping差への耐性 | 弱い         | 強い                                                                           |
| 実装の難易度    | 低い         | 高い（決定論的設計が必須）                                                                |
| 採用例       | 旧世代の格ゲー全般  | Killer Instinct（2013）、Skullgirls、ストリートファイターV、ギルティギア ストライヴ、MORTAL KOMBAT 11 等 |

出典：[[28](#ref-28)][[26](#ref-26)][[27](#ref-27)][[25](#ref-25)]

---- 

## 第4章：ネットワーク通信の基礎

### 4-1. TCPとUDPの使い分け

インターネット通信には大きく2種類のプロトコルがある：

- **TCP** （Transmission Control Protocol）：パケットの到達を保証し、順序も維持する。信頼性は高いが再送制御のオーバーヘッドがある。[[13](#ref-13)]
- **UDP** （User Datagram Protocol）：到達保証なし・順序保証なし。とにかく速い。パケットが消えても再送しない。[[13](#ref-13)]

ゲームジャンル別の適切なプロトコルの目安：[[9](#ref-9)]

| ジャンル      | 推奨プロトコル    | 理由                |
| --------- | ---------- | ----------------- |
| FPS・格闘ゲーム | UDP / RUDP | 速度最優先。古いデータは価値がない |
| MOBA・RTS  | UDP / RUDP | 十分に低レイテンシが必要      |
| MMO・TPS   | RUDP / TCP | 信頼性も重要            |
| ターン制戦略    | TCP        | 速度よりも整合性が重要       |

RUDP（Reliable UDP）は、UDPの速度を維持しつつ、重要なパケットだけ再送確認を追加したハイブリッドプロトコルで、多くのゲームエンジンが採用している。[[13](#ref-13)]

### 4-2. NAT越え（NAT Traversal）の問題

家庭用ゲーム機がP2P接続を行おうとするとき、ほとんどの家庭にはルーター（NAT機器）があり、直接の接続が難しい。この問題を解決するのが **STUN（Session Traversal Utilities for NAT）** と **TURN（Traversal Using Relays around NAT）** だ。[[31](#ref-31)]

- **STUN** ：自分の公開IPアドレスとポートを確認するサーバー。これを使って相手と直接接続できる経路を探す。[[31](#ref-31)]
- **TURN** ：STUNが使えない場合（対称型NATなど）の最終手段。中継サーバーを経由して通信する。TURNは負荷とコストが高く、レイテンシも増える。[[32](#ref-32)]

Nintendo Switchのオンライン機能など、現代のコンソールゲームは多くの場合これらの技術を組み合わせ、できる限りP2P接続を試みながら失敗した場合はリレーサーバーに切り替える。[[33](#ref-33)]

---- 

## 第5章：コンソールオンラインの進化史

### 5-1. ドリームキャストとXbox Liveの衝撃

家庭用ゲーム機にネット対戦機能が本格的に搭載されたのは1998年の **セガ・ドリームキャスト** だ。モデムを標準搭載した初のメジャーコンソールであり、「ネットワークゲームは家庭用機で当たり前に遊べる」という道を拓いた。しかし当時の接続速度（日本仕様は33.6kbps、後に北米向けでは56kbpsモデムを採用）ではできることに限りがあった。[[34](#ref-34)][[35](#ref-35)]

転機となったのは2002年の **Xbox Live** だ。ブロードバンド接続を前提とした統一的なオンラインインフラを提供し、「フレンドリスト」「ボイスチャット」「マッチメイキング」を一元化した。この設計思想は現代のPSNやNintendo Switchオンラインのひな型となった。[[36](#ref-36)]

### 5-2. 現代のコンソールインフラ

PlayStation Network（PSN）やXbox Networkは、現在では世界各地にデータセンターを持ち、プレイヤーを地理的に近いサーバーにマッチングすることで物理的なPingを最小化する設計になっている。Xboxはクラウドゲーミング（Xbox Cloud Gaming）にMicrosoft Azureを活用し、将来的にはゲーム機本体なしでもゲームが動く方向性を強化している。Sonyも2019年にMicrosoft Azureとのクラウドゲーミング技術提携を発表している。[[37](#ref-37)][[38](#ref-38)]

### 5-3. 低軌道衛星通信（Starlink）の可能性

従来の静止軌道衛星（高度36,000km）では、信号が衛星まで往復するだけで **約500〜600ms** もかかりゲームには不向きだった。SpaceXの **Starlink** は高度約550kmの低軌道（LEO）衛星を使用することで、衛星〜地上端末間の片道伝搬を **約1.8ms** （往復で約3.6ms）に抑えることができる。実測のラウンドトリップは現状20〜50ms程度だが、Elon Musk氏は将来的に20ms未満を目標に掲げている。さらに宇宙空間（真空）では光速が光ファイバーより速いため、衛星間レーザー通信を使うと、長距離区間では陸上の光ファイバーより **最大50%** 遅延が小さくなりうるとも指摘されている。地上インフラが整っていない地域や、光ファイバーが通っていない地域にとっては画期的な選択肢となりうる。[[39](#ref-39)][[40](#ref-40)]

---- 

## 第6章：権威サーバーとチート対策

### 6-1. 権威サーバー（Authoritative Server）とは

現代のオンラインゲームの多くは、 **サーバーが唯一の「真実の状態（ソース・オブ・トゥルース）」** を持つ「権威サーバー」方式を採用している。クライアントはあくまで「予測と表示」を担当し、サーバーが「何が起きたか」を最終決定する。[[18](#ref-18)][[16](#ref-16)]

この方式では、悪意あるプレイヤーがクライアントを改ざんして「自分は壁の向こうにいる」「HPが無限だ」といった虚偽の状態を送り込もうとしても、サーバーが「そんなことはありえない」と弾ける。チート対策の基本はここにある。[[41](#ref-41)]

### 6-2. チートと補償技術のトレードオフ

ただし、ラグ補償技術はチートとの境界が曖昧になることがある。「高いPingのプレイヤーが有利になるように見える」現象がその典型だ。高Ping環境のプレイヤーが射撃を行うと、サーバーは「そのプレイヤーが見ていた過去の状態」でヒット判定を行うため、「既に安全な位置に移動したはずなのに当たる」という体験が生じうる。これを「Pingの悪用」として意図的に高レイテンシ状態を作り出すチーターが現れることもあるほどだ。[[10](#ref-10)]

---- 

## まとめ：「見えない努力」が生み出す没入感

オンライン対戦のなめらかな体験は、光速という絶対的な制約の上に、無数の工夫が積み重なって成立している。クライアントサイド予測は「反応の錯覚」を作り出し、デッドレコニングは「動きの滑らかさ」を保ち、ロールバックは「フレーム単位の公平性」を追求する。

ゲームプランナーがネット対戦の設計を考えるとき、最初に問うべきは「このゲームジャンルは何msのレイテンシまで許容できるか」という問いだ。ターン制ストラテジーなら数百msでも問題ないが、格闘ゲームやFPSなら20〜50msが設計の前提になる。[[7](#ref-7)][[6](#ref-6)]

物理的な制約は変えられない。しかし、その制約の中でどれだけプレイヤーに「快適さ」と「公平さ」を感じさせるかが、ネットゲームエンジニアリングの本質であり、いまも進化し続ける最前線である。

---

## References

<a id="ref-1"></a>1. [Theoretical vs real-world speed limit of Ping - Pingdom][1] - In a vacuum, light travels with a speed of 299,792 km/s. In air, pretty close to that. It gets slowe...

<a id="ref-2"></a>2. [Network latencies and speed of light - The ryg blog - WordPress.com][2] - The rule of thumb I learned in university that effective signal transmission speed over both is abou...

<a id="ref-3"></a>3. [[PDF] 光ファイバ通信についての誤解 佐藤 憲史 - 沼津高専](https://user.numazu-ct.ac.jp/\~sato.kenji/Sato2009.pdf) - 光ファイバ内を伝搬する光も石英の屈折率により，. その速度は光速の 7 割程度である．光ファイバ中の光と電. 話線を伝わる電気信号の速度は，ほとんど変わらない． ... “光は光.

<a id="ref-4"></a>4. [Are there any theoretical methods by which international latency ...][3] - A speed-of-light connection around the surface has a minimal ping of (circumference of earth)/(speed...

<a id="ref-5"></a>5. [オンラインゲームでラグが起こる7つの原因とその解決方法は？][4] - 利用しているプロバイダや回線の速度が遅いと、オンラインゲームでラグが発生しやすいです。 ほとんどのオンラインゲームは10Mbpsの通信速度が出ていれば ...

<a id="ref-6"></a>6. [What is Latency? Network Latency Explained & How to Fix It][5] - Gaming represents one of the most latency-sensitive applications. Competitive gamers seek network la...

<a id="ref-7"></a>7. [What is Low Latency? Networking Tech - PubNub][6] - Real-time software, such as video conferencing or online gaming, typically seeks latency under 60 mi...

<a id="ref-8"></a>8. [オンラインゲームで重要な「ping」を解説 - 株式会社エクストリーム][7] - 接続を確認するコマンドが由来の「ping」は応答速度の指標 · pingを左右する最大の要因は「物理的な距離」 · コロナ禍ではping均一化の工夫も ...

<a id="ref-9"></a>9. [ネットワーク ゲームにおけるTCPとUDPの使い分け ｜ PDF - Slideshare][8] - 2017年10月27日、モノビットエンジン勉強会inサイバーコネクトツーにて、中嶋謙互が講演しました「ネットワークゲームにおける TCPとUDPの使い分け」 ...

<a id="ref-10"></a>10. [Lag Compensation in FPS Games: The Hidden Systems Making ...][9] - Lag compensation in FPS games lets you aim directly at enemies despite network latency by "rewinding...

<a id="ref-11"></a>11. [Everything you need to know about tick rate, interpolation, lag ...][10] - Tick rate is the frequency with which the server updates the game state. This is measured in Hertz. ...

<a id="ref-12"></a>12. [Jitter Buffer: Optimising Real-Time Communications - Digital Samba][11] - The jitter buffer collects a steady stream of audio or video packets before playing them out. This c...

<a id="ref-13"></a>13. [ネトゲや配信で使い分けられてるTCPとUDP、RUDPの概念 ... - Qiita][12] - 最初に. 本記事はネットワークゲームに開発を行う前に知っておくべきである TCP と UDP 、 RUDP の違いを勉強し直したものとなります。

<a id="ref-14"></a>14. [Does anyone know why my jitter is like this in game? - Reddit][13] - I tried a Bufferbloat test but it said I have little to no buffer bloat, just high ping. I will freq...

<a id="ref-15"></a>15. [Peer to Peer vs Dedicated Game Server Hosting [Which is Better]][14][14] - P2P game hosting relies on players' devices to both play & host the game, while dedicated server hos...

<a id="ref-16"></a>16. [Authorative dedicated server vs. peer-2-peer for small multiplayer ...][15] - So far I established an authorative dedicated server architecture because (a) many people recommende...

<a id="ref-17"></a>17. [Client-Side Prediction and Server Reconciliation - Gabriel Gambetta][16] - We explored a client-server model with an authoritative server and dumb clients that just send input...

<a id="ref-18"></a>18. [Client-Side Prediction and Server Reconciliation ｜ Web Game Dev][17] - When the server processes an input and sends back the authoritative state, the client compares it to...

<a id="ref-19"></a>19. [Am I understanding client prediction and server reconciliation right?][18] - My understanding of everything is client prediction is just kind of instant feedback for the player ...

<a id="ref-20"></a>20. [Server In-game Protocol Design and Optimization][19] - Lag compensation is a method of normalizing server-side the state of the world for each player as th...

<a id="ref-21"></a>21. [Dead Reckoning: Latency Hiding for Networked Games][20] - Using a predetermined set of algorithms to extrapolate entity behavior, you can hide some of the eff...

<a id="ref-22"></a>22. [Dead reckoning - Wikipedia][21] - Dead reckoning is the process of calculating the current position of a moving object by using a prev...

<a id="ref-23"></a>23. [ブラウザゲームの同期まわりを調べた備忘録 - Zenn][22] - サーバーから届いた確定座標と、クライアント側で予測していた現在地がズレたとき、目的地に近づくほど速度を下げる補間を入れる手法です。自分が作った ...

<a id="ref-24"></a>24. [[PDF] Dead Reckoning Using Play Patterns in a Simple 2D Multiplayer ...](https://pdfs.semanticscholar.org/a916/4d9803b992fbb4178332b3f4735d52264e14.pdf) - Traditional dead reckoning schemes typically predict a player's position linearly by assuming player...

<a id="ref-25"></a>25. [格闘ゲームのロールバック ソシャゲとは違うのよ｜綾鷹 - note][23] - まあ実際はディレイか、ロールバックか、の二択ではなくハイブリットで取り入れることで違和感を極限まで小さくするという使われ方をしているようだ。

<a id="ref-26"></a>26. [格ゲーのオンライン対戦を快適にするロールバック方式と未来予測 ...][24] - 従来はディレイ方式と呼ばれる形のネットコードが使われていました。ディレイは“遅らせる”という意味ですね。攻撃ボタンを押して、ネットワークによる ...

<a id="ref-27"></a>27. [Rollback Netcode in Game Development: How Street Fighter V ...][25] - Rollback netcode is a networking technique designed to minimize the perceived effects of latency in ...

<a id="ref-28"></a>28. [格ゲーのラグを軽減する話題の技術「ロールバック・ネットコード ...][26] - ネットコードは、オンライン対戦時にどうやって通信するかというゲーム側の仕組みのこと。一般的に言うロールバック方式は、先読みで描画することで、従来 ...

<a id="ref-29"></a>29. [Rollback Netcode: What it is & how to use it. - SuperCombo Forums][27] - Rollback netcode describes the implementation of a networking model for games to provide latency-fre...

<a id="ref-30"></a>30. [Explaining how fighting games use delay-based and rollback netcode][28] - If the inputs were incorrect, we perform a rollback, as previously described—the game rewinds to a p...

<a id="ref-31"></a>31. [What is STUN? NAT Traversal for WebRTC - SIPERB][29] - STUN facilitates the discovery of public IP addresses and port mappings, enabling devices behind NAT...

<a id="ref-32"></a>32. [How do Gamess have P2P netcode without requiring players to port ...][30] - Stun and turn servers are one way, combined with upnp to do automatic hole punching for nat traversa...

<a id="ref-33"></a>33. [Best Switch Games You Can Play Online with Friends in 2024][31] - The game uses Nintendo's dedicated server network, which significantly reduces latency compared to p...

<a id="ref-34"></a>34. [ドリームキャスト - Wikipedia][32] - ドリームキャストは家庭用ゲーム機としては事実上セガ最後のゲーム ... インターネットモデムにより本格的なインターネット対戦ゲームが楽しめるほか、ACCESSの ...

<a id="ref-35"></a>35. [家庭用ゲーム機備忘録～ドリキャスの挑戦が通信ゲームを変えた ...][33] - 1 通信技術の向上とモデムの普及が、ゲームを次のフェーズへと移行させた · 2 通信対戦は電話代が高く付いた · 3 モデムを標準搭載したドリームキャストの ...

<a id="ref-36"></a>36. [Xbox network - Wikipedia][34] - The Xbox network, formerly known and commonly referred to as Xbox LIVE, is an online multiplayer gam...

<a id="ref-37"></a>37. [Article : A Brief History of the Console and the Future of Gaming][35] - Xbox Live was a little bit of the future in your hands back then. It was excellent. The Sony PS3 als...

<a id="ref-38"></a>38. [Microsoft to use custom AMD chip for next-gen Xbox, will also be ...][36] - More pertinently for this publication, the Xbox will be available over Microsoft's growing cloud gam...

<a id="ref-39"></a>39. [Starlink to improve latency for competitive online gaming, Musk says][37] - SpaceX CEO Elon Musk plans to reduce the latency on Starlink, the company's satellite internet netwo...

<a id="ref-40"></a>40. [[PDF] IMPROVING STARLINK'S LATENCY](https://starlink.com/public-files/StarlinkLatency.pdf) - Our WiFi latency has been improved, with the addition of active queue management, fq\_codel, to the S...

<a id="ref-41"></a>41. [情報学広場：情報処理学会電子図書館][38] - ここで，チート対策はゲームユーザーが信頼できない可能性があるためにクライアントだけで完結させることはできず，ゲームサーバーにおいても行う必要がある ...


[1]:	https://www.pingdom.com/blog/theoretical-vs-real-world-speed-limit-of-ping/
[2]:	https://fgiesen.wordpress.com/2018/01/20/network-latencies-and-speed-of-light/
[3]:	https://www.reddit.com/r/AskPhysics/comments/10vvsza/are_there_any_theoretical_methods_by_which/
[4]:	https://www.nuro.jp/article/onlinegamelag/
[5]:	https://pacgenesis.com/what-is-latency/
[6]:	https://www.pubnub.com/guides/whats-so-important-about-low-latency/
[7]:	https://www.e-xtreme.co.jp/topics/48839/
[8]:	https://www.slideshare.net/slideshow/tcpudp-81497235/81497235
[9]:	https://outscal.com/blog/lag-compensation-in-fps-games-the-hidden-systems-making-your-shots-count
[10]:	https://www.reddit.com/r/Overwatch/comments/3u5kfg/everything_you_need_to_know_about_tick_rate/
[11]:	https://www.digitalsamba.com/blog/jitter-buffers-optimising-real-time-communications
[12]:	https://qiita.com/4_mio_11/items/cd3efe0345eee75c3ae2
[13]:	https://www.reddit.com/r/Network/comments/1r6utvg/does_anyone_know_why_my_jitter_is_like_this_in/
[14]:	https://www.servers.com/blog/differences-between-peer-to-peer-and-dedicated-game-server-hosting
[15]:	https://www.reddit.com/r/gamedev/comments/1apz6ok/authorative_dedicated_server_vs_peer2peer_for/
[16]:	https://www.gabrielgambetta.com/client-side-prediction-server-reconciliation.html
[17]:	https://www.webgamedev.com/backend/prediction-reconciliation
[18]:	https://www.reddit.com/r/gamedev/comments/13hv8mx/am_i_understanding_client_prediction_and_server/
[19]:	https://developer.valvesoftware.com/wiki/Latency_Compensating_Methods_in_Client/Server_In-game_Protocol_Design_and_Optimization
[20]:	https://www.gamedeveloper.com/programming/dead-reckoning-latency-hiding-for-networked-games
[21]:	https://en.wikipedia.org/wiki/Dead_reckoning
[22]:	https://zenn.dev/yoshi333/articles/65e8c28442af50
[23]:	https://note.com/karakuri_game/n/n54399248d7d6
[24]:	https://www.inside-games.jp/article/2022/05/22/138312.html
[25]:	https://www.daydreamsoft.com/blog/rollback-netcode-explained-building-smooth-multiplayer-experiences-inspired-by-street-fighter-v
[26]:	https://kakuge-checker.com/topic/view/07248/
[27]:	https://forums.supercombo.gg/d/28-rollback-netcode-what-it-is-how-to-use-it
[28]:	https://arstechnica.com/gaming/2019/10/explaining-how-fighting-games-use-delay-based-and-rollback-netcode/
[29]:	https://www.siperb.com/kb/what-is-stun/
[30]:	https://www.reddit.com/r/gamedev/comments/12lu9c5/how_do_gamess_have_p2p_netcode_without_requiring/
[31]:	https://www.aliexpress.com/s/wiki-ssr/article/switch-games-you-can-play-online-with-friends
[32]:	https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%AA%E3%83%BC%E3%83%A0%E3%82%AD%E3%83%A3%E3%82%B9%E3%83%88
[33]:	https://yourclip.life/post/20200427game/
[34]:	https://en.wikipedia.org/wiki/Xbox_network
[35]:	http://seasonedgaming.com/2020/02/09/article-a-brief-history-of-the-console-and-the-future-of-gaming/
[36]:	https://www.datacenterdynamics.com/en/news/microsoft-to-use-custom-amd-chip-for-next-gen-xbox-will-also-be-deployed-on-the-cloud/
[37]:	https://mashable.com/article/starlink-latency-improves-online-gaming
[38]:	https://ipsj.ixsq.nii.ac.jp/records/210125
