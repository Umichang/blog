# コントローラーの振動とハプティックフィードバック――ゲームプランナーのための企画設計ガイド

## はじめに

コントローラーを握ったとき、画面や音だけでなく「手のひらで感じる何か」が、ゲーム体験の深度を大きく左右する。雨粒がぱらぱらと降り注ぐ感触、引き金を引いた瞬間の重い反動、敵の攻撃が左側から来ることを告げる微細な振動――これらはすべて、 **触覚フィードバック（ハプティクス）** が担う体験設計の領域だ。

本稿では、Xbox ワイヤレス コントローラーの振動機構とPlayStation 5（PS5）のDualSense ワイヤレスコントローラーが実現するハプティックフィードバックの技術的背景を整理し、実際のゲームタイトルにおける優れた活用事例を分析したうえで、ゲームプランナーが企画書や仕様書に落とし込む際の思考フレームを提示する。

***

## 1. ハプティクスの技術的基盤

### 1-1. 振動から触覚表現へ：モーターの進化

コントローラーの振動は、ゲーム史において長く「エキセントリック・ローテーティング・マス（ERM）モーター」に頼ってきた。回転する重りが遠心力で筐体全体を揺らす方式であり、「大きく揺れるか、小さく揺れるか」という二値的な表現にとどまっていた。[[1](#ref-1)]

これに対して現代のコントローラーが採用するのは **LRA（リニア共振アクチュエータ）** だ。スプリングに吊るされた小さな錘が電気信号によって直線的に往復運動し、回転ではなく直線振動を生成する。この方式は周波数と強度の両軸を精密に制御できるため、テクスチャの質感差（砂、泥、金属など）や衝撃の方向性まで表現可能になった。さらに最新のハプティクスシステムは、スピーカーやヘッドフォンと同じ動作原理で機能するため、サウンドデザインで培われた波形操作の技法がそのまま触覚設計に転用できる。[[2](#ref-2)][[3](#ref-3)][[1](#ref-1)]

### 1-2. Xbox コントローラーのインパルス トリガー

マイクロソフトは2013年のXbox One コントローラー発表において、 **インパルス トリガー** を導入した。これはグリップ部の従来型ラージモーター・スモールモーターに加え、LT・RTトリガーの内部にも独立した小型バイブレーションモーターを組み込んだ設計だ。[[4](#ref-4)][[5](#ref-5)]

トリガーは人差し指が直接触れる最も感度の高い部位であり、ここで生じる振動は手のひら全体の振動とは質的に異なるフィードバックをプレイヤーに与える。射撃の反動、ブレーキの感触、エンジンのトルク変動といった「指先の物理」を伝えるのに適した構造となっている。LT・RT（左右トリガー）の独立制御が可能であるため、左右非対称なフィードバックも実装できる。[[5](#ref-5)][[6](#ref-6)][[4](#ref-4)]

### 1-3. DualSense ワイヤレスコントローラーのハプティックフィードバック

PS5のDualSense ワイヤレスコントローラーは、左右グリップにそれぞれ1基ずつボイスコイル型アクチュエータ（広義のLRA）を内蔵する。古典的なLRAが単一の共振周波数を中心に動作するのに対し、DualSense ワイヤレスコントローラーのアクチュエータはスピーカーと同様に広帯域の波形を再現できる点が特徴だ。左右独立した動作によって、振動の「空間的方向性」をコントローラーの物理的位置に対応づけることが可能だ。ソニーのエンジニアリングチームはこの設計を「ステレオ音声のような立体的振動」と表現している。[[7](#ref-7)][[2](#ref-2)]

さらにDualSense ワイヤレスコントローラーには **アダプティブトリガー** が搭載されている。これはLRAとは別機構であり、L2・R2ボタンに物理的な抵抗力を加えるアクチュエータだ。弓を引く張力、引き金を絞り込む重さ、銃の安全装置が解除される感触など、押し込む行為そのものに触感を付加できる。この機構は振動ではなく「力覚」であり、ハプティクスの中でも運動覚（キネスセティック）フィードバックの領域に属する。[[8](#ref-8)][[2](#ref-2)]

***

## 2. 優れた活用事例の分析

### 2-1. 『Returnal』――設計哲学の完成形

Housemarqueが開発し、ソニー・インタラクティブエンタテインメントが販売した『Returnal』（リターナル、2021年）は、DualSense ワイヤレスコントローラーを活用した最良の教科書といえる作品だ。同作のハプティクス設計は、PlayStation Studios Creative Services Groupのサウンドデザイナー、Harvey Scottが主導した。[[3](#ref-3)]

DualSense ワイヤレスコントローラーのアクチュエータがスピーカーと同じ原理で動作することに着目したScottは、「サウンドデザインと同じ原則と技法をハプティクス体験の創造に応用できる」と述べている。この視点は後述する「サウンド担当者が実装する」という実務的慣習の根拠でもある。[[9](#ref-9)][[3](#ref-3)]

同作のハプティクス設計は、大きく3つの柱に整理されている。[[3](#ref-3)]

**①没入（Immersion）**：雨粒の落下がランタイムでプロシージャル生成されたハプティクスパルスとして補完される。降雨の強弱に応じてリアルタイムで振動パターンが変化し、映像・音声・触覚が三位一体となって「雨の中に立っている」という錯覚を生む。セレーネがダッシュした際にコントローラーの対応する側（右ダッシュなら右手側）がより重く感じられる設計も、移動感覚の身体的接地を強化する。[[9](#ref-9)][[3](#ref-3)]

**②コミュニケーション（Communication）**：オルトファイア能力がリチャージ完了したとき、独特のハプティクスパルスがプレイヤーに通知する。激しい戦闘中にも「パブロフの犬」的な条件反射でプレイヤーが反応できるよう設計されており、視覚・音声に加えた三重のフィードバックとして機能する。寄生生物の攻撃も「触手が締め付けるような」振動パターンで他のダメージと明確に区別される。[[3](#ref-3)]

**③力感のダイナミクス（Power）**：全体的なハプティクス強度を抑えめに保ち、最大級の武器使用時や強大な敵との遭遇時にのみ最高強度の振動を解放する。「常に強振動」ではメリハリが失われるため、意図的な「ダイナミックレンジの管理」がデザイン原則として採用された。[[3](#ref-3)]

### 2-2. 『ASTRO's PLAYROOM』――ハプティクスの図鑑

PS5に無償でプリインストールされているTeam ASOBIの『ASTRO's PLAYROOM』は、DualSense ワイヤレスコントローラーの機能を網羅的に体験できるリファレンスタイトルとして設計された。[[10](#ref-10)]

同作はハプティクスとアダプティブトリガーの組み合わせで、「砂の上を歩く」「雪を踏みしめる」「スプリングで弾む」「水に飛び込む」など、地形ごとに異なる触感を実装している。プレイヤーは同じ「歩行」というアクションでも、地面の素材によって手のひらで受け取る情報が変わることを体験的に学ぶ。これはゲームプランナーにとって「ハプティクスが伝えられること・伝えられないこと」を理解するための最適な実習素材でもある。[[11](#ref-11)][[10](#ref-10)]

### 2-3. 『Horizon Forbidden West』――地形の触覚マッピング

Guerrilla Gamesの『Horizon Forbidden West』（2022年）では、アーロイが草むらに身を潜める際に「長い草の葉が触れる感触」をDualSense ワイヤレスコントローラーで表現している。スタジオディレクターのAngie SmetsはWiredの取材で、ステルス時に長い草に分け入ると草の葉の感触を感じ取れると語っている。同作では草むらでの潜伏、着地、水中での泳ぎといった特定の状況に応じてハプティクスが使い分けられており、『ASTRO's PLAYROOM』のように歩行・走行で常時振動させるのではなく、効果的な場面に絞り込む設計が採られている。弓を引く際のアダプティブトリガーの張力増加も、弓術ゲームプレイに物理的リアリティを与える事例として広く評価されている。[[12](#ref-12)][[13](#ref-13)]

### 2-4. 『The Last of Us Part I』――アクセシビリティとしてのハプティクス

Naughty Dogが2022年に発売した『The Last of Us Part I』では、 **ダイアログをDualSense ワイヤレスコントローラーのハプティクスとして再生する** 機能が実装された。ゲームディレクターのMatthew Gallantは「聴覚障害のあるプレイヤーが、字幕とともに台詞の抑揚や強調を身体で感じ取れる」ことを狙いとして説明している。これはハプティクスが純粋な演出効果を超え、 **情報アクセシビリティの手段** として機能する先進的な事例だ。[[14](#ref-14)][[15](#ref-15)]

### 2-5. Nintendo SwitchのHD振動――『1-2-Switch』の衝撃

任天堂はNintendo SwitchのJoy-ConにHD振動を搭載した。その技術的根拠となったデモが、ミニゲーム集『1-2-Switch』に収録された「ボールの数を当てる」ミニゲームだ。プレイヤーはJoy-Conを箱のように振り、内部で転がるボールの数と重さを振動のみで判断する。[[16](#ref-16)][[17](#ref-17)]

任天堂の発表によれば、この表現を実現したのはリニアバイブレーションモーターが生み出す「極めて精密な振動の差異」だ。同様の原理により、氷の入ったグラスに水が注がれる感触、複数の氷が移動する感覚なども実現できる。さらに開発者インタビューによれば、HD振動はゲームのSE（効果音）データを入力するだけでその波形パターンをそのまま振動に変換できる設計となっており、音の波形と振動波形を統一的に扱える点で、サウンドデザイナーにとっての実装コストが極めて低い。[[18](#ref-18)][[19](#ref-19)][[17](#ref-17)]

Nintendo Switch 2（2025年）のJoy-Con 2では、HD振動2としてこの精度がさらに向上している。任天堂は最大振動時の音量が初代Joy-Conより低減されたとしており、あるメディアの計測では最大振動時に平均約6dBの低減が報告されている。周波数レンジも拡大し、雨粒の落下や遠方の足音など繊細な触感表現が可能になった。[[20](#ref-20)]

***

## 3. ゲームプランナーのための企画設計フレームワーク

### 3-1. ハプティクスが担える4つの機能

ゲームプランナーが企画書に落とし込む際、ハプティクスが果たせる機能を以下の4軸で整理すると有用だ。[[21](#ref-21)][[22](#ref-22)]

| 機能 | 目的 | 実例 |
|------|------|------|
| **没入強化** | 世界の物理リアリティを身体的に補完する | 地面素材ごとの歩行振動（Horizon Forbidden West）、雨粒の降下（Returnal） |
| **情報伝達** | HUDや音に依存せずプレイヤーに状況を知らせる | 能力リチャージ通知（Returnal）、方向別被弾（Returnal） |
| **感情強調** | 重要なシーンのインパクトを増幅する | 大技発動時の最大強度振動、シネマティクスの没入 |
| **アクセシビリティ** | 視聴覚情報を触覚に変換する | 台詞ハプティクス（The Last of Us Part I）、被弾方向通知 |

### 3-2. 企画提案時に盛り込むべき要素

**（1）ハプティクス語彙の設計**

ゲーム全体で使用するハプティクスに「共通語彙（パレット）」を定義することが重要だ。例えば「金属製の物体に触れると必ず特定の振動パターンが返る」という一貫性があれば、プレイヤーはプレイを通じて無意識のうちにその意味を学習する。企画書には「素材Aの振動特性」「ダメージ種別ごとの振動設計」など、ハプティクスの分類表を含めることが望ましい。[[22](#ref-22)]

**（2）ダイナミックレンジの管理**

最大強度を常用しない設計が、ハプティクス体験の質を決定づける。Meta Haptics Studioのデザインガイドラインでも「Less is More」が原則とされており、重要な瞬間のためにクライマックスの強度を温存することが推奨される。企画フェーズでは「Sレベル（ボス戦最強攻撃）」「Aレベル（通常戦闘）」「Bレベル（環境フィードバック）」のような強度ヒエラルキーを設定し、各イベントをどのレベルに割り当てるかを明示する。[[21](#ref-21)]

**（3）視覚・音声との同期設計**

ハプティクスは独立したチャンネルではなく、映像・音声との多感覚統合体験の一部として機能する。企画書にはゲームイベントごとに「どの感覚モダリティが何を担当するか」を表形式で整理するとよい。例えば「発砲」というイベントであれば、映像（フラッシュ）・音声（銃声）・ハプティクス（反動振動）・アダプティブトリガー（引き抵抗）の4チャンネルがどう連携するかを設計する。[[23](#ref-23)]

**（4）ユーザー設定の提供**

ハプティクスに対する感度には個人差が大きく、また触覚過敏・身体的制約を持つプレイヤーへの配慮も必要だ。Insomniac Gamesは自社タイトルにおいてハプティクスを「エクスペリエンシャル（全ハプティクス有効）」と「ファンクショナル（情報伝達ハプティクスのみ）」の2段階で提供している。企画段階から「どのハプティクスは情報伝達上必須で、どれは演出的付加価値か」を区別しておくと、設定画面の設計が容易になる。[[22](#ref-22)][[21](#ref-21)]

**（5）「消えても遊べる」設計を担保する**

ハプティクスを完全にオフにしたとき、ゲームとして成立することを確認する設計チェックリストを設けること。情報伝達の重要な部分をハプティクスのみに依存させると、アクセシビリティ上の問題が生じる。代替となる視覚・音声フィードバックを必ずペアで設計することが原則だ。[[21](#ref-21)]

### 3-3. ゲームジャンル別の活用方向性

| ジャンル | 効果的な活用例 | 注意点 |
|---------|--------------|-------|
| **アクション/シューター** | 銃の反動・被弾方向・大技の力感 | 過剰な振動による疲労に注意 |
| **アドベンチャー/探索** | 環境テクスチャ・天候・足音素材 | 静かな場面で突然の強振動を避ける |
| **レーシング** | タイヤのグリップ感・縁石通過・ブレーキロック | 操作系との一体感が鍵 |
| **パズル/インタラクション** | 鍵を回す手応え・スイッチの確認 | 正答時の報酬感として活用 |
| **ホラー** | 恐怖の予兆通知・心臓音・寄生生物の締め付け | 意表を突くタイミングが効果的 |
| **音楽/リズム** | 拍のビート・楽器の質感差 | 音楽と同期したLRA制御が必要 |

***

## 4. 実装の実務と「サウンド担当者が実装する」理由

### 4-1. サウンドデザイナーが担う実装作業

ハプティックフィードバックの実装は、多くのスタジオにおいてサウンドデザイナーまたはオーディオ実装担当者（Audio Implementer）が担当する。この慣習は技術的な必然性に由来する。

DualSense ワイヤレスコントローラーのアクチュエータは電気信号によって駆動されるが、その動作原理はスピーカーやヘッドフォンと同じだ。DualSense ワイヤレスコントローラーのハプティクスAPIは、本質的にオーディオ信号（PCM波形）を直接アクチュエータに送ることができる設計になっており、サウンドデザイナーが慣れ親しんだDAW（Digital Audio Workstation）や波形操作の技術が直接応用できる。『Returnal』のHarvey Scottは、「サウンドデザインに使うのと同じ原理と技術を、ハプティクス体験の創造に応用できる」と明言している。[[18](#ref-18)][[9](#ref-9)][[3](#ref-3)]

さらに実務的なワークフローとして、WwiseやFMODといったゲームオーディオミドルウェアがハプティクスのネイティブサポートを拡充している。GDC 2024ではサウンドデザイナーがWwiseを使ったハプティクス実装フローを解説しており、サウンドアセットとハプティクスアセットを同一のイベントシステムで管理できることを示した。Metaも2025年12月、Meta Haptics StudioとFMOD/Wwiseを連携させるワークフローを発表している（FMOD対応は提供済み、Wwise統合は2026年第1四半期に出荷予定）。[[24](#ref-24)][[22](#ref-22)]

また任天堂のHD振動では「SEとして用意した音声ファイルを入力するだけで、その波形パターンをそのまま振動に変換できる」という設計思想が採用されており、サウンドデザイナーが音と振動を一括して管理できる体制が意図的に構築されている。[[18](#ref-18)]

### 4-2. プランナーはどう関わるべきか

実装の主体がサウンドチームであったとしても、「何を振動させるか」「どのタイミングでどの強度にするか」という設計意図の源泉はプランナーにある。企画書にハプティクスの「意図と機能」を明示することで、サウンドデザイナーが実装の判断を下す際の指針となる。

具体的には以下の項目を企画ドキュメントに記載することが望ましい。

- 全ゲームイベントの一覧と、それぞれに期待するハプティクス体験の記述
- 強度ヒエラルキー（S/A/B/Cなどのレベル分類）
- 情報伝達ハプティクスと演出ハプティクスの区別
- アクセシビリティ要件（最低限保持すべきハプティクスの定義）
- テストプレイ時の評価基準（「この振動で武器の違いが感じ取れるか」など）

***

## コラム：コントローラー以外のデバイスにおけるハプティクス

### シミュレータ用フォースフィードバックホイール

レーシングシム専用ハードウェアとして広く普及しているフォースフィードバックステアリングホイールは、ゲームが出力するテレメトリデータ（速度・コーナリング荷重・路面状況など）をリアルタイムにモーターの抵抗力に変換する。ゲームエンジンが現在の車速・スリップ率・縁石への乗り上げ量といった物理パラメータをホイールのSDKに送信し、それを駆動電流に翻訳する仕組みだ。Fanatec、ロジクールなどのメーカーはそれぞれのSDKを提供しており、ゲーム側の実装コストはテレメトリ出力のサポートに限定される。シム向けの上位モデルにはステアリングホイール本体のフォースフィードバックに加え、シートに取り付けるバスシェイカー（低周波振動トランスデューサー）との組み合わせで、全身振動フィードバックを実現するリグも存在する。[[25](#ref-25)][[26](#ref-26)]

### ハプティクスベスト（全身ハプティクス）

VRゲームの没入感をさらに高めるデバイスとして、bHaptics社のTactSuitなどの全身用ハプティクスベストが市販されている。X40モデルは40点の独立した振動アクチュエータを背面・胸部に配置しており、被弾位置を身体の左右・上下で区別して伝えることができる。Teslasuit（Tesla Studio）はさらに高価格帯の製品で、電気刺激（EMS）によって実際に筋肉を収縮させる感覚を生成する機能を持つ。これらのデバイスはゲームとのAPIインテグレーションが前提であり、実装には専用SDKへの対応が必要だ。一般的な家庭向け消費者製品としての普及率はまだ低いため、現時点ではVRアーケード・業務用シミュレータ・医療・軍事訓練向けの用途が中心となっている。[[27](#ref-27)][[28](#ref-28)]

### Nintendo Laboとインタラクティブカードボード

任天堂のNintendo Labo（2018年）は、Joy-ConのHD振動を段ボール製の手作りおもちゃに組み合わせることで、HD振動の触感を物理的なオブジェクトの振動へと間接的に伝達する試みだった。ルアー釣りキット（釣り竿型の段ボール構造物を経由して魚の引きをJoy-Conの振動で伝える）や、ピアノキット（鍵盤ごとに音高が異なる振動パターンを返す）など、HD振動の精密な周波数制御を物理オブジェクトと連動させた設計は、インタラクションデザインの観点から評価が高い。[[17](#ref-17)]

***

## おわりに：プランナーが「触覚の設計者」になる

ハプティックフィードバックはかつて「あれば嬉しいオプション」だったが、DualSense ワイヤレスコントローラーの登場以降は「ゲームデザインの構成要素」として本質化しつつある。プランナーは視覚・音声と同じレベルの解像度でハプティクスを企画に織り込む必要があり、「振動をつける」という指示だけでなく「何を伝えるために、どの強度で、他の感覚モダリティとどう連携させるか」を記述する責務を持つ。

実装の手を動かすのはサウンドチームであっても、触覚体験の意図を定義するのはプランナーの役割だ。画面の向こう側にある世界を、プレイヤーの手のひらにまで届ける設計者として、ハプティクスという語彙を自らのデザインツールボックスに加えることを強く推奨する。

---

## References

<a id="ref-1"></a>1. [How haptic feedback immerses us in games - HAPTICORE][1] - Haptic feedback can simulate real-world sensations such as vibrations, force, and movement, which ma...

<a id="ref-2"></a>2. [DualSense: understanding haptic feedback and adaptive triggers on ...][2] - Discover how the PS5 DualSense leverages haptic feedback and adaptive triggers to deliver immersive ...

<a id="ref-3"></a>3. [How Housemarque created Returnal's immersive DualSense ...][3] - In Returnal our goal was to use the DualSense wireless controller to provide a physical experience o...

<a id="ref-4"></a>4. [Xbox One Impulse Triggers Demo By Microsoft Quintin Morris][4] - After the Xbox Reveal, Microsoft demonstrated the new Xbox One controllers. Check out the Impulse Tr...

<a id="ref-5"></a>5. [Impulse Trigger · Issue #34 · speps/XInputDotNet - GitHub][5] - If you are using Xbox One controller, you will feel vibration just on the trigger since the Impulse ...

<a id="ref-6"></a>6. [Impulse Trigger vs Rumble Motors: Force Feedback Differences][6] - Impulse triggers use motorized resistance in the trigger mechanism, while rumble motors vibrate the ...

<a id="ref-7"></a>7. [DualSense - How are developers using haptic feedback in the PS5 ...][7] - In April, Sony announced the DualSense would heighten players feeling of immersion with the use of h...

<a id="ref-8"></a>8. [Taking on New Challenges with Haptics—A Technology that ... - Sony][8] - With two new features, haptic feedback and adaptive triggers, DualSense is able to offer more realis...

<a id="ref-9"></a>9. [PS5™『Returnal』(リターナル)の圧倒的没入感を実現した ...][9] - それはつまり、サウンドデザイナーの私にとっては、サウンドデザインに使われる同じ原理と技術を、興味深いハプティックフィードバック体験の創造に応用 ...

<a id="ref-10"></a>10. [Unleash the power of the DualSense wireless controller with Astro's ...][10] - The game was created from the ground up as a showcase for the DualSense wireless controller, taking ...

<a id="ref-11"></a>11. [Astro's Playroom: The Ultimate PS5 Feature Demonstration][11] - One of the standout features of the PS5 is the DualSense controller, which introduces advanced hapti...

<a id="ref-12"></a>12. [Horizon Forbidden West Will Let Players 'Feel' The Grass via ...][12] - Haptic technology allows the PlayStation controller to alter the amount of tension ...

<a id="ref-13"></a>13. [Twang! Horizon Forbidden West on PC keeps PS5 Dualsense ...][13] - Proper support for PS5 Dualsense controllers, which means you should be able to benefit from all the...

<a id="ref-14"></a>14. [Last of Us Part 1 accessibility features include ability to play ...][14] - This includes a new feature that will enable players to play dialogue through the console's DualSens...

<a id="ref-15"></a>15. [The DualSense will let you 'feel' dialogue in The Last of Us PS5 ...][15] - New in The Last of Us Part 1 is “a feature that plays dialogue through the PS5 DualSense controller ...

<a id="ref-16"></a>16. [Games that used the HD rumble in a creative way? : r/NintendoSwitch][16] - The one mini game that comes to mind is the acorn box one where you use the HD rumble to determine w...

<a id="ref-17"></a>17. [Nintendo Reveals The Secret Behind The Joy-Con's HD Rumble][17] - One of the games that players have been amazed by the HD Rumble effect is 1-2 Switch's “Count Balls”...

<a id="ref-18"></a>18. [HD Rumble Tools Allow Developers To Easily ... - NintendoSoup][18] - Nintendo's HD Rumble was surprisingly easy to implement and that they could just use any sound effec...

<a id="ref-19"></a>19. [The Potential of HD Rumble for Atmosphere Creation on ... - Viewout][19] - A more extreme example, you could also compare the idea of what a jump might possibly feel like with...

<a id="ref-20"></a>20. [Joy‑Con 2 and the Next‑Level HD Rumble - NintendoReporters][20] - Nintendo's Joy-Con 2 ushers in a quieter yet more exact form of HD Rumble, trimming excess vibration...

<a id="ref-21"></a>21. [Designing Haptics ｜ Meta Horizon OS Developers][21] - Meta Haptics Studio for Mac and PC provides a design front-end to quickly generate custom haptics fr...

<a id="ref-22"></a>22. [Haptic Feedback 101 & Practical Applications in Wwise ｜ GDC 2024][22] - What is haptic feedback, and how can it elevate gaming experiences? In this video, sound designers R...

<a id="ref-23"></a>23. [Get in the Game: The Impact of Spatial Audio and Haptic Feedback ...][23] - In this article, we will explore the impact of spatial audio and haptic feedback on video game desig...

<a id="ref-24"></a>24. [Meta Haptics Studio Meets FMOD and Wwise - Meta for Developers][24] - Bring audio and haptics together in one workflow. Learn how sound designers can use Meta Haptics Stu...

<a id="ref-25"></a>25. [Why is Force Feedback Different in Sim Racing Games - Fanatec][25] - Force feedback mimics the real forces you can feel when driving a car. Older force feedback wheel ba...

<a id="ref-26"></a>26. [How to add feedback transducers (bass shakers) to your sim-racing rig][26] - The tried and trusted method of introducing haptic feedback to a rig is to install bass shakers (tac...

<a id="ref-27"></a>27. [bHaptics Tactsuit X40 ｜ Advanced Haptic Vest - Knoxlabs][27] - A cutting-edge wireless haptic suit featuring 40 precise haptic feedback points in an ergonomic desi...

<a id="ref-28"></a>28. [Battle of the Haptic Suits (Teslasuit vs bHaptics) - MXTreality][28] - A Haptic suit is a suit that utilizes the sense of touch, vibration and physical contact. This can f...

[1]: https://www.xeeltech.com/haptics-in-gaming/
[2]: https://blog.son-video.com/en/2024/05/dualsense-understanding-haptic-feedback-and-adaptive-triggers-on-the-ps5-controller/
[3]: https://blog.playstation.com/2021/05/13/how-housemarque-created-returnals-immersive-dualsense-controller-effects/
[4]: https://www.youtube.com/watch?v=gFeEe9SgXvg
[5]: https://github.com/speps/XInputDotNet/issues/34
[6]: https://evezone.evetech.co.za/deep-dives/impulse-trigger-vs-rumble-motors-force-feedback
[7]: https://techstomper.com/dualsense-how-are-developers-using-haptic-feedback-in-the-ps5-controller/
[8]: https://www.sony.com/en/SonyInfo/technology/stories/entries/Haptics/
[9]: https://blog.ja.playstation.com/2021/05/13/20210513-returnal/
[10]: https://blog.playstation.com/2020/11/11/unleash-the-power-of-the-dualsense-wireless-controller-with-astros-playroom/
[11]: https://retrovgames.com/astros-playroom-the-ps5-feature/
[12]: https://gamerant.com/horizon-forbidden-west-feel-grass-dualsense-haptic-feedback-ps5/
[13]: https://www.rockpapershotgun.com/twang-horizon-forbidden-west-on-pc-keeps-ps5-dualsense-support-and-adaptive-triggers
[14]: https://www.eurogamer.net/last-of-us-part-1-accessibility-features-include-ability-to-play-dialogue-through-dualsense-as-haptic-feedback
[15]: https://www.polygon.com/23323264/last-of-us-part-1-ps5-accessibility-features-video-dualsense-controller/
[16]: https://www.reddit.com/r/NintendoSwitch/comments/suww6w/games_that_used_the_hd_rumble_in_a_creative_way/
[17]: https://nintendosoup.com/nintendo-reveals-secret-behind-joy-cons-hd-rumble/
[18]: https://nintendosoup.com/hd-rumble-tools-allow-developers-to-easily-create-rumble-from-sound-effects/
[19]: https://viewout.net/2017/12/02/article/The-Potential-of-HD-Rumble-for-Atmosphere-Creation-on-the-Nintendo-Switch
[20]: https://www.nintendoreporters.com/en/news/nintendo-switch-2/joycon2-and-the-nextlevel-hdrumble-quiet-precision-for-nintendo-switch2/
[21]: https://developers.meta.com/horizon/documentation/unreal/unreal-haptics-design-guidelines/
[22]: https://www.youtube.com/watch?v=A3XLCMyJaDQ
[23]: https://www.linkedin.com/pulse/get-game-impact-spatial-audio-haptic-feedback-video-design-semih-alar-u2rdf
[24]: https://developers.meta.com/horizon/blog/meta-haptics-studio-meets-fmod-wwise/
[25]: https://www.fanatec.com/eu/en/explorer/products/racing-wheels-wheel-bases/force-feedback-different-in-games/
[26]: https://sinclairdesign.com/blog/sim-racing-haptic-feedback
[27]: https://www.knoxlabs.com/products/tactsuit-x40-vr-haptic-suit
[28]: https://www.mxtreality.com/post/battle-of-the-haptic-suits-teslasuit-vs-bhaptics

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
