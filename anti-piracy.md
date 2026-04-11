# 任天堂 歴代ハードウェア 海賊版・未承認ソフト対策 総合レポート

## エグゼクティブサマリー

任天堂は1983年のファミリーコンピュータ発売以来、40年以上にわたり海賊版・未承認ソフト対策を進化させてきた。初期のハードウェアロックアウトチップ（10NES/CIC）から始まり、物理メディアの独自仕様化、ソフトウェアレベルでの巧妙な検知、暗号化技術の高度化、そしてオンラインサーバーサイド認証へと、対策は世代を重ねるごとに多層化・高度化している。本レポートでは、NES/ファミコンからNintendo Switchまでの全9プラットフォームにおけるハードウェア・ソフトウェア両面のアンチパイラシー技術を体系的に分析する。

---

## 時系列比較表

![Nintendo Anti-Piracy Timeline][image-1]

| 世代   | ハード      | 発売年     | 主要ハードウェア対策            | 主要ソフトウェア対策            | 代表的事例                    |
| ---- | -------- | ------- | --------------------- | --------------------- | ------------------------ |
| 第3世代 | NES/FC   | 1983/85 | 10NES (CIC) ロックアウトチップ | 限定的チェックサム             | Batman Returns: ダメージ倍増   |
| 第4世代 | SNES/SFC | 1990/91 | CICチップ改良版 + SRAM検知    | 多層コピープロテクション          | EarthBound: 5層防御         |
| 第5世代 | N64      | 1996    | CIC + PIF バス認証        | CICチャレンジ・レスポンス暗号化     | スマブラ: 69回起動で全員マリオ        |
| 第6世代 | GameCube | 2001    | miniDVD + BCA物理マーキング  | ディスクID検証              | BCA偽造不可能設計               |
| 携帯機  | DS       | 2004    | カートリッジ認証              | APチェック（多数のゲーム）        | ポケモンBW: 赤外線通信チェック        |
| 第7世代 | Wii      | 2006    | 独自光ディスク + IOS暗号化      | FWアップデート + HBC削除      | System Menu 4.3: HBC自動削除 |
| 携帯機  | 3DS      | 2011    | AES暗号化 + RSA署名        | チケット認証バックポート          | FW 11.8: Switch式認証導入     |
| 第8世代 | Wii U    | 2012    | AESディスク暗号化 + 認証       | オンライン検証               | ドライブ認証リバースエンジニアリング       |
| 第9世代 | Switch   | 2017    | TrustZone + 固有証明書     | dauth/aauth サーバーサイド認証 | RSA-2048チケット完全検証         |

---

## 第3世代: NES / ファミリーコンピュータ (1983-1985)

### ハードウェアレベル対策

#### 10NES (CIC) ロックアウトチップ

1983年に発売されたファミリーコンピュータにはロックアウトチップが搭載されていなかった。これにより、アジア市場を中心に無許可カートリッジが氾濫し、1983年の北米ビデオゲーム市場崩壊（アタリショック）の一因となった。この反省から、1985年の北米・欧州向けNESには**10NES**（CIC: Checking Integrated Circuit）と呼ばれるロックアウトチップが実装された（[Wikipedia][1]）。

10NESシステムの仕組み:
- **ロック（本体側）**: Sharp 4ビット SM590マイクロコントローラ
- **キー（カートリッジ側）**: 対応する認証チップ
- **認証プロセス**: キーチップがロックチップにコードを送信、認証に失敗するとCPUを1Hzで繰り返しリセット
- **特許**: U.S. Patent 4,799,635（2006年1月24日失効）
- **ソースコード**: 著作権保護下、任天堂のみが製造可能

NES-001モデルでは認証失敗時に画面と電源LEDが1Hzで点滅する現象が発生した。正規カートリッジでも接触不良で頻繁に認証失敗が起きたため、ピン4をカットしてCICを無効化する改造が一般的に行われた。後期のトップローディングNES-101には10NESチップが搭載されていない（[Wikipedia][2]）。

#### ファミコンディスクシステム

ディスクシステムのディスク底面には「NINTENDO」の文字が刻印されており、「I」と2番目の「N」が認証スイッチを作動させていた。海賊版業者は「NINFENDO」「NINTEN」「NINJENDO」「INTEND」など様々な変形版を使用してこれを回避しようとした（[TV Tropes][3]）。

### 回避手法

| 手法               | 詳細                                       |
| ---------------- | ---------------------------------------- |
| 電圧スパイク           | 認証前にCICをシャットダウンする回路                      |
| ドングル方式           | 正規カートリッジのCICを借用（HES社等）                   |
| Tengen Rabbitチップ | 米国著作権局から入手したコードを元にCICを複製（[Wikipedia][4]） |
| ピン4カット           | NES-001内部のCICのピン4を切断して無効化                |

