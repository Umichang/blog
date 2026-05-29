# App Store / Google Play ゲーム表現の検閲と審査対策 完全ガイド

## はじめに：なぜ「表現の検閲」はゲーム開発者の必修知識なのか

スマートフォンゲームの流通は、事実上 Apple の App Store と Google の Google Play という2つのプラットフォームに支配されている。この2社は**単なる販売窓口ではなく、ゲームの内容そのものを審査・規制する権限を持つ「ゲートキーパー」**として機能している。[^1][^2]

問題の本質は、審査が「リリース時の一度きり」ではないことだ。アップデートのたびに審査が行われるうえ、すでにリリース済みのゲームでも**ポリシー改定によって突如として規制対象になる**ことがある。2025年以降は規制強化の動きが加速しており、新規参入者だけでなく、長年運営してきた開発者も無縁ではいられない。[^3][^4]

***

## 第1章：二大ストアの審査の仕組みと基本的な違い

### App Store（Apple）の審査フロー

App Store では、**新規アプリと同様にアップデートも毎回人間のレビュアーによる審査を受ける**。審査の対象はバイナリ（アプリ本体）だけでなく、スクリーンショット・プレビュー動画・説明文などのメタデータも含まれる。[^5][^6]

審査プロセスは概ね以下の流れで進む：

1. **App Store Connect にビルドをアップロード**（Xcode または Transporter 経由）
2. **自動チェック**：コード署名・クラッシュ・プライバシーマニフェストなどを機械的にスキャン
3. **人間によるレビュー**：コンテンツ・UX・ガイドライン準拠を確認
4. **承認または却下**：却下の場合は理由が Resolution Center に通知される

2026年時点で審査の平均所要時間は**24〜48時間**とされるが、フラグが立った場合は最大7日かかることもある。アップデートが却下された場合、修正して同バージョンのままで再提出できる（バージョン番号を変える必要はない）。[^7][^8]

### Google Play の審査フロー

Google Play は長らく「自動審査中心」と言われてきたが、近年は審査体制を大幅に強化した。2024〜2025年にかけて**人間のレビュアーを大幅に増員**し、AI量産アプリ・ポリシー違反アプリへの対応を強化。その結果、2024年初頭から2025年4月にかけてGoogle Play のアプリ総数は**約47%減少**した。[^9]

Google Play では、アップデート提出後にポリシー違反が検出された場合：

- **警告メール＋Play Console 通知**が届く
- 一定期間内に修正しなければアプリが非公開または削除される
- 違反の深刻度によっては**すべてのバージョンが即時停止**される場合もある[^10]
- 一度停止されると**1回しか異議申し立てができない**[^10]

### 審査体制の比較

| 項目 | App Store（Apple） | Google Play（Google） |
|------|-------------------|----------------------|
| 審査主体 | 人間レビュアーが毎回確認 | 自動＋人間のハイブリッド |
| 平均審査時間 | 24〜48時間（最大7日） | 数時間〜数日（強化後） |
| アップデート審査 | 毎回フル審査 | 毎回。既存アプリも抜き打ちで再審査あり |
| 却下通知 | Resolution Center に詳細記載 | メール＋Play Console に記載 |
| 異議申し立て | 何度でも可（App Review Board への申立ても可） | 1回のみ |
| 基準の一貫性 | 「レビュアーによってブレがある」と開発者から批判多数 | 方針は明文化されているが解釈が変わることがある |

[^11][^2][^10]

***

## 第2章：表現規制の主要カテゴリと判断基準

### 暴力・グロテスク表現

App Store のガイドライン 1.1.2 は「人間や動物が殺傷・拷問・虐待されるリアルな描写」を禁止している。注意すべきは、**ゲーム内のコンテンツとストア掲載素材（アイコン・スクリーンショット・プレビュー動画）で基準が異なる**点だ。[^12]

- ゲーム本体は年齢レーティングが高ければ暴力表現を含められる
- **アイコン・スクリーンショット・プレビュー動画は4+相当のビジュアルが必要**（すべての年齢のユーザーがストアで目にするため）[^13]
- 銃が現実的に描写されている場合、「腰や背中に収納された状態」でなければ素材に使用できない[^13]

