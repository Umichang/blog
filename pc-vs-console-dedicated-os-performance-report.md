# 汎用OS搭載PCゲーム vs 専用OS搭載コンソールゲーム
## 性能・設計・開発の徹底比較レポート

***

## エグゼクティブサマリー

PCゲームと家庭用ゲーム機のゲームは、同じグラフィックスを画面に描画しながら、その裏側では根本的に異なるOS設計を持つ。PCは汎用OS（主にWindows、新興勢力としてSteamOS）の上でゲームを動かすため、膨大な汎用機能に伴うオーバーヘッドを抱える。一方、コンソール（PS5、Xbox Series X）は専用OSがゲームワークロードに特化した設計で動いており、限られたリソースから最大限の性能を引き出す。近年のSteamOSの台頭はこの構図を複雑にしており、「汎用OS ＝ 非効率」という従来の常識が問い直されつつある。

***

## 第1章：OSアーキテクチャの基礎

### 1-1. 汎用OS（Windows / SteamOS）

**Windows** はNTカーネルをベースとした汎用オペレーティングシステムであり、ゲーム以外にも文書作成・ブラウジング・ビジネスアプリケーションなどあらゆる用途に対応するよう設計されている。そのため、ゲームを実行中も多数のバックグラウンドサービス・テレメトリー・セキュリティ機構が常時動作している。[[1](#ref-1)]

**SteamOS** はValveが開発したArch Linuxベースのゲーミング特化OSである。元々Steam Deck向けに設計されたが、2025年以降はLenovo Legion Go Sなど第三者製ハンドヘルドデバイスへの公式展開も進んでいる。[[2](#ref-2)][[3](#ref-3)]

### 1-2. 専用OS（PS5 / Xbox Series X）

**PlayStation 5のOS（Orbis 2.0系）** は、PS4から引き継いだFreeBSDベースの独自OSと広く分析されている。PS4のOrbis OSはFreeBSDをベースにSonyが大幅改変したもので、独自グラフィックスAPI（Gnm/GNMX）、サンドボックス型アプリ実行、ゲーム向けI/Oスケジューリング最適化が施されている。PS5のOSはこの技術を発展させたカスタムOSであると技術解析により考えられている。なお、SonyはPS5 OSの内部仕様を公式には完全公開しておらず、BSDライセンスがソースコード開示義務を伴わない点を活かして実装の詳細を非公開にしている。[[4](#ref-4)][[5](#ref-5)][[6](#ref-6)]

**Xbox Series X** のOSは、歴代Xboxと同様にWindowsのヘビーカスタム版である。ただしゲームタイトル用VM、システムOS用VM、後方互換用VMという複数の仮想マシンで構成されており、一般的なWindows PCとは根本的に異なる構造を持つ。[[7](#ref-7)][[8](#ref-8)]

***

## 第2章：汎用OSのオーバーヘッドと「追加コスト」

PCゲームの性能を語るうえで最も重要な問題のひとつが、汎用OSが生む **不可避のオーバーヘッド** である。

### 2-1. バックグラウンドプロセスとメモリ消費

クリーンインストール直後のWindows 11はアイドル状態でも約 **3.3GB前後のRAM** を消費する。これはWindows XPのアイドル時消費量（約0.8GB）と比べて約4倍の増加である。ゲーム自体が12〜16GBのRAMを要求する昨今、バックグラウンドアプリがさらに3〜6GBを消費すれば、システムはページファイル（仮想メモリ）の利用を開始し、ディスクI/Oスパイクが発生する。Windowsには多数のビルトインサービス（テレメトリー、バックグラウンドアプリ、Windows Update等）が存在し、これらはCPU・RAM・ディスク・ネットワークリソースを予告なく消費する。[[9](#ref-9)][[10](#ref-10)][[11](#ref-11)]

### 2-2. VBS（仮想化ベースのセキュリティ）の性能ペナルティ

Windows 11では2021年10月以降、 **VBS（Virtualization-Based Security）** が多くのプリビルドPCの新規インストールでデフォルト有効となった。VBSはハイパーバイザーを介して隔離されたメモリ領域を作成するため、ゲームパフォーマンスに直接影響する。PC Gamerが2021年に行った初期実測では：[[12](#ref-12)]

- **Far Cry New Dawn**：VBS有効時に約5%低下
- **Metro Exodus**：約24%低下
- **Horizon Zero Dawn**：約25%低下
- **Shadow of the Tomb Raider**：約28%低下

その後Tom's Hardwareが2023年にCore i9-13900K + RTX 4090環境で再計測した際は、平均約5%、Microsoft Flight Simulatorで最大約11%の性能低下が報告されており、ハードウェアやテスト条件に依存して影響度合いは変動する。[[12](#ref-12)][[13](#ref-13)]

特にCPU負荷の高いゲーム（フライトシミュレーター、CPU依存度の高いシューター等）ほど影響が大きい傾向にある。[[12](#ref-12)]

### 2-3. DPCレイテンシとスケジューリングオーバーヘッド

Windowsのドライバ処理（ISR/DPC）は割り込みレイテンシを生み出し、フレームタイムの安定性に影響する。従来のGPUスケジューリングではCPUがすべての描画コマンドをバッチ処理してGPUに渡す構造だったが、これはCPUサイクルを消費し、マイクロレイテンシを生む。Windows 10 バージョン2004で導入された **HAGS（Hardware Accelerated GPU Scheduling）** は、このスケジューリングの一部をGPU側に移譲することでCPUオーバーヘッドを削減する試みであるが、ドライバの成熟度次第で効果が大きく変わる。[[14](#ref-14)][[15](#ref-15)][[16](#ref-16)]

### 2-4. 直接ハードウェアアクセスの制限

PC上でゲームはOSカーネル、グラフィックスドライバ（DirectX/Vulkan）、セキュリティソフトウェアを経由してハードウェアにアクセスするため、本質的に **抽象化レイヤーが複数存在** する。一方、コンソール向けゲームはプラットフォームベンダーが提供する低レベルSDKを通じてハードウェアに直接近い形でアクセスできる。PS5では特定のハードウェアに最適化されたコンパイラ／ツールチェーンが提供される一方、PCでは「汎用」なx86＋DirectX/Vulkan向けにコンパイルされるため、同一スペック上でもパフォーマンスに差が生まれる。[[1](#ref-1)]

***

## 第3章：専用OSの強み——「最適化」の正体

### 3-1. 固定ハードウェアへの完全最適化

コンソールの最大の優位点のひとつは、 **全ユーザーが完全に同一のハードウェア構成を持つ** ことである。開発者はたった一種類のCPU・GPU・メモリ構成のみを対象にチューニングすればよく、PC向けには事実上無限に存在するハードウェア組み合わせに対して包括的なサポートを提供する必要がない。「同じゲームがPS5では安定して動くのに、数倍の予算を使ったゲーミングPCでは動作が不安定」というケースは、この最適化の差から生まれる。[[17](#ref-17)][[18](#ref-18)][[19](#ref-19)]

### 3-2. OSのリソース予約量

コンソールOSはゲームに最大限のリソースを割り当てるため、OS自体が予約するリソースを最小化している。Xbox Series XのOSはCPU 1コア（または2スレッド）と2.5GBのGDDR6（低帯域プール側から）を予約し、ゲームには合計13.5GBのメモリ（10GBの高帯域GPU最適メモリ + 3.5GBの標準メモリ）を利用可能にしている。PS5のOSは1.5コアと3.5GBのメモリを予約しており、残り6.5コアとメモリの大部分をゲームが専有できる。これに対しWindowsはアイドル時でも3GB超のRAMを消費し、CPU使用率も常に一定程度占有する。[[20](#ref-20)][[9](#ref-9)]

### 3-3. ユニファイドメモリアーキテクチャ

PS5・Xbox Series Xはともに **統合メモリ（ユニファイドメモリ）** を採用しており、CPUとGPUが同一のメモリプールを共有している。これによりCPU↔GPU間のデータコピーが不要となり、帯域幅の効率が向上し、レイテンシが低減する。PCはGPU用のVRAMとシステムRAMが物理的に分離されているため、コンソールの16GBユニファイドメモリに相当する体験を得るには、システムRAMとして **32GB以上** が推奨されることが多い。[[21](#ref-21)][[22](#ref-22)]

### 3-4. ハードウェアレベルのI/O最適化

PS5の独自SSDコントローラーは専用ハードウェアデコンプレッションブロックを持ち、生転送速度5.5GB/sを実現する。Sonyのリードアーキテクトであるマーク・サーニーによれば、このカスタムデコンプレッサーはKrakenストリームを処理する際にZen 2コア9基分に相当する処理能力を持つ。これにより開発者はデコンプレッション処理のCPUコストを意識せずにゲームを設計できる。Xbox Series XのVelocity Architectureも同様の方向性で、BCPackによるテクスチャ圧縮、DirectStorage、Sampler Feedback Streaming（SFS）を組み合わせて資産ストリーミングを高速化している（XSXのデコンプレッサーはZen 2コア約3基分相当とされる）。[[23](#ref-23)][[24](#ref-24)][[25](#ref-25)]

***

## 第4章：SteamOS——第三の道の現在地

### 4-1. SteamOS 3.7：Windowsを逆転したLinux

かつてLinux（SteamOS）はゲームのネイティブWindowsポートと比較してパフォーマンスが明らかに劣っていた。しかし2025年6月にArs Technicaが実施したLenovo Legion Go SのSteamOS 3.7 vs Windows 11比較では、5本のテストゲーム中4本でSteamOSが優勢という、構図が逆転した結果が示された。[[26](#ref-26)]

Valveの長期的なProton最適化とMesa グラフィックスドライバへの投資が実を結び、SteamOSはWindowsより **軽量なシステムフットプリント** を実現している。Boiling Steamが2025年に複数メディアの計測値を集計したところ、Lenovo Legion Go S上では多くのゲームで20〜30%程度の性能向上が確認されている：[[27](#ref-27)][[28](#ref-28)]

| ゲーム | Windows 11 (FPS) | SteamOS (FPS) | 差異 | 出典 |
|--------|-----------------|---------------|------|------|
| Cyberpunk 2077 | 46 | 59 | +28% | TechSpot |
| Red Dead Redemption 2 (Lowest) | 41 | 56 | +37% | Tom's Hardware |
| Forza Horizon 5 (Low) | 42 | 70 | +67% | Rock Paper Shotgun |
| Horizon Zero Dawn Remastered | 20 | 35 | +75% | Technetbooks |
| Doom Eternal | 66 | 75 | +14% | Technetbooks |
| The Witcher 3 | 66 | 76 | +15% | Ars Technica |
| Helldivers 2 | 65 | 70 | +8% | Technetbooks |
| Shadow of the Tomb Raider | 33 | 39 | +18% | XDA Developers |

*測定対象：Lenovo Legion Go S（Z2 Go / Z1 Extreme）/ 2025年複数メディア計測値の集計*[[28](#ref-28)]

なお、これらの結果はハンドヘルド環境（低TDP・統合GPU）での計測であり、デスクトップPC＋ディスクリートGPU環境では異なる傾向を示すこともある。実際、ETA Primeが2026年1月に行ったRyzen 7 9800X3D + Radeon RX 7900 XTX環境での比較では、ゲームによってWindows 11が優勢、SteamOSが優勢、ほぼ同等とまちまちな結果になっており、結論はハードウェア構成に強く依存する。[[29](#ref-29)]

### 4-2. Protonの仕組みとトレードオフ

SteamOSはWindowsネイティブゲームを **Proton** という互換レイヤーを通じて動作させる。ProtonはWine、DXVK（DirectX→Vulkan変換）、VKD3D-Proton（DirectX 12→Vulkan変換）などを統合した実行環境であり、これが逆説的な性能向上をもたらす場合がある。DirectX 11以前の古いAPIはWindowsのドライバが非効率なため、Protonを経由してVulkanに変換したほうがCPU呼び出しのオーバーヘッドが小さくなるケースが存在する。[[30](#ref-30)][[31](#ref-31)]

一方でProtonは以下の限界も持つ：[[31](#ref-31)][[32](#ref-32)]

- **低スペックデバイスへの追加CPU負荷**：Proton変換処理がCPUを消費し、Steam Deck程度のAPUでは無視できない場合がある
- **追加RAMおよびVRAM消費**：8GB統合メモリ環境ではメモリ圧迫のリスクがある
- **カーネルレベルのアンチチートが動作しないケースがある**：ValorantのVanguardなど一部の厳格な実装はLinuxカーネルに依存できないため、対応していない[[32](#ref-32)]

### 4-3. SteamOS 3.8（2026年3月）の新機能

2026年3月に公開されたSteamOS 3.8.0 Previewには以下の主要変更が含まれる：[[3](#ref-3)][[33](#ref-33)]

- **Steam Machineの初期サポート追加**：RDNA系の専用GPUを搭載した据え置きゲーミングPCに向けた基盤実装[[34](#ref-34)]
- **ディスクリートGPU向けのVRAM管理を大幅改善**：従来SteamOSはdGPU環境でWindowsに劣る傾向があったが、この改善でゲームデスクトップ向け性能が向上[[33](#ref-33)]
- **ハンドヘルド機のコントローラー入力レイテンシを劇的改善**：5〜8ミリ秒から100〜500マイクロ秒へ削減（最大で約80倍の改善）[[33](#ref-33)][[34](#ref-34)]
- **外部ディスプレイのHDR・VRR対応追加**（Wayland／KDE Plasma 6.4.3への移行に伴う）[[3](#ref-3)]
- **Lenovo Legion Go 2向けコントローラー・ファームウェア更新サポート** [[35](#ref-35)]
- **対応ハードウェアの拡張**：ASUS ROG Xbox Ally、OneXPlayer、GPDなど複数メーカー向け改善[[3](#ref-3)][[33](#ref-33)]

### 4-4. アンチチート問題の改善動向

SteamOSの競技ゲームにおける最大の課題であったアンチチート互換性も改善が進んでいる。Epic GamesはEasy Anti-Cheat（EAC）にProtonサポートを組み込み、開発者が選択的に有効化できるようにした。BattlEyeも同様の対応を行っている。ただし、Apex Legendsや一部タイトルでは2025年に逆にSteamOSサポートが停止される事例もあり、状況はタイトルごとに変動する。ValorantのVanguardのような最も厳格なカーネルレベルの実装は依然として非対応のままである。[[36](#ref-36)][[32](#ref-32)]

***

## 第5章：グラフィックスAPIと描画パイプラインの差

コンソールとPCでは、ゲームのグラフィックス描画命令がハードウェアに届くまでの経路が根本的に異なる。

| 層 | PCゲーム（Windows） | コンソール（PS5） | SteamOS |
|----|-------------------|-----------------|---------|
| アプリケーション | DirectX 12 / Vulkan | GNM/GNMX（独自） | Proton経由でVulkan変換 |
| ドライバ | WDDM（Windows Display Driver Model） | カスタムドライバ | Mesa（オープンソース） |
| スケジューリング | CPUベース（HAGSで一部GPU委譲） | GPU直接制御 | Linuxカーネルスケジューラ |
| ハードウェアアクセス | 複数抽象化レイヤー経由 | より直接的 | WDDM不要、より直接的 |

PS5のGNM/GNMXはDirectX/VulkanよりもGPUハードウェアに近い低レベルAPIであり、開発者は同じハードウェアでも高い利用効率を得られる。Digital Foundryなど複数の解析でも、PS5の低レベルAPIアクセスがXbox Series Xより低スペックなGPU（36 CU vs 52 CU）を搭載しながらも実ゲームパフォーマンスで拮抗、あるいは上回ることがある一因として挙げられている。[[37](#ref-37)]

DirectX 12とVulkanはDX11以前と比べてCPUオーバーヘッドを大幅に削減したものの、それでもコンソールの専用APIには及ばないとされる。[[38](#ref-38)]

***

## 第6章：性能の上限と「スケーラビリティ」

### 6-1. 最高性能では圧倒するPC

純粋な性能上限ではPCが圧倒的に優れる。ハイエンドGPU（RTX 5090等）を搭載したPCは、PS5 ProのGPU性能を大幅に上回る（理論演算性能ベースで概ね3倍前後）。PCでは4K・100fps超・レイトレーシング同時有効化が現実的であり、コンソールは多くの場合60fps上限という制約を持つ。[[39](#ref-39)][[40](#ref-40)]

ただしDigital Foundryの2025年の検証によれば、PS5 ProのGPU性能はRTX 5060 Ti（16GB版）やRadeon RX 9060 XT（16GB版）と概ね同等の水準にあり、ミドルクラスPCとの比較では拮抗する場合も多い。コスト対性能比では現世代コンソールは依然として競争力がある。[[40](#ref-40)]

### 6-2. 最適化による「性能の引き出し方」の違い

500ドルクラスのコンソールが、はるかに高価なゲーミングPCよりも安定したゲーム体験（30fps相当の安定動作など）を提供するケースが起きる。これはコンソールの最適化効率の高さを示している。ゲームはコンソールの固定ハードウェアに向けてピンポイントで最適化されるが、PC版は多様なハードウェア構成に対応するため、どこかで汎用性との妥協が必要になる。[[18](#ref-18)][[17](#ref-17)]

***

## 第7章：開発者視点——どちらで作るか

### 7-1. コンソール開発の優位点

コンソール向け開発では、開発者は **単一の既知ハードウェア** を対象にするため、最適化の深度を極限まで高めることができる。Sony SDKはPS5固有のジョブシステム、SSD I/O API、Kraken圧縮を活用したアセットストリーミングなどを標準化している。開発ターゲットが明確なため、QAテストの範囲も限定できる。[[24](#ref-24)]

### 7-2. PC開発の課題

PC向けゲームは事実上無限のハードウェア構成（CPU世代、GPU世代、RAM容量、ストレージ種別）に対応する必要がある。これは「PCポーティングが壊れた状態でリリースされる」問題の根本原因のひとつである。近年、『The Last of Us』PC版や複数のAAAタイトルが発売直後に深刻な最適化問題を抱えた事例は、この複雑性を示している。[[17](#ref-17)][[19](#ref-19)]

### 7-3. ポーティングコストと工数

PCからコンソールへ、またはコンソールからPCへのポーティングコストは、ゲームの規模と複雑さに依存して大きく変動する。UnityやUnreal Engineのようなクロスプラットフォーム対応エンジンはコストを低減するが、カスタムエンジンを使用した大型AAA作品では大幅な修正が必要になる場合がある。[[41](#ref-41)][[42](#ref-42)]

***

## 第8章：総合比較——メリット・デメリット

### 8-1. PCゲーム（Windows）

| 項目 | 内容 |
|------|------|
| **最大性能** | ハイエンドGPU使用時にコンソールを大幅に超える |
| **拡張性** | CPUやGPUを個別にアップグレード可能 |
| **タイトル多様性** | Steam・Epic・GOG・Xbox Game Passなど複数ストアに対応 |
| **MOD・カスタマイズ** | フルアクセス可能 |
| **入力デバイス自由度** | マウス+キーボード・ゲームパッド・HOTAS等を自由に選択 |
| **バックグラウンドオーバーヘッド** | VBS・テレメトリ・バックグラウンドアプリが性能を侵食 |
| **安定性の個体差** | ハードウェア構成依存で最適化品質が変動 |
| **初期コスト** | 同等性能を得るにはコンソールより高額になることが多い |
| **セットアップ複雑度** | ドライバ管理・設定調整など知識が必要 |

### 8-2. PCゲーム（SteamOS）

| 項目 | 内容 |
|------|------|
| **同一ハンドヘルドでの性能** | 多くのゲームでWindows 11より20〜30%高い（Lenovo Legion Go S実測値の集計） |
| **軽量なシステムフットプリント** | VBS・テレメトリ等の不要な処理が存在しない |
| **バッテリー効率** | ハンドヘルド環境でWindowsより明らかに優れる |
| **コントローラー操作性** | ゲームモードとデスクトップモードのシームレスな切り替え |
| **オープンソース** | OS自体がOSSで透明性が高い |
| **アンチチート互換性** | Valorant等のカーネルレベルAC非対応 |
| **ゲームライブラリ依存** | Steamライブラリ前提で他ストアのネイティブ対応は限定的 |
| **dGPU環境の熟成度** | SteamOS 3.8でVRAM管理改善中だが開発途上 |

### 8-3. 家庭用ゲーム機（PS5 / Xbox Series X）

| 項目 | 内容 |
|------|------|
| **最適化効率** | 固定ハードウェアへの徹底最適化で同価格帯PC以上の性能発揮 |
| **安定性・一貫性** | ハードウェア起因のトラブルがほぼ皆無 |
| **セットアップ容易性** | 電源を入れればほぼすぐ遊べる |
| **コスト効率** | 同等性能のゲーミングPCより安く、安定した体験を提供 |
| **ユニファイドメモリ効率** | CPU/GPU間のデータコピーオーバーヘッドなし |
| **独占タイトル** | プラットフォーム限定の大作IPが存在 |
| **低レベルAPI** | GNM等の高効率専用APIを利用可能 |
| **上限性能の低さ** | ハイエンドPCには性能上限で大差をつけられる |
| **拡張・アップグレード不可** | 次世代機まで同スペックを維持せざるを得ない |
| **後期世代のパフォーマンス低下** | 発売末期には最新ゲームの動作が重くなりがち |
| **クローズドエコシステム** | MOD・カスタマイズ・他プラットフォームへのアクセスが制限 |

***

## 第9章：今後の展望

### 9-1. Steam Machineとコンソール型PCの台頭

2026年のSteamOS 3.8はSteam Machineへの「初期サポート」を明言した。SteamOSをプリインストールした据え置きゲーミングPCとして設計されるSteam Machineは、「汎用OSの自由度」と「専用OS的な最適化・軽量性」を組み合わせる試みである。これが成功すれば、「汎用OS vs 専用OS」の二項対立は崩れ、中間的な存在が市場を変える可能性がある。[[33](#ref-33)][[3](#ref-3)]

### 9-2. Windowsの改善とLTSCという選択肢

Windows 11の25H2アップデートでは、TechSpotの14ゲーム平均ベンチマーク（Ryzen 7 9800X3D + RTX 5090環境）において、Windows 10と比較して1080pで約4%、1440p・4Kで約5%の性能向上が確認された。Ryzen向けの分岐予測最適化（24H2で導入され、その後Windows 10にもバックポート）が大きく寄与している。一方で、最小限のバックグラウンドプロセスと低テレメトリを特徴とするWindows LTSC（Long-Term Servicing Channel）を選択することで、ゲーミングに特化した軽量なWindows環境を構築できるという選択肢も存在する。[[43](#ref-43)][[44](#ref-44)]

### 9-3. XboxとPCの統合路線

MicrosoftはXboxとWindowsのゲームエコシステム統合を積極的に推進している。Xbox Series Xで採用されたDirectStorage APIはすでにWindowsにも移植されており、NVMe SSD環境でのロード時間短縮と非同期アセットストリーミングをPC上でも実現しつつある。これはPC側がコンソールの技術的優位を吸収する動きとも言える。[[25](#ref-25)][[7](#ref-7)]

### 9-4. ユニファイドメモリのPC導入

2025年末以降の報道によれば、MicrosoftはPC向けWindowsにコンソール的なユニファイドメモリアーキテクチャのサポートを検討しているとされる。Apple M系チップがすでに証明したようにユニファイドメモリはCPU/GPU間コピーオーバーヘッドを排除し、帯域幅と効率を大幅に改善できる。これが実現すれば、現在コンソールが持つ主要なアーキテクチャ上の優位点の一つが消滅する。[[45](#ref-45)][[22](#ref-22)]

***

## 結論：どちらを選ぶべきか

「汎用OSか専用OSか」の優劣は一概には決まらず、ユーザーの目的と価値観に依存する。

- **最大性能・最高グラフィックスを追求するなら**：ハイエンドPCが唯一の選択肢
- **安定性・手軽さ・コスト効率を求めるなら**：コンソールが圧倒的に合理的
- **同一ハードウェアで可能な限りPCゲームを軽量に動かしたいなら**（特にハンドヘルド）：SteamOSが現在最良の選択肢のひとつ
- **競技系オンラインゲームやGame Pass利用が前提なら**：WindowsまたはXboxが現実的

ゲームプランナーの視点では、 **コンソール向け設計がゲームの品質基準を定義し、PC版はその上限を押し上げるという関係** が現在の業界標準になっている。開発初期にコンソールの固定スペックで品質を確定させ、PC版では段階的な設定とスケーリングを提供するアプローチが、リリース品質と開発コストのバランスとして広く採用されている。[[46](#ref-46)]

汎用OSの「自由と複雑さ」と専用OSの「制約と効率」は、ゲーム設計の哲学にも直結している。この緊張関係は、SteamOSやSteam MachineのようなOSが登場するたびに新しい解答を提示し続けるだろう。

---

## References

<a id="ref-1"></a>1. [Why can't we create an OS dedicated for gaming? : r/pcmasterrace](https://www.reddit.com/r/pcmasterrace/comments/jorxfe/why_cant_we_create_an_os_dedicated_for_gaming/)

<a id="ref-2"></a>2. [SteamOS Gets New Update for March 2026 - OpenCritic](https://opencritic.com/news/28440/steamos-gets-new-update-for-march-2026)

<a id="ref-3"></a>3. [SteamOS 3.8 Adds Support for Steam Machine and More - gHacks](https://www.ghacks.net/2026/03/22/steamos-3-8-adds-support-for-steam-machine-and-expands-to-more-pcs/)

<a id="ref-4"></a>4. [Sonyが公式に「PS5のOSはFreeBSDである」と明言した事実は…(Twitter / X)](https://x.com/masayuki_koba/status/1995550440382234864)

<a id="ref-5"></a>5. [Orbis OS‐FreeBSDをベースにPlayStation 4向けに最適化された独自OS - kopenguin](https://kopenguin.com/post-108493/)

<a id="ref-6"></a>6. [Inside the PlayStation OS: how BSD changed Sony's consoles forever - Generation Amiga](https://www.generationamiga.com/2026/02/04/inside-the-playstation-os-how-bsd-changed-sonys-consoles-forever/)

<a id="ref-7"></a>7. [What does it mean that Xbox OS is based on Windows? - Reddit](https://www.reddit.com/r/xbox/comments/1jjkzy1/what_does_it_mean_that_xbox_os_is_based_on_windows/)

<a id="ref-8"></a>8. [[PDF] Xbox Series X System Architecture - HotChips 2020](https://hc32.hotchips.org/assets/program/conference/day1/HotChips2020_GPU_Microsoft_Jeff_Andrews_v2.pdf)

<a id="ref-9"></a>9. [Speed test pits six generations of Windows against each other - Tom's Hardware](https://www.tomshardware.com/software/windows/speed-test-pits-six-generations-of-windows-against-each-other-windows-11-placed-dead-last-across-most-benchmarks-8-1-emerges-as-unexpected-winner-in-this-unscientific-comparison)

<a id="ref-10"></a>10. [Why Background Apps Kill Performance (And How to Stop Them) - Git Support](https://gitsupport.co.uk/%F0%9F%A7%A0-why-background-apps-kill-performance-and-how-to-stop-them/)

<a id="ref-11"></a>11. [Benchmarking Windows Against Itself, From Windows XP To Windows 11 - Hackaday](https://hackaday.com/2026/01/02/benchmarking-windows-against-itself-from-windows-xp-to-windows-11/)

<a id="ref-12"></a>12. [Windows 11 will hobble gaming performance by default on some prebuilt PCs - PC Gamer](https://www.pcgamer.com/windows-11-pcs-can-hobble-gaming-performance/)

<a id="ref-13"></a>13. [Tested: Default Windows VBS Setting Slows Games Up to 10%, Even on RTX 4090 - Tom's Hardware](https://www.tomshardware.com/news/windows-vbs-harms-performance-rtx-4090)

<a id="ref-14"></a>14. [Should You Enable Hardware Accelerated GPU Scheduling? - Windows Forum](https://windowsforum.com/threads/windows-hags-should-you-enable-hardware-accelerated-gpu-scheduling.392511/)

<a id="ref-15"></a>15. [Game mode and Hardware Accelerated GPU Scheduling (HAGS) - MSFS Forums](https://forums.flightsimulator.com/t/tested-game-mode-and-hardware-accelerated-gpu-scheduling-hags/389677)

<a id="ref-16"></a>16. [Optimizing Windows 11 for Real-Time Performance: A LatencyMon Analysis - HD Opti](https://hdopti.com/articles/latency-comparison)

<a id="ref-17"></a>17. [7 things a console does better than a gaming PC - XDA Developers](https://www.xda-developers.com/things-console-better-than-gaming-pc/)

<a id="ref-18"></a>18. [Game Creation for Consoles: How Studios Adapt to Different Hardware - ZVKY](https://www.zvky.com/blogs/articles/game-creation-for-consoles-how-studios-adapt-to-different-hardware-limitations)

<a id="ref-19"></a>19. [ELI5: Why do expensive gaming PCs still struggle to run some games - Reddit](https://www.reddit.com/r/explainlikeimfive/comments/1jci1uj/eli5_why_do_expensive_gaming_pcs_still_struggle/)

<a id="ref-20"></a>20. [System Reservations on PS4, PS5, Xbox One, Xbox Series X｜S - Beyond3D Forum](https://forum.beyond3d.com/threads/system-reservations-on-ps4-4pro-ps5-xbox-one-one-s-one-x-and-xbox-series-x-s-2019-12-2020-03.61513/)

<a id="ref-21"></a>21. [How Much RAM is Good for Gaming – Optimal RAM Recommendation - Hone.gg](https://hone.gg/blog/optimal-ram-recommendation/)

<a id="ref-22"></a>22. [Unified Memory - Carleton University School of Computer Science](https://carleton.ca/scs/2025/unified-memory/)

<a id="ref-23"></a>23. [Storage Matters: Why Xbox and Playstation SSDs Usher In A New Era of Gaming - AnandTech](http://seasonedgaming.com/2020/11/03/xbox-series-x-and-ps5-a-deeper-look-at-the-tech-that-powers-the-new-consoles/)

<a id="ref-24"></a>24. [PlayStation Game Development: The Complete PS5 SDK Guide - Generalist Programmer](https://generalistprogrammer.com/tutorials/playstation-game-development-ps5-sdk-guide)

<a id="ref-25"></a>25. [What is Xbox Series X Velocity Architecture? - Windows Central](https://www.windowscentral.com/xbox-velocity-architecture)

<a id="ref-26"></a>26. [Games run faster on SteamOS than Windows 11, Ars testing finds - Ars Technica](https://arstechnica.com/gaming/2025/06/games-run-faster-on-steamos-than-windows-11-ars-testing-finds/)

<a id="ref-27"></a>27. [Modern Games Are Running Better on SteamOS Than Windows 11 - ProPakistani](https://propakistani.pk/2025/06/26/modern-games-are-running-better-on-steamos-than-windows-11-report/)

<a id="ref-28"></a>28. [Lenovo Legion Go S: Windows 11 vs SteamOS Performance - Boiling Steam](https://boilingsteam.com/lenovo-legion-go-s-windows-vs-steam-os-performance/)

<a id="ref-29"></a>29. [Cyberpunk 2077 and Red Dead Redemption 2 tested at 4K Ultra on SteamOS and Windows 11 - Notebookcheck](https://www.notebookcheck.net/Cyberpunk-2077-and-Red-Dead-Redemption-2-tested-at-4K-Ultra-on-SteamOS-and-Windows-11-offering-a-snapshot-of-Linux-gaming-in-2026.1201785.0.html)

<a id="ref-30"></a>30. [Does Proton really use more CPU/Memory than a native Windows port? - Reddit](https://www.reddit.com/r/linux_gaming/comments/1noqccx/does_proton_really_use_more_cpumemory_than_a/)

<a id="ref-31"></a>31. [Any reason not to install windows and use it exclusively? - Steam Community](https://steamcommunity.com/app/1675200/discussions/0/599640708794608877/)

<a id="ref-32"></a>32. [Compatible Steam Deck games now include a popular title with anti-cheat - Notebookcheck](https://www.notebookcheck.net/Compatible-Steam-Deck-games-now-include-a-popular-title-with-anti-cheat-as-Linux-gaming-gains-traction.1059929.0.html)

<a id="ref-33"></a>33. [SteamOS 3.8.0 Preview Launches With Initial Steam Machine Support - SteamDeckHQ](https://steamdeckhq.com/news/steamos-3-8-0-preview-intial-steam-machine-support/)

<a id="ref-34"></a>34. [Valve's new Steam Deck update boosts battery life and performance - Pocket Tactics](https://www.pockettactics.com/steam-deck/update-march-2026)

<a id="ref-35"></a>35. [Huge SteamOS 3.8 Update Preps for Steam Machine and Legion Go 2 - NerdZap](https://nerdzap.com/news/steam-machine-legion-go-2-steamos-3-8-patch-notes/)

<a id="ref-36"></a>36. [Steam Machine Pushed to 2026 ｜ Anti-Cheat Problem SOLVED - YouTube](https://www.youtube.com/watch?v=OB0CTSaEo3A)

<a id="ref-37"></a>37. [If Xbox Series X is more powerful, why do some PS5 games look better? - Reddit](https://www.reddit.com/r/PS5/comments/1dt08lm/df_weekly_if_xbox_series_x_is_more_powerful_why/)

<a id="ref-38"></a>38. [Vulkan vs DirectX 12 Performance Comparison - DaydreamSoft](https://www.daydreamsoft.com/blog/vulkan-vs-directx-12-performance-comparison-for-modern-game-development)

<a id="ref-39"></a>39. [Console vs. PC Gaming: Which Is Better? - Seagate](https://www.seagate.com/blog/console-vs-pc-gaming/)

<a id="ref-40"></a>40. [The PlayStation 5 Pro's performance is roughly on par with the RTX 5060 Ti and Radeon 9060 XT - Notebookcheck](https://www.notebookcheck.net/The-PlayStation-5-Pro-s-performance-is-roughly-on-par-with-the-RTX-5060-Ti-and-Radeon-9060-XT-according-to-the-latest-Digital-Foundry-tests.1054099.0.html)

<a id="ref-41"></a>41. [Partner with the Best Game Porting Services for Your Game - Juego Studio](https://www.juegostudio.com/blog/an-in-depth-look-at-the-game-porting-process)

<a id="ref-42"></a>42. [Game Porting: Reasons, Stages, Cases, and Pro Tips - Stepico](https://stepico.com/blog/game-porting-reasons-stages/)

<a id="ref-43"></a>43. [Windows 11 25H2 vs Windows 10: Which is Faster for Gaming? - TechSpot](https://www.techspot.com/article/3081-windows-11-vs-windows-10-gaming/)

<a id="ref-44"></a>44. [Today I found out that I'm using the wrong edition of Windows to play - Reddit](https://www.reddit.com/r/pcmemes/comments/1l2hy0n/today_i_found_out_that_im_using_the_wrong_edition/)

<a id="ref-45"></a>45. [Windows PC may support unified memory as part of the Xbox-PC merger - Reddit](https://www.reddit.com/r/pcmasterrace/comments/1pi31hh/windows_pc_may_support_unified_memory_as_part_of/)

<a id="ref-46"></a>46. [How to get better fps on PC while porting games to consoles - Game Developer](https://www.gamedeveloper.com/programming/how-to-get-better-fps-on-pc-while-porting-games-to-consoles-)