### ソフトウェアレベルの個別タイトル対策

NES時代のソフトウェアレベル対策は限定的だったが、いくつかの注目すべき例がある:

- **Batman Returns**: 著作権表示を改変するとバットマンの被ダメージが2倍に増加、パスワードが無効化、ステージ3-1の窓が開かず進行不能になる（[TV Tropes][5]）
- **Final Fantasy**: オープニングクレジットの「PROGRAMMED BY NASIR」を改変すると起動時にフリーズ
- **EarthBound Beginnings**（英語版プロトタイプ）: チェックサムが失敗すると「unauthorized copy」画面を表示してフリーズ（[WikiBound][6]）
- **Parodius**: 著作権コード改変で最初のステージが永遠にループ
- **StarTropics**: 物理マニュアルに同封された「手紙」に記載の3桁コードが必要（物理メディアベースの認証）

---

## 第4世代: SNES / スーパーファミコン (1990-1991)

### ハードウェアレベル対策

#### CICチップ改良版

スーパーファミコン/SNESには10NESの改良版であるCICチップが搭載された。NESとは異なる命令セットとコードを使用しており、NESのリバースエンジニアリング成果は流用できなかった。主な用途はリージョンロックだった（[MVG - YouTube][7]）。

CICチップは最終的に2010年にSuper CIC modとして完全にリバースエンジニアリングされた。

#### SRAM検知技術

1994年以降、ディスクコピアへの対策として**SRAM容量チェック**が導入された。ディスクコピアは256KBのSRAMを内蔵しているのに対し、多くのカートリッジは8KB以下のSRAMしか持たない（または全く持たない）。この差を検知することで、コピアからの起動を識別した（[MVG - YouTube][8]）。

### 代表的なソフトウェア対策事例

#### EarthBound（MOTHER 2）— 史上最も巧妙な5層防御

EarthBoundは歴代ゲーム史上最も精巧なアンチパイラシーシステムの一つとして知られる。5つの層が段階的に機能する（[STARMEN.NET][9]、[WikiBound][10]）:

| 層   | 内容                    | 効果                                                                |
| --- | --------------------- | ----------------------------------------------------------------- |
| 第1層 | PALコンソール検知            | 「This game is not designed for your Super Famicom or Super NES」表示 |
| 第2層 | SRAMサイズチェック（8KB以外で発動） | アンチパイラシー警告画面を表示してフリーズ                                             |
| 第3層 | チェックサム検証（第1・2層の回避検知）  | 敵エンカウント率が異常に増加、通常出現しないエリアにも敵が出現                                   |
| 第4層 | SRAM関連チェック（プレイ中6回実行）  | 詳細不明だが進行を妨害                                                       |
| 第5層 | 最終ボス戦での罠              | ギーグ戦中にゲームがフリーズ → リセット後に**全セーブデータを完全消去**                           |

この設計の巧妙さは、クラッカーに「対策を突破した」と思わせてプレイを継続させ、最終ボス直前で全てを失わせるという心理的トラップにある。

#### Donkey Kong Country シリーズ

DKCシリーズ全3作品にSRAMチェックが実装されていた:
- **DKC1**: コピア検知時に青い「copying is illegal」スクリーンを表示
- **DKC2**: ゲームオーバー画面を流用した「カートリッジの異常を検知」警告。さらにSRAMセーブファイル内に「A PIRATE」の文字列を埋め込む
- **DKC3**: 同様のゲームオーバー画面ベースの警告

約12本のSNESゲームにSRAMチェックが実装されたが、Super Punch-Out!!やKiller Instinctなども含まれていた（[MVG - YouTube][11]）。

#### その他のSNES対策事例

- **Mega Man X**: コピア上で動作時、アイテム/アップグレードの消失、射撃やアイテム取得でイントロにリセット、ランダム入力の追加、即死判定など多数の妨害が発動（[TV Tropes][12]）
- **Super Metroid**: コピア検知でアンチパイラシーメッセージ表示後、セーブデータを削除
- **Super Mario All-Stars**: 無許可コピーメッセージを表示

---

## 第5世代: Nintendo 64 (1996)

### ハードウェアレベル対策

#### CIC + PIF バス認証システム

N64はCICチップを継承しつつ、実装を大幅に変更した。N64本体にはCICチップの代わりに**PIFバス**（Peripheral Interface）が搭載された。PIFバスはシステムの初期ブートコード処理、コントローラ入力処理に加え、カートリッジのCICチップの正当性を検証するセキュリティ機能を担った（[DidYouKnowGaming - YouTube][13]）。