### 性的・扇情的表現

両ストアともに露骨な性的表現は禁止だが、基準の解釈に差がある。Google Play は近年**ガチャゲームの衣装・スキンに対して積極的に規制を適用**するようになっており、「既存の衣装が突然規制対象になる」ケースが多発している。[^14][^15]

### 政治的・宗教的表現

App Store は「特定の政治的・宗教的メッセージを前面に押し出したコンテンツ」に対してカテゴリ変更を要求することがある。「Liyla and the Shadows of War」事件（後述）が典型例だ。[^16]

### ユーザー生成コンテンツ（UGC）

UGCを許可するゲームでは、**開発者がコンテンツのモデレーション責任を負う**。以下の機能がない場合、審査を通過できない：[^17]

- 不適切コンテンツの報告・通報機能
- ユーザーのブロック機能
- コンテンツの削除・フィルタリング機能

***

## 第3章：アップデート時の検閲リスクと「後から削除される」問題

### なぜアップデート時に規制が発動するのか

リリース時に審査を通過したゲームでも、アップデート提出時に**より厳格な解釈を適用されて**従来のコンテンツが問題視されることがある。これには主に3つのパターンがある：

**パターン1：ポリシーの改定・明文化**
Appleは毎年複数回ガイドラインを更新し、Googleも定期的にポリシーを改定する。新しいポリシーが遡及的に適用されることがある。[^18][^4]

**パターン2：審査担当者の交代・解釈の変化**
App Store は「レビュアーによって基準がブレる」と開発者から広く批判されている。同じコンテンツが一度は通過し、別のレビュアーに当たると却下されるケースが報告されている。[^19][^2]

**パターン3：外部からのクレーム・抜き打ちレビュー**
Google Play はユーザーや第三者からの通報を受けて既存アプリを再調査することがある。結果として**数年間問題なく運営されていたアプリが突然削除されるケース**がある。[^20][^21]

### アップデート審査で特に注意すべきポイント

アップデート時に表現関連で引っかかりやすいのは以下の変更を伴う場合だ：

- **新規コスチューム・スキンの追加**（特に露出度の高いもの）
- **プロモーション動画・スクリーンショットの刷新**
- **ゲームエンジン・SDKのアップデート**（新たな権限要求が発生する場合）
- **メタデータ（説明文・キーワード）の更新**

***

## 第4章：実際にあった事例

### 事例1：「Liyla and the Shadows of War」— 政治表現をめぐる拒絶（2016年）

パレスチナ人開発者 Rasheed Abueideh が制作した横スクロールゲーム「Liyla and the Shadows of War」は、ガザ地区の紛争をテーマにした作品だ。Apple はこのゲームの App Store への掲載を**「ゲームカテゴリには適さない」として拒否**。「News」か「Reference」への再カテゴリーを要求した。[^22][^16]

開発者は「政治的なテーマがゲームとしての審査を通過できない理由になっている」と批判。SNS上で大きく拡散され、国際的な注目を集めた。最終的に Apple はゲームカテゴリでの掲載を認めたものの、Google Play では当初から問題なくゲーム（パズル・プラットフォーマー）として配信されていた。[^23][^16]

**教訓**：政治的・社会的メッセージを含む作品は、ゲームとして審査されない可能性がある。カテゴリ選択と内容説明の工夫が重要。

### 事例2：「Azur Lane」— Google Policy による既存スキン強制削除（2025年1月）

モバイルゲーム「アズールレーン（Azur Lane）」のグローバル版を運営するYostarは、2025年1月3日に突然のアナウンスを行った。**Google Play Store のポリシー違反を理由に、5種類のスキンを1月4日をもって販売停止**にするというものだ。[^24][^25]

削除されたスキンはShinano「Visions of Fantasy」、Napoli「Dreamy Night」、Hindenburg「Delirious Duel」、Chitose「Summer Shine」、Atago「Summer March」の5つ。すでに購入済みのユーザーは引き続き使用できるが、新規購入は不可になった。[^26][^25]

