# ゲームにおけるレイトレーシング——リアルな光表現の可能性と限界

***

## はじめに

レイトレーシング（Ray Tracing）とは、光の振る舞いを物理的にシミュレートする描画技術である。現実世界の光は、光源から放たれて物体に当たり、反射・屈折・吸収を繰り返しながら最終的に人間の目（あるいはカメラ）に到達する。レイトレーシングはこのプロセスを逆向きに計算し、「カメラから光線（レイ）を飛ばしてシーン内の物体との交差を調べる」というアルゴリズムで近似する。映画のCGIでは長年用いられてきた技術だが、リアルタイム処理が求められるゲームに本格的に導入されたのは2018〜2019年頃——NVIDIAがGeForce RTXシリーズを発売し、専用ハードウェア（RT Core）を搭載してからである。[[1](#ref-1)][[2](#ref-2)]

2020年に発売されたPlayStation 5（PS5）およびXbox Series X｜Sは、GPUにAMD RDNA 2アーキテクチャを採用し、コンソールとして初めてハードウェアアクセラレーションによるレイトレーシングをネイティブサポートした[[3](#ref-3)]。これにより、PCだけでなくコンソール市場においても「RTゲーム」が標準的な存在となった。

しかし、レイトレーシングはあらゆるシーンに等しく効果をもたらすわけではない。「オンにすれば美しくなる」という単純な話ではなく、シーン特性・用途・フレームレートや解像度に割ける処理余力との兼ね合いによって、 **レイトレーシングが圧倒的に有効な場面** と、 **従来の擬似的なアプローチの方が効率よく同等の視覚品質を達成できる場面** とが明確に存在する。本稿では、2022〜2025年の具体的なタイトルを取り上げながら、その実像を解説する。

***

## 擬似反射技術の基礎：SSRとキューブマップ

レイトレーシングが普及する以前、ゲームにおける反射・間接照明は主に次の3種類の「ごまかし」技術で実現されていた。これらを理解することが、レイトレーシングの価値を正確に把握する出発点となる。

### スクリーンスペースリフレクション（SSR）

SSRは、すでにラスタライズされたフレームバッファの画像情報を再利用してリフレクションを計算する手法である。原理は比較的シンプルで、深度バッファとノーマル情報を用いて「反射方向へレイマーチング（逐次サンプリング）を行い、画面内の交点を見つけてその色を参照する」というものだ。[[4](#ref-4)][[5](#ref-5)][[6](#ref-6)]

SSRの最大の強みは、動的に動くオブジェクトのリフレクションをリアルタイムで生成できることと、曲面に対して正しいパースペクティブを持った反射を表現できることである。一方で、 **画面外の情報は参照不可能** という構造的な制約が致命的な弱点になる。カメラが斜めを向いているとき、あるいは鏡面が画面端にあるとき、反射すべきオブジェクトが画面外に消えると、その部分の反射情報は欠落し、アーティファクトや不自然な反射の途切れが発生する。[[5](#ref-5)][[7](#ref-7)][[4](#ref-4)]

### キューブマップ（リフレクションプローブ）

キューブマップは、シーン内の特定地点（プローブ）から六方向に事前レンダリングした画像をキューブ状に貼り合わせ、それを反射として利用する手法である。静的なキューブマップは非常に安価で、遠景の環境反射などには今日でも多用される。動的なキューブマップ（リフレクションプローブのリアルタイム更新）は、より正確だが、レンダリングパスが増えてコストが上がる。[[8](#ref-8)][[9](#ref-9)]

根本的な問題は、キューブマップが「単一の視点から見た6枚の画像」に過ぎないため、 **反射面が視点から離れるにつれてパースが崩れる** という点だ。さらに、マテリアルの品質やプローブ密度によって反射の精度が大きく左右され、アーティストが多大な手作業でカバーエリアを調整する必要がある。[[9](#ref-9)][[8](#ref-8)]

### ハイブリッドアプローチ

現実のゲームでは、SSRとキューブマップを組み合わせた「ハイブリッド反射」が広く使われる。SSRで画面内の高精度な反射を担い、画面外など情報が得られない部分はキューブマップにフォールバックするという構造である。このアーキテクチャは現在でも、レイトレーシングのコストを抑えたい場面で選択される。[[10](#ref-10)]

***

## レイトレーシングが「効く」場面

### 1. 屋内・暗所のグローバルイルミネーション

レイトレーシングの恩恵が最も顕著に現れるのは、屋内環境や薄暗いシーンにおけるグローバルイルミネーション（GI：間接照明）である。窓から差し込む光が床に反射して天井をほのかに明るくする「ライトブリード」、蛍光灯が壁の色を周囲に染める「カラーブリーディング」——こうした効果は、ベイク（事前計算）ベースのGIや単純な環境光では再現が難しい。

**Metro Exodus Enhanced Edition（2021）** はその代表的な事例である。4A Gamesは「Enhanced Edition」で全ての照明をレイトレースドGIに置き換え、旧来の静的GIを完全廃止した。標準版では太陽（と空）を主たる光源とした1バウンスのGIのみに対応していたが、Enhanced Editionでは太陽・空に加えて最大256の光源が1ピクセルの最終色に寄与し、複数バウンスの再帰的な光の伝播を実現した。ローソクの炎がテーブルの下面をオレンジに染め、窓外の雪面が室内の床に青白い光をこぼす——こうした現象が完全にダイナミックかつリアルタイムで機能する。[[11](#ref-11)][[12](#ref-12)]

**Control（Remedy Entertainment、2019/PC〜現行コンソール）** も重要なタイトルである。Remedyはレイトレースドリフレクション（不透明・透明の両対応）、レイトレースドGI（拡散照明）、コンタクトシャドウを組み合わせた実装を行った。特に重要なのは、廊下で銃撃が起こると爆炎の光が壁に動的にバウンスし、周囲の暗い場所を瞬時に照らすという演出で、これはベイクGIでは不可能な表現である。[[13](#ref-13)][[14](#ref-14)]

**グローバルイルミネーションのコストは大きく、RTアンビエントオクルージョン（AO）の約5〜10%に対し、RT-GIは30〜40%のFPS低下をもたらす** ことが一般的に報告されている。そのため、PS5・Xbox Series Xでは多くのタイトルがコンソールの品質モードでのみRT-GIを有効化し、パフォーマンスモードではベイクGIに切り替えるという設計が定石となっている。[[15](#ref-15)]

### 2. 金属・鏡面上の正確な反射（オフスクリーン含む）

レイトレーシングが反射に有効なのは、SSRが構造的に解決できない「画面外オブジェクトの反射」を自然に処理できるからである。[[14](#ref-14)]

**Marvel's Spider-Man: Miles Morales（PS5、2020）** では、マンハッタンの高層ビルのガラス外壁や路面の水たまりにレイトレースドリフレクションを採用した。開発元Insomniacは発売時、ネイティブ4K・30fpsの「Fidelityモード」でRTを提供し、「スパイダーマンが壁を走ると、その姿が建物のガラスに正しく映り込む」という表現を実現した。発売後のパッチでは、解像度・反射品質・群衆密度を抑える代償としてRTを60fpsで動かす「Performance RT」モード（約1080p〜1440p）も追加された。同社の **ラチェット&クランク パラレル・トラブル（2021）** では、金属製の床・装甲・クランクの顎の下といった光沢面すべてにRT反射が適用され、30fps固定のフィデリティモード、60fps固定のパフォーマンスモード、そして動的解像度スケーリング（1080p〜1440p）を使用してRT反射を60fpsで動かすPerformance RTモードの3択を提供した。[[16](#ref-16)][[17](#ref-17)][[18](#ref-18)][[19](#ref-19)][[20](#ref-20)]

**グランツーリスモ7（PS5/PS5 Pro）** は、レーシングゲームにおけるRT反射の活用例として特筆すべき存在である。標準PS5では、RT反射はリプレイ・フォトモード・ガレージメニューのみで動作し、**実際のレース中には使用されていない**。これは処理負荷とフレームレートの兼ね合いによる判断で、リプレイ時のみ60fpsでRT自己反射（ウィングミラーのボディへの映り込みなど）を提供する設計だ。PS5 Proでは、BVH8（1ノードあたり8個のバウンディングボックスを扱う8幅のBounding Volume Hierarchy）という新しいRT加速機構により、Sony公称で従来比最大2〜3倍のRTパフォーマンス向上が達成され、ようやくレース中60fpsでのRT反射が実現した。[[21](#ref-21)][[22](#ref-22)][[23](#ref-23)]

### 3. パストレーシングによる全面統合照明

レイトレーシングの最も高度な形態が **パストレーシング** であり、これは直接照明・間接照明・反射・シャドウのすべてを統一的なレイ計算で処理する技術である。現時点では最高性能のGPUを必要とするが、2023〜2024年にかけて商業ゲームへの実装が現実的になった。[[24](#ref-24)]

**サイバーパンク2077 RT Overdrive（2023）** はパストレーシングをAAA商業ゲームに実装した最初の事例の一つである。CD Projekt Redが「RT Overdrive」モードとして実装したこの機能は、RTXDI（直接照明のRTサンプリング）とReSTIR GI（間接照明のパストレース）を組み合わせ、ナイトシティのネオンサインや室内灯すべてが影を落とし、発光体が独立した二次光源として機能する。パストレーシング以前は、限られたシャドウキャスティングライトの仕様によりネオン群の影が出ていなかったが、Overdriveではあらゆる光源がピクセル精度のソフトシャドウを投射する。ただし動作要件は非常にシビアで、CD Projekt Redの推奨ではRTX 30シリーズはRTX 3090/3090 Tiで1080p・30fpsがやっと、快適に動かすにはRTX 40シリーズ（4070 Ti以上）とDLSS 3の使用が事実上の前提とされた。[[25](#ref-25)][[26](#ref-26)]

**Alan Wake 2（Remedy、2023）** も全面パストレーシングで設計されたタイトルである。RT MediumとRT Highプリセットはともにパストレーシングを有効化し、それぞれ1バウンス・3バウンスで光を追跡する。NVIDIA公称では、4K・全設定最大でDLSS 3.5（フレーム生成・Ray Reconstruction含む）を併用した場合に最大約4.5倍のフレームレート向上がうたわれ（RTX 4090で約4.1倍、RTX 4080/4070 Tiで約4.7倍）、RTなしでの実用的なプレイは極めて困難である。[[27](#ref-27)][[28](#ref-28)]

**インディ・ジョーンズ/大いなる円環（MachineGames、2024）** は、標準でRTGI（レイトレースドグローバルイルミネーション）を搭載した上で、PC版では「Full Ray Tracing（フルRT）」アップグレードを追加提供した。屋外開放エリア（バチカン、ジャングル）では恩恵が限定的だが、インドアの神殿内部・遺跡の暗部では「オフラインレンダリングとの差が消えるほど」のリアルな間接照明が実現した。RTX 4070クラスで1440pの大半の恩恵を享受できる現実的な要件設計も評価されている。なお本作は2024年12月にXbox Series X｜S／PCで先行発売され、2025年4月17日にPS5版（PS5 Pro強化対応）も発売された。[[29](#ref-29)]

***

## レイトレーシングが「効きにくい」場面

### 1. 屋外の昼間シーン

皮肉なことに、直感的に「リアルさが求められる」と思いがちな屋外の明るい昼間シーンは、レイトレーシングの効果が最も薄い状況の一つである。屋外では支配的な光源が太陽（一点のディレクショナルライト）であり、従来のシャドウマップでも高品質なシャドウを生成できる。また、空のIBL（Image-Based Lighting）とスクリーンスペースアンビエントオクルージョン（SSAO）の組み合わせで間接照明を十分近似できるため、RTのコストに見合った視覚的差異が出にくい。[[30](#ref-30)]

**アサシン クリード シャドウズ（Ubisoft、2025）** はオープンワールドでRTGIを実装したが、その技術的アーキテクチャが示す課題は興味深い。同作はハイブリッドRTGIシステムを採用し、画面内スペースのレイ→ワールドスペースのハードウェアレイ→DDGIプローブカスケードを組み合わせた三段構成を採用している。コンソール（標準PS5）のパフォーマンスモードではハードウェアRTGIを使用せずベイクGIにフォールバックするが、これは「コスト対効果の観点で屋外昼間シーンでは差が小さい」という判断が反映されている。PS5 Proではその分の演算余力がRT反射の追加に回されており、開発チームのプライオリティが反射 ＞ GIの順であることが読み取れる。[[31](#ref-31)][[23](#ref-23)]

### 2. カメラ視点が速く動くシーン・競技系ゲーム

レイトレーシングはフレームあたりの計算量が大きいため、高フレームレートとの両立が困難である。特に144fps以上を求められる競技系シューターでは、RTを有効にするとフレームレートが半分以下になることも珍しくなく、実用的でない。[[32](#ref-32)]

**Call of Duty** シリーズや **Apex Legends** のような高速アクションゲームでは、RT機能を搭載しつつも公式推奨設定では「RT Off」または最低品質を強く推奨する。競技性の高いゲームでは「フレームレートの安定性」が視覚品質を圧倒的に上回る優先事項だからである。[[15](#ref-15)]

### 3. スタイライズド・アート方向性のゲーム

セルシェーディングや手描き風アートを採用したゲームでは、物理ベースの正確な照明が「アーティストの意図」と衝突することがある。『ゼルダの伝説』シリーズなどは過去にフォトリアルなレイトレーシング対応の非公式Modが試みられたが、アート方向性が破綻するため公式には採用されていない。

### 4. キューブマップの方が優れているケース

精密に調整された静的・動的キューブマップが適切に実装されている場合、レイトレーシングに劣らない視覚品質を達成できるシーンは存在する。とりわけ、反射面が小さく遠景のみを映す場合（例：広大な平野の水面の空の映り込み）は、ローカルなキューブマップだけで十分な品質が得られ、レイトレーシングを追加投入するコストメリットは低い。SSRも、カメラの動きが緩やかで反射するオブジェクトが常に画面内に収まるゲームデザインであれば、アーティファクトなく高品質な反射を提供できる。[[33](#ref-33)][[4](#ref-4)]

***

## 2022〜2025年 主要タイトル比較表

| タイトル | RT機能 | 効果的なシーン | コンソールでの制約 | PS5/Xbox対応 |
|---|---|---|---|---|
| Metro Exodus EE（2021） | 全面RTGI（256光源・複数バウンス） | 屋内・トンネル・地下 | Xbox Series Sは1080pに低下 | PC / PS5 / Xbox Series X｜S（2021年6月） |
| ラチェット&クランク パラレル・トラブル（2021） | RT反射（光沢面全般） | 金属・鏡面・廊下 | 60fps RT時に解像度大幅低下 [[20](#ref-20)] | PS5専用 |
| グランツーリスモ7（2022/PS5 Pro対応） | RT反射（ゲームプレイ中はPS5 Proのみ） | ボディの金属反射・ガレージ照明 | 標準PS5ではリプレイ限定 [[21](#ref-21)] | PS5/PS5 Pro |
| Control（PS5/XSX） | RT反射＋RTGI＋コンタクトシャドウ | 屋内・コンクリート廊下・爆炎 | RT品質モードで30fps固定 [[34](#ref-34)] | PS5/Xbox Series X |
| サイバーパンク2077 RT Overdrive（2023） | 全面パストレーシング | 室内・ネオン街・ガラス反射 | Overdrive（パストレ）はコンソール非対応 [[26](#ref-26)] | 本編はPS5/XSX。OverdriveはPCのみ |
| Alan Wake 2（2023） | 全面パストレーシング（1〜3バウンス） | 森林・工場内部・水面 | コンソール版はパストレ非対応 [[28](#ref-28)] | PS5/XSX/PC。パストレはPCのみ |
| Forza Motorsport（2023） | RTGI＋RT反射 | ピット・ガレージ照明・車体反射 | コンソールは当初RT反射のみ。2024年12月の更新でXSXにもRTGI追加 [[35](#ref-35)] | Xbox Series X｜S / PC |
| アバター：フロンティア・オブ・パンドラ（2023） | RTGI＋ **RTオーディオ** | 森林内部・基地内・洞窟 | 30fps品質モード限定 | PS5/Xbox Series X｜S |
| インディ・ジョーンズ/大いなる円環（2024） | RTGI＋Full RT（PC） | 遺跡内部・洞窟・宮殿廊下 | コンソール版はRTGI標準（フルRTはPC） [[29](#ref-29)] | Xbox Series X｜S / PC / PS5（2025年4月） |
| アサシン クリード シャドウズ（2025） | RTGI＋RT反射（PS5 Pro強化版） | 屋内・社寺建築・雨天 | 標準PS5パフォーマンスモードでRTなし [[23](#ref-23)] | PS5/Xbox Series X｜S |

***

## 擬似反射 vs. レイトレーシング：性能コストの現実

レイトレーシングの導入コストをRTエフェクトの種類別に整理すると、以下のような一般的傾向がある。[[15](#ref-15)]

| RTエフェクト | FPSへの影響（目安） | 視覚的インパクト | 推奨用途 |
|---|---|---|---|
| RT アンビエントオクルージョン（AO） | 約5〜10%低下 | 中（接触影の精度向上） | 多くのシーンで費用対効果良好 |
| RT シャドウ | 約10〜15%低下 | 高（ソフトシャドウ・微細影） | 重要オブジェクト周辺に限定適用 |
| RT リフレクション | 約15〜25%低下 | 非常に高（金属・水面） | 光沢面が目立つシーンに有効 |
| RT グローバルイルミネーション | 約30〜40%低下 | 高（間接照明の統一感） | 屋内・暗所シーン最優先 |
| パストレーシング（全面） | 50%以上〜実用不能 | 最高（全照明の物理統合） | ハイエンドPCの静止画・限定シーン |

コンソールでの実際の実装を見ると、PS5・Xbox Series XでRT反射を60fpsで動かすには、 **レンダリング解像度を動的に下げる（DRS）かフレームレートを30fpsに制限するか、どちらかの選択を迫られる** 場合がほとんどである。ラチェット&クランク パラレル・トラブルの「Performance RT」モードが典型例で、動的解像度スケーリングを1080p〜1440pで使い、60fps＋RT反射を実現した。[[17](#ref-17)][[20](#ref-20)]

PS5 Pro（2024年発売）は、BVH8加速のサポートによりRT演算を従来比最大2〜3倍に高速化し、グランツーリスモ7やアサシン クリード シャドウズでRT反射＋高フレームレートの同時達成を可能にした。これは「RTをフルに活かすにはPS5世代の演算能力では不十分」という現実的な評価の裏返しでもある。[[23](#ref-23)]

***

## ハイブリッドRT：現在の「最適解」

完全なパストレーシングは美しいが、現行コンソールではリアルタイムで動かすには重すぎる。一方、全くRTを使わないラスタライズ（SSR＋キューブマップ）は手作業のアーティスト工数がかかる上に表現の限界がある。

現代の多くのAAA開発は **ハイブリッドRT** アプローチを採用している。アサシン クリード シャドウズのRTGIは「まずスクリーンスペースでレイを飛ばし、ヒットしなければ初めてワールドスペースのハードウェアRTに昇格する」という段階的最適化構造を持つ。Senua's Saga: Hellblade 2（2024）はNanite＋Lumen（Unreal Engine 5の **ソフトウェアRT**）でハードウェアRTを使わずに高品質な間接照明を実現しており、「レイトレーシングのような結果を、ハードウェアRTなしに近似できるか」を追求した好例である。[[36](#ref-36)][[37](#ref-37)][[31](#ref-31)]

***

## コラム：光ではなく「音」のレイトレーシング

レイトレーシングの応用が視覚表現のみにとどまらないことは、知る人ぞ知る事実である。 **音響伝播（Sound Propagation）** へのレイトレーシング適用は、光のシミュレーションとアルゴリズム的に非常に近い構造を持つ。[[38](#ref-38)][[39](#ref-39)]

### 原理

音波も光と同様に「波」であり、物体に当たると反射・吸収・回折が起きる。音響レイトレーシングでは、音源からレイを球状に放射し、それが壁・床・天井・小道具に当たって反射・減衰する経路を追跡する。最終的に各レイの寄与を集計することで、その空間の残響（リバーブ）・エコー・音の遮蔽（オクルージョン）を物理的に算出する。[[40](#ref-40)][[39](#ref-39)]

従来の音響処理は「1つの部屋には1種類のリバーブ」という粗い近似で、ゲームデザイナーが手作業でゾーンごとに残響パラメータを設定していた。音響RTでは、ジオメトリと素材情報から自動的に残響が算出されるため、巨大な複雑な環境でも人手を介さず自然な音響を実現できる。[[40](#ref-40)]

### Xbox Series Xのアーキテクチャ的サポート

Microsoftは2020年のXbox Series X発表時点で、ハードウェアRTアクセラレーターを **オーディオの空間音声処理にも転用可能** であることを明言していた。Xbox開発プログラム管理部長のJason Ronaldは「ハードウェアRTにより、よりリアルなライティングや反射だけでなく、空間オーディオにも活用できる。レイトレースドオーディオによってさらなる没入感をもたらすことができる」と発言した。これはGPUのRTコアを音響計算に流用するというアーキテクチャ的な設計思想を示している。[[41](#ref-41)][[42](#ref-42)][[43](#ref-43)]

### 実際の商業ゲームへの実装：アバター：フロンティア・オブ・パンドラ

2023年12月にリリースされた **アバター：フロンティア・オブ・パンドラ（Massive Entertainment/Ubisoft）** は、商業用AAA規模のゲームとして初めて **GPUレイトレーシングを音響伝播に実際に採用したタイトル** として注目される。[[44](#ref-44)][[38](#ref-38)]

同作を開発するMassive Entertainmentのオーディオプログラマー、Kasparas Eidukonis氏は技術解説でこう述べている：「光と同様に、音も波として記述できる。ただし、物体に当たったときの振る舞いが違うだけだ。我々はレイを放って音を伝播させる。放つレイが多ければ多いほど、その空間がどう聴こえるかをより正確に把握できる」。[[38](#ref-38)]

同作の舞台であるパンドラの密林は、木々・葉・岩・断崖・水流が複雑に入り組んだ環境であり、従来の「建物の角ばったジオメトリに最適化された音響遮蔽システム（The Division 2から転用）」では適切に機能しなかった。GPUレイトレーシングを導入したことで、「岩は不透明、茂みはレイが通過しやすい」という素材の透過特性も自動的に計算され、アーティストが個々の岩や茂みに手動で音響属性を設定する必要がなくなった。[[38](#ref-38)]

また、CPU処理からGPU処理に移行したことで、より多くのレイをより高速にサンプリングできるようになり、CPUの負荷を解放して他の処理に使用できるというアーキテクチャ的メリットも得られた。なお、完全な物理シミュレーションは「感覚過負荷」を引き起こすため、ゲームプレイとストーリーテリングのニーズに合わせてパラメータを調整したハイブリッドシステムを採用したことも、オーディオディレクターのAlex Riviere氏が強調している。[[38](#ref-38)]

### 今後の展望

Vercidiumが開発中のUE5・Godot向けオーディオレイトレーシングプラグインのような取り組みも始まっており、将来的に汎用エンジンレベルでの音響RTサポートが普及すれば、没入型の空間音声表現が次のゲームグラフィックス革命——いや、「ゲームオーディオ革命」の中心に立つ可能性を秘めている。Lese社の技術解説が指摘するように、音響RTのリバーブへの応用は既に学術・実装の両面で現実的な手法として確立されている。[[39](#ref-39)][[40](#ref-40)]

***

## まとめ：レイトレーシングを正しく使うために

レイトレーシングは「オンにすれば何でも良くなる魔法」ではなく、 **特定のシーン特性と組み合わさったとき初めてコストを上回る価値を生む技術** である。現行コンソール（PS5・Xbox Series X）の演算能力の現実と照らし合わせると、以下の設計指針が導き出される。

- **屋内・夜間・光沢素材の多いシーンにこそ優先的にRTを投入する**。コストに見合った視覚的差異が生じる。
- **開放的な屋外昼間シーンではSSR＋ベイクGIで十分なことが多い**。RTGIのコストは30〜40%のFPS低下を招くため、効果の薄い場所に適用することは避けるべきだ。
- **フレームレートが競技性に直結するジャンルではRTを切るか最小限に抑える** のが正解である。
- **RTの恩恵はアートディレクションに強く依存する**。フォトリアリズムを目指すゲームではRTの価値が最大化されるが、スタイライズドなゲームでは物理的正確さが必ずしも美しさに直結しない。

そしてゲームプランナーとして特に覚えておくべきは、 **「レイトレーシングで何を置き換えるか」と同等に「何を置き換えないか」を決断することがRTの正しい活用である**、という事実だ。ハイブリッドアプローチが現在の業界標準であり、RTGIをGPUに任せながらSSRを共存させるフローは、今後もさらに洗練されていくだろう。

## References

<a id="ref-1"></a>1. [What is Ray Tracing in Games ｜ CORSAIR][1] - In gaming, ray tracing simulates realistic lighting. That's it. Some of the effects it creates can b...

<a id="ref-2"></a>2. [Metro Exodus Enhanced With NVIDIA RTX Ray Traced ...][2] - Metro Exodus will feature Ray Traced Global Illumination, for vastly-improved natural lighting, and ...

<a id="ref-3"></a>3. [PlayStation 5: what to expect from next-gen console ray ...][3] - The Digital Foundry team convene to discuss their reactions to the PlayStation 5 reveal. It was also...

<a id="ref-4"></a>4. [Screen Space Reflections in Blightbound][4] - Since SSR can cast rays in any direction, it's very well suited for reflections on curved surfaces a...

<a id="ref-5"></a>5. [Screen Space Reflection - Viz Artist and Engine][5] - The main limitation of SSR is that it can only reflect objects which are visible. Objects in the for...

<a id="ref-6"></a>6. [Screen Space Reflections (SSR)][6] - Abstract—In this paper, we will describe what Screen Space. Reflections are and why they are an inte...

<a id="ref-7"></a>7. [Screen Space Reflection Artifacts Problem : r/gamedev][7] - It can't be "Screen Space" because if it's not in the screen buffer it can't be used for reflection....

<a id="ref-8"></a>8. [Reflection Probe performance][8] - The higher the resolution of a cubemap, the greater its rendering time will be. You can optimise pro...

<a id="ref-9"></a>9. [Why do Reflection Probes invert curved reflective surfaces ...][9] - Reflection probes are a cube map rendered from a single point in space (the center of the probe). It...

<a id="ref-10"></a>10. [Hybrid screen-space reflections - Interplay of Light][10] - Hybrid reflections, where raytracing is used to fill-in the areas that screenspace reflections can't...

<a id="ref-11"></a>11. [INSANE! Metro Exodus: Enhanced Edition vs Metro Exodus ...][11] - A lot has been said about Metro Exodus: Enhanced Edition full Ray Traced Global Illumination (RTGI) ...

<a id="ref-12"></a>12. [Metro Exodus: GeForce RTX Real-Time Ray Traced Global ...][12] - 4A Games are bringing real-time Ray Tracing to Metro Exodus! At NVIDIA's Gaming Celebration event in...

<a id="ref-13"></a>13. [Remedy Entertainment Adds NVIDIA RTX To Control, For ...][13] - Remedy has added ray-tracing to Control, starting with glossy Ray Traced Reflections, Ray Traced Dif...

<a id="ref-14"></a>14. [Control: A Visually Stunning Ray Traced Gem Of A Game ...][14] - With Control Remedy did a masterful job of creating an engrossing world that looks outstanding with ...

<a id="ref-15"></a>15. [Ray Tracing Optimization Guide for HP OMEN Gaming PCs][15] - Q: Which ray tracing effect has the biggest performance impact? A: Global Illumination causes the la...

<a id="ref-16"></a>16. [Spider-Man: Miles Morales Features Puddle Ray Tracing ...][16] - The new Spider-Man: Miles Morales game for PlayStation 5 will feature ray tracing in its puddles and...

<a id="ref-17"></a>17. [A closer look at PS5 ray tracing in Marvel's Spider-Man ...][17] - A huge improvement is clearly evident in reflections from the tallest skyscraper to the smallest pud...

<a id="ref-18"></a>18. [Marvel's Spider-Man PS5 Ray Tracing Analysis - The ...][18] - So basically vampires don't have a reflection because their reflection takes up a lot of raytracing ...

<a id="ref-19"></a>19. [Ratchet and Clank: Rift Apart on PS5 - this is why we need ...][19] - RDNA 2's ray tracing features are also deployed, with beautiful high resolution reflection work. Wel...

<a id="ref-20"></a>20. [Ratchet and Clank: Rift Apart - all three graphics modes ...][20] - The standard performance mode turns off ray tracing, reduces scene density, and pares back hair stra...

<a id="ref-21"></a>21. [Gran Turismo 7 Will Get a PS5 Pro Update With Raytracing ...][21] - Sony's $700 console will bring improved reflections on cars, or the option of an 8K mode, for a $250...

<a id="ref-22"></a>22. [Gran Turismo 7 on PS5 Pro will include ray tracing during ...][22] - Gran Turismo 7 to add ray-traced reflections between the cars in gameplay, while continuing to suppo...

<a id="ref-23"></a>23. [Assassin's Creed Shadows: Ubisoft deep dives into PS5 ...][23] - With our implementation of BVH8 support on PS5 Pro, we were able to speed up GPU tasks involving har...

<a id="ref-24"></a>24. [Cyberpunk 2077 Overdrive Mode Analysis: Path Tracing vs ...][24] - Path tracing generally makes the scene more illuminated as the additional ray bounces result in bett...

<a id="ref-25"></a>25. [Cyberpunk 2077 Ray Tracing: Overdrive Technology Preview ...][25] - Path tracing on a triple-A videogame? On THE triple-A videogame? Cyberpunk 2077 already pushed visua...

<a id="ref-26"></a>26. [Cyberpunk 2077 NVIDIA Ray Tracing Overdrive Mode PC ...][26] - Compared to standard ray tracing implementations, the path-traced image is way more balanced, it's w...

<a id="ref-27"></a>27. [alan-wake-2-dlss-3-5-full-ray-tracing-out-this-week - NVIDIA][27] - Activating ray tracing and DLSS in Alan Wake 2 on a GeForce RTX GPU automatically enables Ray Recons...

<a id="ref-28"></a>28. [Alan Wake 2 will have path tracing, DLSS 3 can provide up to 4.7X ...][28] - In Alan Wake 2, the RT Medium and RT High presets both enable path tracing, with the medium setting ...

<a id="ref-29"></a>29. [Indiana Jones and the Great Circle's full ray tracing ...][29] - So, shadows 'pop' their level of detail quality, light leaks through objects not properly accounted ...

<a id="ref-30"></a>30. [7 Problems Raytracing Doesn't Solve][30] - Rasterization must render every single triangle in the scene, whereas raytracing is only interested ...

<a id="ref-31"></a>31. [Assassin's Creed Shadows: inside the technologically ...][31] - Our hybrid RTGI system combines two steps: per-pixel ray tracing (screen space rays and world space ...

<a id="ref-32"></a>32. [4 reasons why ray tracing still isn't worth the performance hit][32] - Even if you have the fastest GPU on the market today, your FPS will drop by half the moment you enab...

<a id="ref-33"></a>33. [I'd rather have convincing cubemap reflections than ...][33] - Cubemaps are extremely hard to implement well. It does not work well in games where you move around ...

<a id="ref-34"></a>34. [Control PS5 vs Xbox Series X Ray Tracing 'Benchmark ...][34] - Did you know that Control's photo mode removes the 30fps cap in the ray traced graphics mode? It ope...

<a id="ref-35"></a>35. [Forza Motorsport Will Support Ray Traced Global ...][35] - Forza Motorsport will support ray traced global illumination on PC, which will improve visuals well ...

<a id="ref-36"></a>36. [Can Xbox Series S handle Senua's Saga: Hellblade 2?][36] - The game heavily relies on software ray tracing on all formats and doesn't seem to scale far above S...

<a id="ref-37"></a>37. [Senua's Saga: Hellblade 2 is a defining moment in ...][37] - This is where the talk of resolution comes in - as reported pre-release, the final game also present...

<a id="ref-38"></a>38. [Ray Tracing Audio in Snowdrop: Creating a Living Pandora][38] - When sound propagation works well, you might not pick up on it consciously, but when something is of...

<a id="ref-39"></a>39. [How Raytraced Audio Works (For Reverb) ｜ Lese][39] - Ray tracing in acoustics is a method of modeling how sound propagates through an environment by trea...

<a id="ref-40"></a>40. [Ray tracing for the ears: When sound stumbles through ...][40] - The implementation is where it gets interesting. · Sound beams are emitted spherically from the play...

<a id="ref-41"></a>41. [Microsoft reveals more Xbox Series X details including ' ...][41] - Microsoft reveals more Xbox Series X details including 'audio ray tracing' ... Audio Gateways into I...

<a id="ref-42"></a>42. [Ray traced audio acceleration is the latest gimmick on ...][42] - The 3D spatial sound feature on the Xbox Series X console will probably be similar to ray tracing as...

<a id="ref-43"></a>43. [Xbox Series X Will Feature Audio Ray Tracing, Director of ...][43] - According to the director of Xbox program management, the Xbox Series X will sport a new spatial aud...

<a id="ref-44"></a>44. [UBIのゲーム版「アバター」では“レイトレーシング音響技術”を採用][44] - ユービーアイソフトのアクションアドベンチャー「アバター：フロンティア・オブ・パンドラ」では、「レイトレーシングオーディオシステム」が採用され ...

[1]: https://www.corsair.com/explorer/gamer/gaming-pcs/what-is-ray-tracing-in-games/
[2]: https://www.nvidia.com/en-us/geforce/news/metro-exodus-rtx-ray-traced-global-illumination-ambient-occlusion/
[3]: https://www.digitalfoundry.net/articles/digitalfoundry-2020-playstation-5-ray-tracing-software-analysis
[4]: http://joostdevblog.blogspot.com/2020/10/screen-space-reflections-in-blightbound.html
[5]: https://documentation.vizrt.com/viz-artist-guide/5.1/Screen_Space_Reflection.html
[6]: https://josselinsomervilleroberts.github.io/papers/Report_INF584.pdf
[7]: https://www.reddit.com/r/gamedev/comments/niwbjd/screen_space_reflection_artifacts_problem/
[8]: https://docs.unity3d.com/2020.3/Documentation/Manual/RefProbePerformance.html
[9]: https://discussions.unity.com/t/why-do-reflection-probes-invert-curved-reflective-surfaces-how-to-solve/808409
[10]: https://interplayoflight.wordpress.com/2019/09/07/hybrid-screen-space-reflections/
[11]: https://www.youtube.com/watch?v=1bVxyewA024
[12]: https://www.youtube.com/watch?v=Ms7d-3Dprio
[13]: https://www.nvidia.com/en-us/geforce/news/control-game-rtx-ray-tracing-technologies/
[14]: https://hothardware.com/reviews/remedys-control-rtx-graphics-and-performance-analysis?page=2
[15]: https://www.hp.com/us-en/shop/tech-takes/omen-ray-tracing-optimization-settings-guide
[16]: https://screenrant.com/spiderman-miles-morales-ps5-puddle-reflection-ray-tracing/
[17]: https://www.digitalfoundry.net/articles/digitalfoundry-2020-console-ray-tracing-in-marvels-spider-man
[18]: https://www.youtube.com/watch?v=crjbA-_SoFg
[19]: https://www.digitalfoundry.net/articles/digitalfoundry-2021-ratchet-and-clank-rift-apart-tech-review
[20]: https://www.digitalfoundry.net/articles/digitalfoundry-2021-ratchet-and-clank-rift-apart-performance-analysis
[21]: https://www.thedrive.com/news/gran-turismo-7-will-get-a-ps5-pro-update-with-raytracing-at-60-fps
[22]: https://traxion.gg/gran-turismo-7-on-ps5-pro-will-include-ray-tracing-during-races-at-60fps/
[23]: https://blog.playstation.com/2025/04/11/assassins-creed-shadows-ubisoft-deep-dives-into-ps5-pro-updates/
[24]: https://hardwaretimes.com/cyberpunk-2077-overdrive-mode-analysis-path-tracing-vs-ray-tracing-comparisons/
[25]: https://www.youtube.com/watch?v=I-ORt8313Og
[26]: https://wccftech.com/cyberpunk-2077-nvidia-ray-tracing-overdrive-mode-pc-performance-benchmarks-path-tracing-on-a-geforce-rtx-4090/
[27]: https://www.nvidia.com/en-us/geforce/news/gfecnt/202310/alan-wake-2-dlss-3-5-full-ray-tracing-out-this-week/
[28]: https://www.kitguru.net/gaming/matthew-wilson/alan-wake-2-will-have-path-tracing-dlss-3-can-provide-up-to-4-7x-performance-boost/
[29]: https://www.digitalfoundry.net/articles/digitalfoundry-2024-indiana-jones-and-the-great-circles-full-ray-tracing-upgrade-is-spectacular
[30]: https://erikmcclure.com/blog/7-problems-raytracing-doesnt-solve/
[31]: https://www.digitalfoundry.net/articles/digitalfoundry-2025-assassins-creed-shadows-tech-qa-rtgi-shader-compilation-taa-and-more
[32]: https://www.xda-developers.com/why-ray-tracing-isnt-worth-performance-hit/
[33]: https://www.reddit.com/r/digitalfoundry/comments/1q241gb/id_rather_have_convincing_cubemap_reflections/
[34]: https://www.youtube.com/watch?v=ayJyaaFRbT8
[35]: https://wccftech.com/forza-motorsport-ray-traced-global-illumination/
[36]: https://www.digitalfoundry.net/articles/digitalfoundry-2024-can-xbox-series-s-handle-senuas-saga-hellblade-2
[37]: https://www.digitalfoundry.net/articles/digitalfoundry-2024-senuas-saga-hellblade-2-is-a-defining-moment-in-the-evolution-of-real-time-graphics
[38]: https://www.massive.se/blog/news/ray-tracing-audio-in-snowdrop-creating-a-living-pandora/
[39]: https://lese.io/blog/how-raytraced-audio-works-for-reverb/
[40]: https://www.igorslab.de/en/raytracing-for-the-ears-when-the-sound-stumbles-through-the-voxel-forest/
[41]: https://www.videogameschronicle.com/news/microsoft-reveals-more-xbox-series-x-details-including-audio-ray-tracing/
[42]: https://www.notebookcheck.net/Ray-traced-audio-acceleration-is-the-latest-gimmick-on-Microsoft-s-Xbox-Series-X-console.454763.0.html
[43]: https://wccftech.com/xbox-series-x-audio-ray-tracing/
[44]: https://game.watch.impress.co.jp/docs/interview/1544309.html

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