N64のCICチップバリアント:
- NTSC: CIC-NUS-6101, CIC-NUS-6102, CIC-NUS-6105
- PAL: CIC-NUS-7101, CIC-NUS-7102, CIC-NUS-7105

特に**CIC-NUS-6105/7105**はチャレンジ・レスポンス機能を持ち、ゲーム実行中に繰り返し認証を要求できるため、より強固な保護を提供した。

### 代表的なソフトウェア対策事例

#### 大乱闘スマッシュブラザーズ — 「遅延発動型」アンチパイラシー

スマブラのアンチパイラシーは「遅延発動」型として設計されており、海賊版プレイヤーに偽りの安心感を与える仕組みだった。Supper Mario Brothが報告した4段階のトリガー（[GamesRadar+][14]、[Kotaku][15]）:

| 起動回数 | モード     | 効果                             |
| ---- | ------- | ------------------------------ |
| 22回  | VS Mode | 全ファイターのノックバック値がランダム化（運ゲー化）     |
| 69回  | VS Mode | **選択した全キャラがマリオに変化（永久）**        |
| 43回  | 1P Mode | コントロールスティックの入力範囲が半減（操作が極めて困難に） |
| 93回  | 1P Mode | VS Modeで全ステージがピーチ城に固定          |

セーブデータを完全に削除しない限り解除不可能。この「じわじわ劣化」する設計は、単純なブロックよりもクラッカーが原因を特定しにくい点で効果的だった。GameSharkデバイスでも誤発動する事例が報告されている。

#### Banjo-Tooie — N64最強のコピープロテクション

Rare社が開発したBanjo-Tooieは、N64ライブラリ全体で最もコピー保護が厳重なタイトルとされる。ROMは発売から**12年以上経過した2012年12月**にようやく完全にクラックされた（[DidYouKnowGaming - YouTube][16]）。

多層防御:
1. **セーブタイプ検証**: 2KB EEPROMの正当性をチェック。不正な場合「NO CONTROLLER」表示
2. **CICチップ検証**: CIC-NUS-6105（NTSC）/ CIC-NUS-7105（PAL）のチャレンジ・レスポンス認証を**ゲームプレイ中に268回実行**
3. **アセット暗号化**: CICのレスポンスデータを使用してゲームアセットを復号。チェック失敗時はデータ復号不可能→クラッシュ

#### Perfect Dark — 多彩な挙動異常

Perfect Darkには数多くのアンチパイラシーチェックが埋め込まれており、特定のゲーム内アクション時にトリガーされた（[DidYouKnowGaming - YouTube][17]）:
- 起動時: ゲームが起動しない
- チートメニュー: ゲームクラッシュ
- ドア開閉: ドアが開かなくなるようコードを書き換え
- マルチプレイでアイテム取得: 全ガードが壁越しに透視可能に
- 手榴弾投擲: 無限爆発が発生
- ガラス破壊: 音声周波数が異常に高い値に変更
- 爆発発生: 全爆発が巨大化

#### ゼルダの伝説 時のオカリナ

CIC-NUS-6105/7105の正当性チェックが失敗すると:
- 釣りミニゲームの挙動が異常になる
- その他の複数箇所でゲームプレイに支障が発生

#### Diddy Kong Racing

CICチップの種類が異なる場合、ゲームは完全に起動するが、プレイ中にランダムでセーブデータが予告なく削除される。

---

## 第6世代: Nintendo GameCube (2001)

### ハードウェアレベル対策

#### miniDVD + BCA 物理マーキングシステム

GameCubeは任天堂初の光ディスクベースコンソールであり、物理メディア保護に大きく舵を切った。保護の核心は、独自仕様の8cm miniDVDとBCA（Burst Cutting Area）物理マーキングの組み合わせにある（[MVG - YouTube][18]、[Hackaday][19]）。

技術的詳細:
1. **独自DVDフォーマット**: 標準DVDとほぼ同一だが、セクターレベルのエンコーディングが微妙に異なる。PCのDVDドライブではディスク挿入を認識すらしない
2. **BCA（バースト・カッティング・エリア）**: YAGレーザーでディスク内周に焼き付けられるバーコード状のデータ。通常のDVDライターのレーザーダイオードよりはるかに強力なレーザーが必要
3. **6箇所の物理マーキング**: 任天堂がBCA外周にほぼ等間隔で6つの放射状マークをカット。各マークはトラック上の約50ビットを破壊
4. **サブミクロン精度の検証**: マークの位置（セクターヘッダからの距離と幅）がビット単位で測定され、署名されてBCAに書き込まれる
5. **署名**: マーク位置データは秘密鍵で署名（RSA）。BCAの複製は可能だが、マークを同一位置に再現することは物理的にほぼ不可能