この件で特に注目されたのは、**AppleはApp Storeに対して同様の要求を行っていないにもかかわらず、iOS版でも同じスキンが販売停止になった**点だ。Yostarは「Google Playポリシー準拠のため」と説明し、プラットフォームをまたいで統一対応を選んだとみられる。[^15][^26]

**教訓**：Googleの規制はAndroid版だけの問題ではなく、開発・運営体制の都合でiOS版にも波及する。既存コンテンツでも「ポリシー改定後の再審査」リスクがある。

### 事例3：スナイパーゲームのアイコン問題（2016年〜継続）

複数のインディー開発者が報告する共通トラブルとして、**アイコンやスクリーンショットに武器が描かれていることによる却下**がある。特にスナイパーゲームなど、銃を前面に出した作品では、「銃口がプレイヤー（画面手前）に向いている素材」が繰り返し問題になっている。[^27]

ある開発者はスクリーンショット内の銃をピクセル化処理して対応したが、翌年のアップデート審査で同様の指摘を再び受けた。ルールは存在するが**「いつ、どの担当者が厳密に適用するか」が不確定**というのが現場の実感だ。[^27]

### 事例4：「Splash Damage」のスクリーンショット修正強制（2015年）

ゲームスタジオ Splash Damage は、自社ゲームのApp Storeプレビュー動画に含まれる銃の描写をピクセル化するよう要求された。同様に、「Into the Dead」の開発元PikPokも「武器が発射されているシーンを含むApp Previewが却下された」と報告。このケースは、**ゲーム内容ではなく宣伝素材のみが原因で審査が通らない**ことを示す典型例だ。[^27]

***

## 第5章：2024〜2025年の規制改定——最新動向

この2年間は、両プラットフォームともに表現規制に直結するルール改定が相次いだ。

### Apple App Store の主要改定

**年齢レーティングの大幅刷新（2025年7月）**[^4]
従来の「4+ / 9+ / 12+ / 17+」という4段階から、**「4+ / 9+ / 13+ / 16+ / 18+」の5段階**に変更された。新たな年齢レーティング質問票には「暴力的テーマ」「ウェルネス・医療関連」「アプリ内コントロール」など、より細かい項目が追加。全開発者は**2026年1月31日までに更新された質問票への回答が義務付け**られており、未回答の場合はアップデート提出時に審査が止まる。[^28][^4]

**AIコンテンツの透明性要件（2025年11月）**[^29]
2025年11月13日以降、ユーザーのデータをOpenAI・Anthropicなどの外部AIサービスに送信する場合、**明示的な同意画面を表示することが義務化**。ゲームでもAI生成テキストや会話機能を実装している場合は対象となる。[^29]

**クリエイターアプリ向けUGCルール強化（2025年11月）**[^30]
ガイドライン1.2.1(a)として、クリエイターアプリは**アプリの年齢レーティングを超えるコンテンツを識別・制限する仕組み**の実装が必要になった。[^29]

**Xcode 26 SDK への強制移行（2026年4月28日）**[^3]
2026年4月28日以降、App Store Connect にアップロードするアプリは Xcode 26 以降で iOS 26 SDK を使ってビルドしている必要がある。古いSDKを使い続けていると**そもそも審査に出せなくなる**ため注意が必要（既存のリリース済みアプリはそのまま配信され続け、新規申請とアップデートのみが対象）。

### Google Play の主要改定

**未成年アクセス制限の義務化（2025年10月）**[^18]
2025年10月30日に新設された「Age-Restricted Content and Functionality（年齢制限コンテンツ・機能）」ポリシーにより、マッチング・出会い系サービスや、**現実のお金を賭けるギャンブル・ゲーム・コンテスト（Real Money Gambling, Games, and Contests）**は、Play Console の「Restrict Minor Access（未成年アクセス制限）」機能を使って未成年のアクセスをブロックすることが必須になった。原則として告知から30日の猶予が設けられ、2026年1月28日に本格的な執行が始まった。なお、ここでいう「現実マネーを使うゲーム」とは賞金や現金が絡む賭博型ゲームを指し、ガチャなどアプリ内課金を伴う一般的なゲームが一律で対象になるわけではない点に注意したい。[^18]