ただし、キー署名の概念がなかったため、ハッカーがコード実行に成功した場合、システムは任意のコードを実行可能だった。

#### Datel社によるBCA回避手法

英国のDatel社（Action Replay/Freeloader）は、BCAのデータ検証の弱点を突いた。GameCubeのドライブは物理マークの実在を確認するのではなく、読み取り後のデータストリームのみを検証していた。Datel社はBCAデータとマーク読み取り結果を模擬するビットストリームを通常のデータ領域に書き込むことで、コンシューマー用機器でディスクを作成した（[Hackaday][20]）。

### モッドチップの歴史

| 年代   | チップ            | 方式                                    |
| ---- | -------------- | ------------------------------------- |
| 2004 | Viper GC       | IPL（BIOS）置換型。DVDドライブロック解除、ネットワークブート対応 |
| 後期   | Qoob / Ripper3 | IPL置換型の後継                             |
| 後期   | Xeno GC        | ドライブチップ型（オープンソース）。DVDドライブに直接介入        |

---

## 携帯機: Nintendo DS (2004)

### ハードウェアレベル対策

DS自体のハードウェア保護は比較的限定的だったが、DSi（2008年）ではホワイトリストとRSA署名によるフラッシュカート排除が導入された（[Flashcarts Wiki][21]）。

### ソフトウェアレベルのAPチェック

DS世代では、個別タイトルへのソフトウェアAPチェック実装が大幅に増加した。フラッシュカート（R4、Acecard等）の普及に対応するため、多くのパブリッシャーがゲームごとに独自のアンチパイラシーを組み込んだ。

#### 代表的な対策事例

| タイトル                                     | 対策内容                                                                                            |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **ポケモン ブラック・ホワイト**                       | カートリッジ内蔵赤外線通信モジュールをチェック。フラッシュカートには赤外線ハードウェアが存在しないため、経験値獲得不可能に（[DidYouKnowGaming - YouTube][22]） |
| **ポケモン ハートゴールド・ソウルシルバー**                 | フラッシュカート/エミュレータでフリーズ、戦闘開始時にモンスターボールが永遠に回転                                                       |
| **マリオパーティDS**                            | ※有名な「PIRACY IS NO PARTY」画面は**フェイク**（ファンメイド）。実際のゲームには存在しない（[Know Your Meme][23]）                 |
| **マリオ&ルイージRPG3**                         | ファイルセレクトでロック、チュートリアル戦闘で進行不能（クッパが攻撃しない等）                                                         |
| **Ghost Trick**                          | 全テキストが空白に                                                                                       |
| **Club Penguin: Herbert's Revenge**      | パフルホイッスルが使用不可に→全ミッション進行不能（[DidYouKnowGaming - YouTube][24]）                                     |
| **逆転裁判**                                 | テキストが部分的に文字化け（×マークの連続に置換）、証拠品やキャラプロフィールの説明が破壊                                                   |
| **Michael Jackson The Experience**       | 全楽曲にブブゼラ音が上乗せ（[IGN][25]）                                                                        |
| **FF Crystal Chronicles: Ring of Fates** | 20分タイマー後「Thank you for playing!!」表示で終了（海賊版がデモ版化）（[Screen Rant][26]）                             |
| **ゼルダの伝説 大地の汽笛**                         | 列車操作のタッチパネルが出現せず進行不能                                                                            |
| **流星のロックマン オペレーティング・シューティングスター**         | フォルダ編集不可、インターネットで1歩ごとにメットール戦                                                                    |

#### R4カート禁止の法的対策

任天堂は2008年、スクウェア・エニックスやカプコン等54社と共同で東京地方裁判所にR4カートの販売禁止を申し立て、勝訴。その後Magikon等他ブランドにも訴訟を拡大した（[DidYouKnowGaming - YouTube][27]）。

---

## 第7世代: Wii (2006)

### ハードウェアレベル対策

#### 独自光ディスク + IOS暗号化基盤

WiiのディスクはGameCubeと類似の独自DVDフォーマットを採用。ディスクのBCA（バースト・カッティング・エリア）パターン（オフセット0x34）を検証し、不一致の場合は3〜10分後に「エラーが発生しました」でフリーズする（[TV Tropes][28]）。

Wiiのセキュリティ基盤:
- **暗号化**: AES-128-CBC（共通鍵暗号）
- **署名**: RSAおよびECC（楕円曲線暗号）
- **セーブデータ保護**: SD-keyで暗号化 + 本体固有ECC秘密鍵で署名
- **バーチャルコンソール**: コンソールIDで暗号化・スタンプ。他の本体では動作しない

しかし、暗号鍵が16個のヌルバイトで構成されていたことや、IOS（Internal Operating System）の署名検証バグ（Trucha Bug）が発見されたことで、これらの保護は比較的早期に突破された（[0x7D0 Blog][29]）。

### ファームウェアアップデートによる対策の進化

Wiiは歴代任天堂ハードの中で最も積極的なファームウェアアップデートによるホームブリュー/海賊版対策を実施した（[Wii Wiki][30]）:

| バージョン | 日付      | 主要対策                                                                    |
| ----- | ------- | ----------------------------------------------------------------------- |
| 3.0   | 2007/08 | 複数のモッドチップ・ブートデバイスを無効化                                                   |
| 3.3   | 2008/06 | Twilight Hack修正（失敗）、IOS署名検証バグ修正、Tweezer Attack阻止                        |
| 3.4   | 2008/11 | Twilight Hack2度目の修正（再び失敗）、IOS権限昇格バグ修正                                   |
| 4.0   | 2009/03 | Twilight Hack正式修正、IOS16スタブ化、「バックアップディスク」検知でブート拒否                        |
| 4.2   | 2009/09 | boot2上書き、**Homebrew Channel自動削除**（ID: HAXX）、Bannerbomb修正試行。一部未改造本体もブリック |
| 4.3   | 2010/06 | HBC ID「JODI」も削除対象に追加、Bannerbomb完全修正、IOSダウングレード対策、IOS80への移行              |

バージョン4.2では未改造Wiiのブリック事例が多数報告され、任天堂が無償修理対応を発表するなど、対策の副作用も問題となった（[IGN][31]）。

### Korean Wii問題

韓国版Wiiでは暗号鍵が変更されたが、System Menu 4.2/4.3でリージョン変更された韓国版Wiiに「Error: 003, Unauthorized device Detected」が表示されて完全にブリックする問題が発生。BootMii as boot2も上書きされるため復旧が極めて困難だった（[Wii Hacks Guide][32]）。

---

## 携帯機: Nintendo 3DS (2011)

### ハードウェアレベル対策

3DSではAES暗号化とRSA署名が本格導入された。ゲームカートリッジのヘッダデータが共有可能だったDS時代の脆弱性を反映し、より強固な認証が実装された。

### ファームウェア 11.8 — Switch式認証のバックポート

2018年8月、3DSのファームウェア11.8アップデートで、Switch向けに開発されたアンチパイラシーシステムが**バックポート**された。SciresM氏の発見により、ネットワーク通信時にアプリチケットの暗号化コピーがサーバーに送信されるようになり、任天堂は非正規アクセスを完全に検知し任意のタイミングでBAN可能になった（[Neowin][33]、[TechRadar][34]）。

3DSのライフサイクル末期の導入だったため実際の影響は限定的だったが、任天堂のアンチパイラシー姿勢の一貫性を示す事例となった。

### ソフトウェアレベルの対策

- **ポケモン X/Y**: デジタル版がシステムID + カードIDでスタンプされ、別SDカードへのコピーでセーブが破損・再起動を強制（[TV Tropes][35]）
- **レイトンシリーズ**: ボーナスパスワードが本体IDに紐付け。他人のパスワードやサイト掲載のものは使用不可

---

## 第8世代: Wii U (2012)

### ハードウェアレベル対策

Wii Uはディスク暗号化（AES）、ドライブ認証、ファイルシステム暗号化の三層構造を採用。Wii時代の教訓を反映し、より強固な暗号化が実装された。

しかし2013年4月、あるハッキンググループがWii Uのドライブ認証、ディスク暗号化、ファイルシステムを完全にリバースエンジニアリングしたと主張。「光学ドライブエミュレータ」を使用してUSBメディアからWii U/Wiiゲームを実行できるとされた（[GameSpot][36]）。

任天堂は声明で「Wii Uモードで不正ゲームが動作した報告はない」と述べつつ、「すべての脅威を継続的に監視」すると表明。Wiiのバックドアを経由した攻撃であった可能性が示唆されている（[RVG Forum][37]）。

---

## 第9世代: Nintendo Switch (2017)

### ハードウェアレベル対策

#### TrustZone + 固有証明書体系

Switchは任天堂史上最も高度なアンチパイラシーシステムを実装している。そのセキュリティは以下の要素で構成される（[Reddit/SciresM][38]、[MobileSyrup][39]）:

**固有クライアント証明書**: 
- 工場出荷時に書き込まれるコンソール固有の証明書
- 秘密鍵はTrustZone（隔離されたセキュリティCPUコア）の暗号化APIでのみ復号可能
- 全てのサーバー通信（bugyo以外）がクライアント証明書認証を要求