**アプリ品質ポリシーの導入（2024〜2025年）**[^9]
「頻繁にクラッシュする」「基本的なモバイルアプリとしての体験を提供しない」「魅力的なコンテンツが乏しい」などのアプリを禁止する新たな**機能・コンテンツ・UXポリシー**が導入された。これにより2024年初頭から2025年4月の間にアプリ総数が約47%減少した。[^9]

**性的コンテンツポリシーの地域別運用（時期不明・継続中）**[^31]
Google Play は性的コンテンツを含むアプリについて、「そのコンテンツが合法とされる地域のユーザーにのみ提供可能にする」という地域別アクセス制限を適用するポリシーを更新した。全世界一律での配信ができなくなる可能性がある。[^31]

***

## 第6章：備えるべき対策——開発・運営フェーズ別

### 開発フェーズ

**① ガイドライン原文を定期的に読む**
両ストアともにガイドラインを不定期更新する。Apple の開発者ニュースページと Google Play の Policy Announcement を定期的にチェックする習慣を持つこと。[^32][^33]

**② ストア素材とゲーム内コンテンツを分けて考える**
アイコン・スクリーンショット・プレビュー動画は**ゲーム本体とは独立した審査基準**が適用される。どれほどレーティングが高いゲームでも、素材は全年齢が目にすることを前提にした仕上げが必要。[^13][^27]

**③ コンテンツレーティング質問票に正直に回答する**
誤った回答（過少申告）によって後からレーティングを強制変更される、あるいはアプリ削除に至る事例がある。質問票は「自分のゲームをどう見せたいか」ではなく「実際にどんなコンテンツがあるか」で回答する。[^34]

### リリース・アップデートフェーズ

**④ アップデートは「前回との差分」だけでなく全体を確認する**
アップデート審査では前回通過したコンテンツも再審査の対象になりうる。特に**過去に際どい判断で通った素材**は、ポリシー改定後のアップデート時に改めて問題になるリスクがある。

**⑤ リリース日の2〜3週間前に申請する**
Apple のApp Review にかかる時間は平均24〜48時間だが、却下→修正→再申請のサイクルを考えると**最低でも2週間のバッファ**を設けるべきだ。特に大型アップデートや新機能追加時は1ヶ月前の申請が推奨される。[^35][^3]

**⑥ App Review Notes を丁寧に記載する**
複雑な機能・成人向けコンテンツ・特定ハードウェア依存の機能がある場合は、**レビュアーへの説明メモ（App Review Notes）に詳細を書く**ことで誤解に基づく却下を防げる。[^6][^17]

**⑦ テストアカウントや再現手順を必ず提供する**
ログイン必須のゲームでレビュアーが機能を確認できない場合、「機能不全」として却下されるケースがある。デモ用アカウントと操作手順をReview Notesに記載する。[^17]

### 却下された場合の対応

**⑧ 却下メッセージを「指摘部分だけ」修正する**
「不安で他の箇所も直したくなる」という心理が働くが、**無関係な変更を同時に加えると新たな問題が発生し、審査が長引く**。却下理由に明記されたポイントのみ外科的に修正する。[^3]

**⑨ Resolution Center で具体的に説明する**
修正内容と「なぜこれでポリシーに準拠しているか」を解説したメッセージを Resolution Center に送る。スクリーンショット付きの説明が効果的。[^3]

**⑩ App Review Board への異議申し立てを活用する**
Apple にはガイドライン解釈に不服がある場合に利用できる正式な異議申し立てプロセス（App Review Board）がある。Google Play にも1回限りのアピール制度がある。[^36][^10]

***

## 第7章：App Store / Google Play 以外の選択肢——代替ストアの台頭

### 欧州連合（EU）のDMA（デジタル市場法）と代替ストア

EUは2024年3月に施行した**デジタル市場法（DMA）**により、AppleとGoogleを「ゲートキーパー」として指定。iOS デバイスへの**第三者アプリストアのインストールと「サイドローディング」を義務付け**た。[^37]