### 4段階オンライン認証プロセス

SciresM氏の詳細な分析によると、Switch のオンライン認証は4段階で構成される:

#### ステップ1: インターネット接続確認
「ctest.cdn.nintendo.net」に接続し、レスポンスヘッダに「X-Organization: Nintendo」が存在するか確認。

#### ステップ2: デバイス認証トークン取得（dauth）
1. dauth サーバーの「/challenge」エンドポイントにマスターキーリビジョンを送信
2. サーバーからランダムチャレンジ文字列と定数データを受信
3. データ文字列をBase64デコードし、**TrustZone専用鍵データ**で変換してAESキースロットに格納
4. `challenge=%s&client_id=%016x&key_generation=%d&system_version=%s` 形式で認証リクエストデータを生成
5. TrustZone鍵でAES-128 CMACを計算、MACを付加して送信
6. 検証成功でデバイストークン返却（**BAN済み本体はエラー**）

#### ステップ3: アカウント認証

#### ステップ4: アプリケーション認証トークン取得（aauth）

ここが最も重要なセキュリティ層である:

**ゲームカードの場合**:
- カートリッジ固有の証明書（Nintendo が RSA-2048-PKCS#1 で署名）をaauth に送信
- 証明書にはゲーム情報と暗号化された追加データを含む
- ゴールドポイント交換時にNintendo Accountに紐付け → 証明書共有を検知可能

**デジタルゲームの場合**:
- コンソールのチケット（Title ID、Device ID、Nintendo Account ID を含む）を使用
- チケットは **RSA-2048** で署名（偽造不可能）
- チケットは **AES-128-CBC** で暗号化（ランダム生成鍵）、鍵自体は **RSA-OAEP 2048** で暗号化
- **任天堂のみが復号可能**な一方向暗号化

この設計により、デジタルゲームの海賊版オンライン接続は**理論的に完全に防止**される。デバイスIDとチケットのデバイスID照合、アカウントIDの照合により、不正アクセスは即座にBAN対象となる（[KitGuru][40]）。

### Tegra X1 脆弱性（Fusée Gelée）

2018年4月、Kate Temkin氏（ReSwitched）とfail0verflow チームが独立にNvidia Tegra X1のBoot ROMにある脆弱性「Fusée Gelée（ShofEL2）」を発見・公開した（[fail0verflow][41]、[TechCrunch][42]）。

| 項目     | 詳細                                             |
| ------ | ---------------------------------------------- |
| 脆弱性の場所 | Tegra X1 Boot ROM（RCMモード内）                     |
| 攻撃手法   | USB経由の不正形式パケットで最大65,535バイトの任意コードを実行            |
| パッチ可能性 | **不可能**（Boot ROMは読み取り専用。製造工程でのみ修正可能）           |
| 影響範囲   | 初期出荷の全Switch本体が恒久的に脆弱                          |
| 検知可能性  | ブート時バグのためeMMCに触れず、**既存ソフトウェアで検知不可能**           |
| 任天堂の対応 | 後期モデル（Mariko/Tegra X1+）でハードウェア修正、モッドチップ対策の法的措置 |

### BAN措置

- オンラインゲーム（Nintendo サーバー）、NSO、eShopからブロック
- アップデートダウンロードとローカルプレイは継続可能
- テレメトリデータがインターネット接続時に送信され、異常が記録される
- カスタムアイコン使用でBAN（カスタム背景はBAN対象外）
- 2枚のゲームカードを同時使用すると両方BAN
- 2025年5月: プライバシーポリシー改定で改造ソフトウェア検知時の本体無効化権を主張（[Reddit][43]）

---

## 「フェイク」アンチパイラシースクリーン現象

### Mario Party DS アンチパイラシースクリーン

2020年末に広まった「PIRACY IS NO PARTY」スクリーン（マリオたちが牢獄に入れられている画像）は**完全にファンメイドの捏造**であり、実際のMario Party DSには存在しない。YouTuber Joey Perleoni が制作した偽のアンチパイラシースクリーンが「信じられるほどリアル」だったため、インターネット上でミーム化した（[Know Your Meme][44]）。

このフェイクは実在するNintendo DSゲームのアンチパイラシー機能（不気味な音楽と大きなテキスト）にインスパイアされており、同様のフェイク動画がGameCube、Wii、スーパーマリオギャラクシーなど多数のタイトルで制作される「アンチパイラシースクリーン」トレンドの火付け役となった（[YouTube][45]）。

---

## 技術進化の分析

### 対策パラダイムの転換

任天堂のアンチパイラシーは40年間で4つの主要パラダイムを経てきた:

**第1期: ハードウェアロック時代（1985-2001）**
- CIC/10NESによる物理的なロック&キー認証
- メリット: 実装がシンプル、一般ユーザーには効果的
- 限界: チップの複製・無効化が可能、ソフトウェアレベルの保護なし

**第2期: 物理メディア時代（2001-2006）**
- 独自光ディスクフォーマット + BCA物理マーキング
- メリット: 一般的な機器では複製不可能
- 限界: ハードウェアモッド（モッドチップ）で回避可能

**第3期: ソフトウェア・暗号化時代（2006-2017）**
- AES/RSA暗号化 + ファームウェアアップデート + ソフトウェアAPチェック
- メリット: アップデートで継続的に対策強化可能
- 限界: ホームブリュー開発者との「いたちごっこ」が激化

**第4期: サーバーサイド認証時代（2017-現在）**
- TrustZone + オンライン認証 + RSA-2048チケット
- メリット: デジタルゲームの海賊版オンライン接続を理論的に完全防止
- 限界: Tegra X1のBoot ROM脆弱性（ハードウェアリビジョンで対応）

### 各世代の評価

| ハード      | 保護の有効期間                | 突破難易度                    | 総合評価  |
| -------- | ---------------------- | ------------------------ | ----- |
| NES      | 約3-5年                  | 低（ピンカット/電圧スパイク）          | ★★☆☆☆ |
| SNES     | 約5年                    | 中（SRAM検知は効果的だが限定的）       | ★★★☆☆ |
| N64      | 約10年以上（一部タイトル）         | 中〜高（CIC 6105が特に強力）       | ★★★★☆ |
| GameCube | 約3年                    | 中（BCA物理保護は優秀だがモッドチップで突破） | ★★★☆☆ |
| DS       | 限定的                    | 低（フラッシュカートが容易に入手可能）      | ★★☆☆☆ |
| Wii      | 約1-2年                  | 低〜中（IOS脆弱性が多数）           | ★★☆☆☆ |
| 3DS      | 約2-3年                  | 中（ただしライフサイクル末期に強化）       | ★★★☆☆ |
| Wii U    | 約1年                    | 中（Wii互換モードが弱点）           | ★★☆☆☆ |
| Switch   | オフライン保護は初期に突破、オンラインは堅牢 | 高（オンライン認証は現在も有効）         | ★★★★★ |

---

## 結論

任天堂の海賊版対策は、単純なハードウェアロックから多層的なサーバーサイド認証へと劇的に進化した。特にSwitchのdauth/aauth認証システムは、RSA-2048署名とTrustZoneベースの暗号化により、デジタルゲームの不正オンライン接続を理論上完全に防止するという、過去40年間の集大成とも言える設計となっている。

一方で、EarthBoundの5層防御やスマブラの「69回起動で全員マリオ」のような創造的なソフトウェアレベルの対策は、単なるセキュリティ技術を超えた「芸術作品」として、ゲーム文化の中で独自の地位を築いている。技術的進歩とクリエイティブなアプローチの両面において、任天堂のアンチパイラシー史は、デジタルコンテンツ保護技術の縮図とも言える。