これにより、2024年3月の iOS 17.4 以降、EU圏内のiPhoneユーザーは代替ストアを利用できるようになった。**Epic Games Store Mobile** は2024年8月にiOS（EU）・Android（全世界）向けに開設され、フォートナイト（Fortnite）など自社タイトルに加え、2025年1月からはサードパーティ製ゲームの配信も開始した（当初は十数本規模で、順次拡大中）。[^38][^39][^37]

### 日本：スマホ新法（2025年12月施行）

日本でも2025年12月18日、**「スマートフォンソフトウェア競争促進法（スマホ新法）」**が全面施行された（正式名称は「スマートフォンにおいて利用される特定ソフトウェアに係る競争の促進に関する法律」。公正取引委員会は「スマホ法」と呼称している）。主な内容は以下の通り：[^40][^41]

- 第三者アプリストアの利用を許可する義務
- アプリ内課金にApp Store・Google Play以外の決済手段を認める
- アンチステアリング規制（外部の購入先への誘導を妨げる行為）の禁止
- NFC等のOS機能への平等なアクセス保証

これを受けて**AltStore PAL** が2025年12月18日（法施行と同日）に日本向けサービスを開始。さらに**Epic Games Store の iPhone 版も2026年5月1日に日本でサービス開始**し、フォートナイト（Fortnite）と Rocket League Sideswipe がプレイ可能になった。インディーゲーム開発者向けのセルフパブリッシングツールは**2026年8月に開放予定**とされている。[^42][^43][^38]

### 代替ストアの現状と課題

| ストア | iOS対応 | Android対応 | 対応地域 | 主なゲーム |
|--------|---------|------------|---------|-----------|
| Epic Games Store Mobile | ◎（EU・日本） | ◎（全世界） | EU・日本・ブラジル（予定） | フォートナイト、Rocket League Sideswipe 他 |
| AltStore PAL | ◎（EU・日本） | ✕ | EU・日本・オーストラリア・ブラジル | 主にインディー・ツール系 |
| Samsung Galaxy Store | ✕ | ◎ | 全世界 | 一般向けアプリ・ゲーム |

[^44][^42][^38]

ただし、代替ストアには以下のような現実的な課題もある：[^45]

- **インストール障壁**：App Store に比べて手順が複雑で、一般ユーザーへの普及に時間がかかる
- **Core Technology の手数料**：従来、EUで代替ストア配信を行う開発者には1インストールあたり€0.50の「Core Technology Fee（CTF）」が課されていた（年間100万インストールを超えた分が対象）。ただしAppleは2026年1月1日にCTFを廃止し、デジタル財・サービスの売上に対して5%を課す「Core Technology Commission（CTC）」へ移行した。日本でも代替ストア配信には同様に5%のCTCが適用されており、大規模タイトルや外部決済を扱う開発者には依然として経済的負担となる[^45]
- **Appleの非協力的な姿勢**：Epic Games は「Apple が法の趣旨に反した対応を続けている」と批判[^43]

***

## 第8章：ゲームプランナー向けチェックリスト

### リリース前

- [ ] 両ストアのガイドライン原文（最新版）を通読した
- [ ] アイコン・スクリーンショット・プレビュー動画が「4+相当」の視覚表現になっている
- [ ] 銃・武器・暴力的シーンを含む素材では、表示方向・構図を確認した
- [ ] コンテンツレーティング質問票に実態と一致した回答をした
- [ ] App Review Notes にデモアカウントと複雑な機能の説明を記載した
- [ ] UGC機能がある場合、通報・ブロック・モデレーション機能を実装した
- [ ] リリース予定日の2〜3週間前に申請した

### アップデート時

- [ ] 新規追加コンテンツ（衣装・スキン等）がストア素材基準を満たしているか確認した
- [ ] 今回の変更によって権限・データ収集の内容が変わった場合、プライバシー情報を更新した
- [ ] SDK・ゲームエンジンのバージョンアップにより新たな権限要求が発生していないか確認した
- [ ] 直近のポリシー改定内容と、今回のアップデート内容を照合した
- [ ] Apple の年齢レーティング新質問票に回答済みか確認した（2026年1月31日締切）[^4]