[1]:	https://en.wikipedia.org/wiki/CIC_(Nintendo)
[2]:	https://en.wikipedia.org/wiki/CIC_(Nintendo)
[3]:	https://tvtropes.org/pmwiki/pmwiki.php/CopyProtection/Nintendo
[4]:	https://en.wikipedia.org/wiki/CIC_(Nintendo)
[5]:	https://tvtropes.org/pmwiki/pmwiki.php/CopyProtection/Nintendo
[6]:	https://wikibound.info/wiki/Anti-piracy_in_the_Mother_series
[7]:	https://www.youtube.com/watch?v=KLyK1FMwc8Q
[8]:	https://www.youtube.com/watch?v=KLyK1FMwc8Q
[9]:	http://starmen.net/mother2/gameinfo/antipiracy/
[10]:	https://wikibound.info/wiki/Anti-piracy_in_the_Mother_series
[11]:	https://www.youtube.com/watch?v=KLyK1FMwc8Q
[12]:	https://tvtropes.org/pmwiki/pmwiki.php/CopyProtection/Nintendo
[13]:	https://www.youtube.com/watch?v=fR4lD1jhawA
[14]:	https://www.gamesradar.com/games/super-smash-bros/if-you-play-a-pirated-super-smash-bros-exactly-69-times-on-n64-nintendos-sneaky-anti-piracy-measure-will-lull-the-illegitimate-user-into-a-false-sense-of-security-and-trap-you-as-mario-forever/
[15]:	https://kotaku.com/super-smash-bros-n64-piracy-nintendo-2000627887
[16]:	https://www.youtube.com/watch?v=fR4lD1jhawA
[17]:	https://www.youtube.com/watch?v=fR4lD1jhawA
[18]:	https://www.youtube.com/watch?v=Uxjl_kD3imQ
[19]:	https://hackaday.com/2019/02/04/how-one-company-cracked-the-gamecube-disc-protection/
[20]:	https://hackaday.com/2019/02/04/how-one-company-cracked-the-gamecube-disc-protection/
[21]:	https://www.flashcarts.net/ds-quick-start-guide.html
[22]:	https://www.youtube.com/watch?v=QiTene7mHpc
[23]:	https://knowyourmeme.com/memes/mario-party-ds-anti-piracy-screen
[24]:	https://www.youtube.com/watch?v=QiTene7mHpc
[25]:	https://www.ign.com/articles/2013/04/29/eight-of-the-most-hilarious-anti-piracy-measures-in-video-games
[26]:	https://screenrant.com/anti-piracy-video-games-funny/
[27]:	https://www.youtube.com/watch?v=SvL93pNRbfY
[28]:	https://tvtropes.org/pmwiki/pmwiki.php/CopyProtection/Nintendo
[29]:	https://blog.0x7d0.dev/history/how-the-nintendo-wii-security-was-defeated/
[30]:	https://wii.fandom.com/wiki/Wii_System_Update
[31]:	https://www.ign.com/articles/2009/10/01/wii-system-update-reportedly-bricking-consoles
[32]:	https://wii.hacks.guide/bricks
[33]:	https://www.neowin.net/news/nintendos-anti-piracy-measures-arrive-on-the-3ds-with-the-latest-update/
[34]:	https://www.techradar.com/news/nintendo-3ds-puts-the-kibosh-on-piracy-with-latest-software-update
[35]:	https://tvtropes.org/pmwiki/pmwiki.php/CopyProtection/Nintendo
[36]:	https://www.gamespot.com/articles/wii-u-copy-protection-hacked-claims-modding-group/1100-6407737/
[37]:	https://www.retrovideogamer.co.uk/community/modern-gaming/wii-u-copy-protection-hacked/
[38]:	https://www.reddit.com/r/SwitchHacks/comments/8rxg26/psa_strong_antipiracy_measures_implemented_by/
[39]:	https://mobilesyrup.com/2018/06/25/nintendo-switch-anti-piracy/
[40]:	https://www.kitguru.net/tech-news/featured-tech-news/matthew-wilson/nintendo-implements-strict-new-anti-piracy-measures-for-the-switch/
[41]:	https://fail0verflow.com/blog/2018/shofel2/
[42]:	https://techcrunch.com/2018/04/23/unstoppable-exploit-in-nintendo-switch-opens-door-to-homebrew-and-piracy/
[43]:	https://www.reddit.com/r/fucknintendo/comments/1o9d4x8/nintendos_history_with_anticonsumer_practices/
[44]:	https://knowyourmeme.com/memes/mario-party-ds-anti-piracy-screen
[45]:	https://www.youtube.com/watch?v=ZZN0t6bwYHY

[image-1]:	https://d2z0o16i8xm8ak.cloudfront.net/4948e170-5a1a-4fea-a873-5f23bfcea31c/c5cb5bbe-a4d3-4879-8797-c477bfdfa331/nintendo-antipiracy-timeline.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9kMnowbzE2aTh4bThhay5jbG91ZGZyb250Lm5ldC80OTQ4ZTE3MC01YTFhLTRmZWEtYTg3My01ZjIzYmZjZWEzMWMvYzVjYjViYmUtYTRkMy00ODc5LTg3OTctYzQ3N2JmZGZhMzMxL25pbnRlbmRvLWFudGlwaXJhY3ktdGltZWxpbmUucG5nPyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3NzY0NzQ5ODJ9fX1dfQ__&Signature=PHXYXAqsJmZ60dQF6MOv7AK7gaz5M9TUl~L~yOJSPq5Ku06yNXxiY3fmo3TvTGDf3v4a4rp4DMkxqsRw4hNY5UeHW9J6T7Df737B7cF5kC2ZbW904KggzAal8WymNlXPpAIcR2At3gvN2ndWky-ZjqHzQC4hhdL1RUvN-9aCLoknO55nc2pAU7nFPD3nwUxJLwKlJt0I7ZohcWpbVPuuTD9209U3ALQGEA-GtTvBQfrxjLVaXuniMPqClF5ZlWQyJT~Ru6hf5UGGpFf2t19pFhrmgVgrGxOQM63p-ADxI4jd56itpohkMApgkr8Og97H9QkUmXvIR5PSXWaK0zUAuQ__&Key-Pair-Id=K1BF7XGXAIMYNX