### 却下された場合

- [ ] 却下理由を原文で確認し、該当ガイドライン条項を読んだ
- [ ] 指摘された箇所**のみ**を修正した（無関係な変更はしない）
- [ ] Resolution Center に修正内容と根拠を書いた説明文を送った
- [ ] 不当な却下だと判断した場合は App Review Board / Google Play アピールを利用した

***

## まとめ：「一度通れば終わり」という考え方を捨てる

App Store と Google Play の審査は、ゲームのライフサイクル全体にわたって継続的に影響を与える。ポリシーは年に複数回改定され、ゲームが長寿命になるほど「後から規制対象になる」リスクが高まる。2025年以降の規制強化トレンドを踏まえると、**コンテンツガイドラインの変更監視と、素材・コンテンツの定期的な棚卸しは、運営業務の一部として組み込む**べきだ。

一方、EUのDMAと日本のスマホ新法により、代替ストアという新たな選択肢が現実のものとなった。ただし現時点では普及率・ユーザー数ともにApp Store・Google Playには遠く及ばず、「メインストアへの依存から脱却できる」段階ではない。まずは二大ストアの審査プロセスを深く理解し、備えることが最も重要な対策だ。[^41][^38]

---

## References

1. [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) - On the following pages you will find our latest guidelines arranged into five clear sections: Safety...

2. [App review is still broken, and developers are angry](https://mobilegamer.biz/app-review-is-still-broken-and-developers-are-angry-apple-sees-itself-as-above-the-law/) - “We were about to launch a new game, and Apple rejected it because 'another developer already owns t...

3. [Apple App Store Rejection Guide 2026](https://www.openspaceservices.com/blog/mobile-app-development/apple-app-store-rejection-guide-2026-the-15-most-common-reasons-and-how-to-fix-each) - Why App Store Rejection Rate Is 30% And Why It's Rising · 1. AI Consent Requirement (November 2025) ...

4. [Apple overhauls App Store age ratings with new categories](https://www.pocketgamer.biz/apple-overhauls-app-store-age-ratings-with-new-categories/) - The system introduces new 13+, 16+, and 18+ categories alongside the existing 4+ and 9+ ratings, wit...

5. [App Review - Distribute](https://developer.apple.com/distribute/app-review/) - We review all apps, app updates, app bundles, in-app purchases, and in-app events submitted to App S...

6. [App Store Review Guidelines 2026: Updated Checklist](https://adapty.io/blog/how-to-pass-app-store-review/) - In order for the app to get reviewed, you need to upload its build, that is, a ready-made applicatio...

7. [How to update your app on the App Store in 2026](https://www.youtube.com/watch?v=xBZRT5Z3ab8) - Archive, Upload, Attach and Submit your app updates to the App Store through App Store Connect (ASC)...

8. [How to Submit Your App to the App Store [ 2026 Best Guide ]](https://premiumappdeveloper.com/how-to-submit-your-app-to-the-app-store/) - Understanding the Apple App Store Review Process in 2026. The Apple App Store review process has two...

9. [Reports that the removal of low-quality apps from Google ...](https://gigazine.net/gsc_news/en/20250501-google-play-47-decline-apps/) - Google Play, the Android app store, saw a 47% drop in the number of apps between the beginning of 20...

10. [My app has been removed from Google Play](https://support.google.com/googleplay/android-developer/answer/2477981?hl=en-GB) - If your app has been removed or suspended from Google Play, its users may receive a push notificatio...

11. [Google Play App Rejection Rate in 2026: Data, Reasons & ...](https://primetestlab.com/blog/google-play-app-rejection-rate-2026) - The top rejection triggers are crashes, thin content, permission abuse, broken privacy links, and fa...

12. [App Reviewガイドライン](https://developer.apple.com/jp/app-store/review/guidelines/) - App Reviewガイドラインでは、ユーザーインターフェイスのデザイン、機能性、コンテンツ、そして特定のテクノロジーの使用など、開発に関する幅広い ...

13. [Apple's visual guide for app creative policies](https://www.facebook.com/groups/132728896890594/posts/3284174621745990/) - Apple has strict policies as to what creative is/is not allowed** The start of 2026 is seeing apps g...

14. [Azur Lane faces another bout of censorship as Google ...](https://www.facebook.com/jlistcom/posts/azur-lane-faces-another-bout-of-censorship-as-google-play-store-policies-seeming/1007977264699762/) - Azur Lane faces another bout of censorship as Google Play Store policies (seemingly) coax the game t...

15. [Azur Lane FORCED To Remove Multiple Outfits To Comply ...](https://www.youtube.com/watch?v=C51F-hxnfYU) - Azur Lane is being forced to remove multiple outfits (which have existed for years) to comply with G...

16. [Palestinian political platformer rejected by Apple App Store ...](https://www.polygon.com/2016/5/20/11723856/apple-palestinian-game-rejection-liyla-and-the-shadows-of-war/) - Abueideh contended that Liyla and the Shadows of War's strong political content is a factor in Apple...

17. [App Store Review Guidelines (2025): Checklist + Top ...](https://nextnative.dev/blog/app-store-review-guidelines) - Developer-friendly breakdown of Apple's App Store Review Guidelines (2025). Skimmable checklist, top...

18. [Google Play PolicyBytes - October 2025 policy updates](https://www.youtube.com/watch?v=5QuigdMfS3I) - Chapters: 0:00 - Introduction 0:33 - Age-Restricted Content and Functionality 1:11 - Updates and cla...

19. [Apple's inconsistent review policies for mobile apps](https://www.facebook.com/groups/vibecodinglife/posts/1935764223678772/) - Building apps via vibe coding is real. It absolutely works and you can absolutely build viable, soli...

20. [App removed by Google Play because older version is not ...](https://stackoverflow.com/questions/67717994/app-removed-by-google-play-because-older-version-is-not-compliant-to-new-backgro) - I have adjusted the permissions and use of location data and published it in a new release (v10004)....

21. [And on the 19th day, Google Play spoke and resurrected ...](https://www.reddit.com/r/androiddev/comments/16e7gf4/and_on_the_19th_day_google_play_spoke_and/) - Before republishing your apps, you may also want to review the Developer Program Policies for additi...

22. [Gaza Strip iOS game isn't a game, says Apple](https://www.wired.com/story/palestinian-game-liyla-apple-app-store-ban/) - Apple has rejected a game influenced by the Palestinian-Israeli conflict from the App Store, saying ...

23. [Palestinian game illustrates pains of Gaza war](https://www.aa.com.tr/en/life/palestinian-game-illustrates-pains-of-gaza-war-/580138) - Mobile game designed to raise awareness of Gaza war overcomes challenges by Apple over political con...

24. [Azur Lane to Remove Skins at Google's Order](https://crazyforanimetrivia.com/azur-lane-to-remove-skins-at-google-order/) - Azur Lane to Remove Skins at Google's Order. The Year Has Just Begun, and Censorship Strikes Again: ...

25. [Azur Lane Announces Outfit Removals And Event ...](https://noisypixel.net/azur-lane-outfit-removal-event-changes-google-policy/) - Yostar has announced that several outfits in Azur Lane will be removed from the in-game outfit shop ...

26. [Azur Lane - Google Bans 5 Skins from Game](https://www.youtube.com/watch?v=eXfHC_LmDpU) - [Azur Lane] Censorship comes to the Global Server in 2025 - Google Bans 5 Skins from Game · Comments...

27. [Apple App Store Rule on Guns and Violence](https://www.businessinsider.com/apple-app-store-rule-on-guns-and-violence-2015-2) - The company is asking developers to blur out guns and nudity on screenshots, trailers, and icons so ...

28. [Updated age ratings in App Store Connect - Latest News](https://developer.apple.com/news/?id=ks775ehf) - The updated age rating system adds 13+, 16+, and 18+ to the existing 4+ and 9+ ratings. Age ratings ...

29. [App Store Review Checklist for 2025](https://appinstitute.com/app-store-review-checklist/) - According to Guideline 1.2.1(a), apps must clearly flag content that exceeds the app's age rating an...

30. [Updated App Review Guidelines now available](https://developer.apple.com/news/?id=ey6d8onl) - 1(a): This new guideline specifies that creator apps must provide a way for users to identify conten...

31. [Announcements - Play Console Help](https://support.google.com/googleplay/android-developer/announcements/13412212?hl=en) - We're updating our Sexual Content policy to explain that we may make an app available only to users ...

32. [Latest News - Apple Developer](https://developer.apple.com/news/) - The App Review Guidelines have been revised to support updated policies and to provide clarification...

33. [Google Play Policies | Android Developers](https://developer.android.com/distribute/play-policies) - Comply with October 2025 policy updates. We're updating Google Play policies related to Age-Restrict...

34. [How to handle a policy violation on Google Play](https://www.youtube.com/watch?v=xjRqFbTHUOQ) - ... examples of what might cause the violation, and explain next steps for getting your flagged app ...

35. [iOSアプリの審査でリジェクトされないための7つのステップ](https://repro.io/contents/7-steps-to-not-be-rejected-from-the-app-store/) - この記事はApp Storeの審査にアプリが通るための注意点について紹介します。何カ月も開発に費やしてきたアプリが審査を通らなかった時のショックは計り知れません。

36. [[iOS] Apple Storeのリジェクト、Guideline 4.3(a) - Design](https://qiita.com/razuma/items/a959cb6fb78149615649) - Some factors that contribute to a spam rejection may include: Submitting an app with the same source...

37. [A timeline of the DMA and iOS 17.4 sideloading saga](https://promon.io/security-news/the-digital-markets-act-and-ios-17-4-sideloading) - The Digital Markets Act (DMA) compels Apples to allow sideloading. We're unpacking iOS 17.4 and the ...

38. [iPhone向け「Epic Games Store」が日本でも利用可能に。開発 ...](https://indiegamesjp.dev/?p=11717) - モバイル版Epic Games Storeは、Android向けには全世界、iOSデバイスでは欧州連合（EU）域内ですでに提供されており、2026年6月にはブラジルでの提供開始も ...

39. [Epicが代替ストア開設、iOS版『フォトナ』復活もAppleへの批判 ...](https://xtrend.nikkei.com/atcl/contents/18/01182/00078/) - EUでは2025年5月にデジタル市場法（DMA）が施行され、App Store以外の第3のストアとしてEU内のEpic Games Storeが展開可能となり、iOSでも『フォートナイト ...

40. [スマホ法が本日施行！代替アプリストアである「AltStore PAL」 ...](https://tools4hack.santalab.me/amartphone-law-takes-effect-today-in-japan-and-howto-install-altstore-pal.html) - ちなみに、Epic GamesのCEOであるTim Sweeney氏からは「2025年中にiOS版Fortniteが日本に戻ってくるという約束は無理になった」とされ、理由としてApple ...

41. [Japan's Mobile Software Competition Act](https://appcharge.com/blog/japan-mobile-software-competition-act-legal-implications-for-game-publishers) - Beginning December 18, 2025, Apple and Google must allow external payments, third-party app stores, ...

42. [AltStore Available in Japan One Day After Apple Enables ...](https://www.macrumors.com/2025/12/18/altstore-japan-launch/) - Just a day after Apple announced alternative app marketplace support for iOS users in Japan, AltStor...

43. [Epic Games Store Launches on iPhones in Japan Despite ...](https://www.epicgames.com/site/news/epic-games-store-launches-on-iphones-in-japan-despite-apple-s-non-compliance) - Today, we announced that the Epic Games Store is available for download on iPhones in Japan with For...

44. [Epic Games Store on Android Proves That the iPhone ...](https://www.howtogeek.com/epic-games-store-on-android-proves-that-the-iphone-needs-third-party-stores/) - Epic has a mobile games store, after sueing both Apple and Google both for the right to make one. Yo...

45. [App Store Economy is Far From Open](https://www.epicgames.com/site/news/app-store-economy-is-far-from-open-despite-efforts-by-epic-developers-and-regulators-in-the-eu) - If a developer wants the ability to distribute their app outside the App Store, Apple imposes a €0.5...

