---
description: "ゲームのローカライズとは、あるゲームを別の国や地域のプレイヤーが自然に楽しめるよう、言語・文化・習慣・法規制などを総合的に適応させる作業全体を指す。単なる「テキスト翻訳」とは根本的に異なり、ゲームの世界観・ゲームルール・キャラクターの個性まで考慮に入れた総合的なアダプテーションだ。"
---

# ゲームローカライズの工程と実践
## 翻訳からカルチャライズ、AI時代の課題まで

***

## 1. ローカライズとは何か

ゲームのローカライズとは、あるゲームを別の国や地域のプレイヤーが自然に楽しめるよう、言語・文化・習慣・法規制などを総合的に適応させる作業全体を指す。単なる「テキスト翻訳」とは根本的に異なり、ゲームの世界観・ゲームルール・キャラクターの個性まで考慮に入れた総合的なアダプテーションだ。[[1](#ref-1)][[2](#ref-2)]

ローカライズ産業ではしばしば三つの概念が混同されるが、それぞれに明確な役割がある。

| 概念 | 英語表記 | 主な作業内容 | 目的 |
|------|---------|------------|------|
| **翻訳** | Translation | 原文の意味を別言語に変換する | 意味の伝達 |
| **ローカライズ** | Localization (l10n) | 世界観・ルール・表記を対象言語に合わせて調整する | 理解可能にする |
| **カルチャライズ** | Culturalization | 文化・価値観・規制・演出を対象地域向けに変更する | 意味を持たせる |

ローカライズ＝翻訳＋カルチャライズという構図で理解するとわかりやすい。ローカライズが「言語的に理解できること」を目標とするのに対し、カルチャライズは「文化的に共鳴できること」を目標とする。[[3](#ref-3)][[4](#ref-4)]

***

## 2. インターナショナライゼーション（i18n）——ローカライズの土台

ローカライズを始める前に、ゲーム開発の段階で「インターナショナライゼーション（i18n）」という技術的な地盤固めが必要になる。これはゲームエンジンや各システムを、複数言語に対応できる状態に設計する工程だ。[[5](#ref-5)]

代表的な対応項目は以下のとおり：[[6](#ref-6)][[7](#ref-7)]

- **Unicode対応** ：UTF-8/UTF-16を採用し、アラビア語・中国語・韓国語など非ラテン文字の表示を可能にする
- **テキスト伸縮への対応** ：同じ意味の文章でも言語によって文字数が大きく変わる。英語→フランス語では20〜30%程度、英語→ドイツ語では最大35%前後拡大するケースがある
- **フォントの差し替え機能** ：各言語専用フォントをゲームビルドに組み込めるようにしておく
- **日付・数値・通貨のロケール対応** ：「2024/04/26」と「26 April 2024」など地域によって表記が異なる
- **ハードコード文字列の排除** ：テキストをコード内に直接書き込まず、外部ファイルで管理する

i18nが不十分だと、ローカライズ作業中に文字化けやUIレイアウト崩れといった技術的バグが多発し、コストと時間が膨らむ。AAAタイトルが複数言語同時発売を実現できるのは、この土台が早期から設計されているからだ。[[8](#ref-8)][[5](#ref-5)]

***

## 3. ローカライズの全工程

ゲームのローカライズは、翻訳と言語品質保証（LQA）のふたつの大工程に大別される。コスト比率は概ね5:5から6:4程度とされる。[[9](#ref-9)]

### 3-1. ファミリアライズ（Familiarization）

翻訳作業に入る前に、翻訳者がゲームの世界観・ストーリー・キャラクターの性格・相関図などを深く理解する準備工程。この理解が不足していると、後工程での訳語の揺れや雰囲気の不一致が多発する。用語集（グロッサリー）やスタイルガイドもこの段階で整備される。[[10](#ref-10)]

### 3-2. 翻訳（Translation）

実際にテキストを対象言語に変換する工程。ゲーム翻訳の最大の難点は、 **文脈が断片化されている** ことだ。テキストはキャラクターごと・アイテムごとにバラバラのリストとして渡されることが多く、前後の会話が見えない状態で意味を判断しなければならない。また、「Yes/No」の返答は直前の質問形式によって意味が逆転するなど、ゲーム画面を見ないと正確な判断ができないケースも多い。[[11](#ref-11)]

翻訳の質を左右するのは以下の3要素だ：[[12](#ref-12)]

- **世界観への理解** ：アイテム名・技名など固有要素を世界観に合わせて訳す
- **キャラクターの個性** ：一人称（「私」「俺」「僕」「あたし」）や話し方の違いでキャラクターを表現する
- **テキスト制限との格闘** ：UIのボタンラベルや吹き出しには文字数制限があり、意味を保ちながら圧縮する技術が求められる

### 3-3. 音声吹き替え（VO / Dubbing）

音声付きのゲームでは翻訳後に声優の収録作業が発生する。フルボイスかつ口の動きに合わせたリップシンクが求められる作品では、翻訳テキストをそのまま読ませるのではなく、口の動きの長さや形に合わせてスクリプトを再調整する工程が加わる。特に「p・b・m」などの唇を閉じる子音は視覚的に目立つため、画面上のキャラクターの動作と合わせることが重要だ。[[13](#ref-13)][[10](#ref-10)]

### 3-4. LQA（言語品質保証）

翻訳が完了した後、ゲームを実際にプレイしながら言語品質を検証する工程。テキストが正しく表示されているか、文字がUIから溢れていないか、誤訳・表記揺れ・文脈のミスマッチがないかを確認する。テキストリストだけ見て翻訳すると起きがちなミス——たとえば「画面上のNPCが女性なのに男性一人称で話す」など——はこの段階で発見される。[[14](#ref-14)][[15](#ref-15)][[9](#ref-9)]

***

## 4. カルチャライズの実践

カルチャライズとは、ゲームのコンテンツを販売地域の文化規範・価値観・法規制に合わせて変更する作業だ。翻訳で言語を「読める」状態にするだけでは足りず、プレイヤーが「共鳴できる」状態に持っていくことを目標とする。[[16](#ref-16)][[4](#ref-4)]

### カルチャライズの主な領域

- **表現・シンボルの変更** ：宗教的・政治的・文化的に問題のある図像や表現の差し替え
- **キャラクター・グラフィックの調整** ：受け手の美的感覚や受容性に合わせたビジュアル変更
- **ユーモアの再構築** ：言葉遊びや文化的なジョークは直訳しても笑えないため、対象文化で等価の笑いが成立する表現に置き換える
- **レーティング対応** ：CEROやESRBなど地域ごとの年齢区分審査機関の基準に合わせたコンテンツ調整
- **法規制対応** ：特定地域で禁止されている表現（旗・マーク・暴力描写など）の修正

また、カルチャライズはさらに以下の2つのアプローチに分類できる：[[4](#ref-4)]

| アプローチ | 目標 | 内容 |
|-----------|------|------|
| **リアクティブ（反応的）** | コンテンツを「使える」状態にする | 問題のある表現を取り除く |
| **プロアクティブ（能動的）** | コンテンツを「意味のある」状態にする | 地域特有の要素を積極的に追加・最適化する |

***

## 5. 優れたカルチャライズの実例

### ラチェット＆クランク——キャラクターのアート変更

ソニーの人気3Dアクションシリーズを国内市場向けに展開したのが、プロデューサーの鶴見六百氏率いるチームだ。彼らが行ったのは言葉の翻訳だけではなかった。[[17](#ref-17)]

主人公ラチェットは、北米版では茶色でやや細い眉毛を持つが、日本版では **黒く太い眉毛** に変更されている。これは「日本人プレイヤーにも馴染みを持ってもらえるように」という意図による。さらに北米版と比べてラチェットの頭部が大きく、目がよりアニメ的な描き方になっており、日本市場が好む「可愛らしいキャラクター」の美的感覚に寄せている。このキャラクターデザインの改変は、2002年の第1作からPS3時代まで長年続いた（2021年の『パラレル・トラブル』ではモデルそのものが骨格から見直されたため、眉毛の調整は不要となった）。[[18](#ref-18)][[19](#ref-19)][[20](#ref-20)]

また第4作（米題：Ratchet: Deadlocked）では、本国ではナンバリングのない外伝的な位置づけだった作品を日本では『ラチェット&クランク4th ギリギリ銀河のギガバトル』としてナンバリングタイトルとして扱い、邦題やプロモーションにも独自の遊びが加えられた。このシリーズは日本でマンガ化されるほど浸透したが、それはローカライズチームがユーモア・慣用句・タイミングを保ちながら適切に文化翻訳した結果だとされる。[[21](#ref-21)][[17](#ref-17)]

### 龍が如く7——英語の逆説を笑いに変える

原作の日本語版では、主人公・春日が「外国人から英語で道を尋ねられて困る」という場面がある。英語版へのローカライズ時、この台詞をそのまま英語に翻訳すると「普段英語を話しているのに英語が理解できない」というシュールすぎる矛盾が生じる。[[22](#ref-22)]

Sega of Americaのローカライズ担当が選んだ解決策は、 **台詞を変えるのではなく演出を変えること** だった。英語版では外国人男性が不自然なほどゆっくりと言葉を発するよう変更し、その演出自体を自覚的なギャグとして成立させた。[[22](#ref-22)]

また、日本版の「 **デリバリーヘルプ** 」（風俗の「デリヘル」＝デリバリーヘルスをもじった、バトル中の助っ人召喚システム名）は、英語版では「 **Poundmates（ポンドメイツ）** 」に意訳された。"pound"が「ぶん殴る」と「性的な行為」の両方を意味し、"mates"が「仲間」を意味するダブルミーニングになっている。単純な意訳を超え、英語話者にとって笑いが生まれる造語として機能している。これはローカライズチームと開発チームの密な連携があってこそ実現できた対応だ。[[23](#ref-23)][[22](#ref-22)]

***

## 6. ローカライズの最高峰——UNDERTALEの日本語版

2015年にToby Fox氏がリリースしたインディーゲーム『UNDERTALE』の日本語版（2017年8月16日リリース）は、ゲームローカライズにおける最高水準の例として翻訳業界で広く語られる。[[24](#ref-24)][[11](#ref-11)]

その品質を支えたのが、Toby Fox氏みずからが準備した **10行に1回の割合で注釈が入る詳細な翻訳資料** だ。フリーランス翻訳者・福市恵子氏（ローカライズマネジメントは有限会社ハチノヨン／8-4が担当）には、キャラクターの性格・固有名詞の訳し方・重要台詞の意図が資料としてまとめられていた。さらに制作期間中、Fox氏とはSNSなどを通じて常時連絡が取れる体制が組まれており、翻訳者からの質問にはその日のうちに回答が返ってくる進行だった。[[25](#ref-25)][[26](#ref-26)]

このプロセスが生み出したローカライズの特徴は、以下の点に顕著だ：[[11](#ref-11)][[24](#ref-24)]

**1. キャラクターの一人称**
非公式日本語パッチでは「俺」が使われていたサンズの一人称が、公式版では「 **オイラ** 」に。この選択はファン間で大きな話題となった。日本語が持つ一人称の多様性（「私」「僕」「俺」「わし」「うち」など）を活かして、キャラクターの個性を翻訳で体現した例だ。[[27](#ref-27)][[28](#ref-28)]

**2. 漢字を使わない表記**
有志翻訳版では漢字交じりだった台詞が、公式版ではすべて **ひらがな・カタカナ** で表記されている。これはファミコン・ゲームボーイ時代のゲームへのオマージュであり、作品の持つレトロなテイストとの一貫性を保つための選択だ。[[24](#ref-24)]

**3. 造語の意訳**
原文の「friendliness pellets」は直訳すれば「親しみやすさのペレット」となるが、公式版では「 **なかよしカプセル** 」とされた。植物のキャラクターが「弾として撃つ何か」という場面の文脈と「すぐにイメージが湧く言葉」を両立させるための判断だ。[[11](#ref-11)]

**4. 固有名詞の設計**
「Mount Ebott」は「エボット山」ではなく「 **イビト山** 」とされた。これはオリジナルの"Ebott"が逆から読むと"Ttobe＝Toby（作者名）"になる仕掛けを、日本語でも「トビイ→イビト」の逆読みで再現したものだ。[[29](#ref-29)]

Fox氏自身が2026年3月29日にBlueskyで発表した声明でも、「公式に何かをリリースするなら自分のビジョンに合致している必要があり、自分が日本語を理解しているからこそ翻訳者と細部までチェックできた」と説明し、これが日本語版が（英語以外で）唯一の公式翻訳である理由だと述べている。[[30](#ref-30)][[25](#ref-25)]

***

## 7. 失敗から学ぶ——悪例の分析

### コンテキスト無視の翻訳問題

ローカライズが失敗する最大の原因のひとつが「ゲーム画面を見ないまま翻訳する」ことだ。テキストリストだけを渡された翻訳会社が、前後の文脈を確認せずに訳を当てはめていくと、同じキャラクター名が一行の間に3種類の訳になるようなケースすら起きる。[[15](#ref-15)]

### Call of Duty: Modern Warfare 2の致命的誤訳

「Remember, no Russian（いいか、ロシア語は使うな）」というミッション中の台詞が、日本語版では「殺せ、奴らはロシア人だ」と全く逆の意味に翻訳された。原文には「ロシア語を使うな（仲間にロシア人だと正体がバレないようにする）」と「自分たちはロシア人ではないというフリをしろ」のダブルミーニングが込められていたが、日本語版はそのどちらも捉えられていない。この誤訳は批判記事が多数書かれるほど有名になり、メーカーは2020年のリマスター版で「いいか…ロシア語は使うな」に修正した。[[14](#ref-14)]

### Fallout 4の不整合

日本語版で、主人公の性別をプレイヤーが選べるにもかかわらず字幕が男性言葉に統一されているため、女性主人公でプレイすると音声と字幕でキャラクターの話し方が一致しないケースが発生し、翻訳と音声・設定の整合性が問題になった。[[14](#ref-14)]

***

## 8. AI翻訳とローカライズ——現在進行形の課題

AI（機械翻訳）の精度は急速に上がっており、ゲームローカライズの現場にも深く浸透している。ただし、AIをそのまま使うことによる問題も明らかになっている。[[31](#ref-31)]

### AI翻訳が苦手とする領域

AIは「文字列の変換」は得意になってきたが、以下の部分ではまだ限界がある：[[32](#ref-32)][[31](#ref-31)]

- **固有名詞・専門用語の一貫性** ：ゲームの世界観に合わせた訳語の選択が難しく、同一用語が文脈によって訳語が揺れやすい
- **キャラクターの個性の反映** ：一律な口調になり、キャラクターごとの話し方の差が消える
- **造語・言葉遊び** ：新しい組み合わせの造語や、ダジャレ・文化的ギャグはAIが苦手とする領域
- **画面との整合性** ：テキストリストのみで処理されるため、実際のゲーム画面との文脈不一致が生じやすい

### AI翻訳丸投げの実態と反発

2026年3月、歴史RPG『キングダムカム・デリバランス2』のチェコ語→英語翻訳・編集およびボイスオーバーディレクションを約4年間担当してきたMax Hejtmánek氏が、3月27日に「会社の効率化と経費節減のため、来月からAIですべての翻訳を行うため、自分のポジションは不要になった」と通告されたとして、3月28日にRedditに投稿した。この事件はゲーム業界に衝撃を与えた。同作は「歴史的に正確で没入感の高い会話テキスト」が高く評価されたゲームだけに、その評価を支えた人材が解雇されたことへの反発は大きかった。[[33](#ref-33)][[34](#ref-34)]

また2025年8月18日には、Steamが言語ごとのレビュースコアを表示する機能をデフォルトで有効化した（一定数以上のレビュー投稿数が条件）。これにより、特定言語版のローカライズが低品質な場合、その言語ユーザーからのレビューだけを集計したスコアが表示されるようになった。「安くAI翻訳を使った結果、その言語のユーザーからの評価だけが著しく下がる」というリスクが可視化されることになり、ローカライズへの投資を怠るリスクは以前より高まっている。[[35](#ref-35)]

### AI翻訳の適切な使い方

AIは「使えない」のではなく「使い方が重要」だ。現状でも有効な活用方法はある：[[31](#ref-31)]

- 翻訳の **初稿生成** として使い、人間が後工程でポストエディットする
- アップデート頻度の高いタイトルの **定型テキスト** （UI文言・チュートリアルなど）に活用する
- 用語集・スタイルガイドを事前に組み込んだ **カスタムLLM** を使うことで一貫性を高める

「一見自然に見える翻訳ほど、誤りに気づきにくい」という点が最大のリスクであり、最終品質を担保するには人間による確認が不可欠だ。[[31](#ref-31)]

***

## 9. 優れたローカライズが生み出す価値

優れたローカライズはゲームを「翻訳した」という状態を超えて、対象市場でオリジナルと同等の体験を作り出す。ラチェット＆クランクがマンガ化されるほど日本市場に浸透できたのも、UNDERTALEが「公式日本語版こそが真の日本語版」として受け入れられたのも、ローカライズへの投資が正当化された結果だ。[[16](#ref-16)][[21](#ref-21)][[24](#ref-24)]

逆に、ローカライズを軽視して低品質な翻訳を出した場合、Steamのレビューやソーシャルメディアで「悪訳」として拡散され、売上とブランドの両方に影響する。ゲームプランナーの視点からは、 **ローカライズはリリース後の修正が難しい要素のひとつ** であり、開発フェーズの早期からローカライズチームを巻き込む設計が長期的なコスト削減にもつながる。[[6](#ref-6)][[5](#ref-5)][[35](#ref-35)]

プレイヤーの視点では、良いローカライズは「翻訳された感覚がない」ものだ。そのゲームがもともと自分たちのために作られたかのような没入感を生む。それはテキスト翻訳だけで達成できるものではなく、キャラクターの一人称ひとつ、造語のニュアンスひとつ、そしてカルチャライズの細部が積み重なって初めて実現する。[[16](#ref-16)][[11](#ref-11)]

---

## References

<a id="ref-1"></a>1. [ゲーム製作における「ローカライズ」とは？ - レバテッククリエイター](https://creator.levtech.jp/tips/article/224/) - ローカライズの作業には翻訳作業を含んでいますが、単なる「翻訳」の仕事とローカライズは微妙に異なります。翻訳は基本的に原文の意味・内容を変えず、他 ...

<a id="ref-2"></a>2. [ゲームのローカライズとは？翻訳との違い、考慮するポイントを解説](https://www.aiqveone.co.jp/blog/localise/) - カルチャライズとは、ゲームを販売する国の文化やその国のルールにゲームを合わせる作業を指します。ゲームのカルチャライズにおける作業は、言語の変更（ ...

<a id="ref-3"></a>3. [ゲーム翻訳におけるローカライズとカルチャライズの違い・重要性 ...](https://www.tanny-side.com/localization-culturalization/) - ローカライズ ：ある製品を、外国でも使用できるように、対象国の言語に変換すること。 カルチャライズ：対象国・地域の文化や風習に合わせて、表現などを ...

<a id="ref-4"></a>4. [Video Game Culturalization: Definition and Best Practices (IGDA ...](https://www.at-it-translator.com/video-game-culturalization-definition-and-best-practices-igda-locsig/) - The underlying principle of culturalization is that a minor investment of time and effort during the...

<a id="ref-5"></a>5. [Internationalization: The Hidden Framework of Game Localization](https://terrateamup.com/2025/12/22/internationalization-i18n-game-localization/) - Explore the role of internationalization (i18n) in game development and how it enables smooth, cost-...

<a id="ref-6"></a>6. [Game localization process: 8 essential steps for successful ... - Gridly](https://www.gridly.com/blog/game-localization-guide/) - Learn the ins and outs of the game localization process. Discover essential components, common chall...

<a id="ref-7"></a>7. [ゲームアプリのローカライズ対応 - Qiita](https://qiita.com/nekoharuyuki/items/f5273f2480f067a052ba) - ゲームアプリのローカライズ対応において、文字数の問題は重要な注意点のひとつです。ローカライズによって、文字数が増加することがあります。特に、 ...

<a id="ref-8"></a>8. [Understanding LQA in Game Localization - Wordfoxes](https://www.wordfoxes.com/insights/three-key-ws-of-lqa-what-when-and-why) - An LQA team running an i18n testing pass can spot future bugs in your game well before your translat...

<a id="ref-9"></a>9. [グローバル展開を成功させたい！『WOVN .games』開発者](https://gamemakers.jp/article/2024_09_18_77013/) - グローバル展開を成功させたい！『WOVN .games』開発者、ローカライズ歴15年以上のベテランが語る“多言語対応のコツ”とLQA効率化.

<a id="ref-10"></a>10. [ゲームのローカライズとは？内容や考慮すべきポイントを徹底解説](https://www.youtube.com/watch?v=yt9VWi2xxhU) - ボイログは声で聴くブログとして、翻訳会社サン・フレアが運用するメディアサイト“SunFlare Style”に掲載しているブログを音声合成でお届けする ...

<a id="ref-11"></a>11. [『UNDERTALE』AI翻訳に負けるな！作品愛が生み出す ...](https://www.gamespark.jp/article/2021/06/13/109510.html) - フルプライスの作品でも目を覆いたくなるようなひどい訳が存在します。優れたローカライズが評判の『UNDERTALE』はそれらの問題を乗り越え、翻訳において ...

<a id="ref-12"></a>12. [ゲームの世界観が正確に伝わる「和訳」とは？ - SunFlare Style](https://blog.sunflare.com/blog/001405.html) - ゲームのローカライズの中でも、言語の特性上、難易度が高いとされている和訳。本ブログでは、外国語訳との違いや日本語の特徴などを掘り下げます。

<a id="ref-13"></a>13. [Lip-Sync Dubbing: How We Match Words with Mouths - Force Media](https://force-media.tv/lip-sync-dubbing/) - Discover how lip-sync dubbing works, from script adaptation to mixing, and how we make translated di...

<a id="ref-14"></a>14. [Video Game Localization Examples: Good, Bad, and Ugly](https://wxrks.com/blog/video-game-localization-examples-good-bad-and-ugly) - Ratchet and Clank is ranked among the best-localized video games in various markets. The translation...

<a id="ref-15"></a>15. [ゲームのローカライズがうまくいかないのはなぜですか？ - 4Gamer](https://www.4gamer.net/games/999/G999905/20201208017/) - 中でもひどいのは，一行で「城戸沙織」の訳が3種類あったことだ。 一つ目は「Miss Yarn」（編注：あえて訳すなら「織り糸さん」），二つ目は「Saori」， ...

<a id="ref-16"></a>16. [The Importance of Culturalization in Video Game Localization](https://terralocalizations.com/2024/12/19/the-importance-of-culturalization-in-video-game-localization/) - Culturalization involves tailoring a game's content to align with the cultural norms, values, and ex...

<a id="ref-17"></a>17. [鶴見六百 - Wikipedia](https://ja.wikipedia.org/wiki/%E9%B6%B4%E8%A6%8B%E5%85%AD%E7%99%BE) - SCE『クラッシュ・バンディクーシリーズ』日本版プロデューサー. SCE『ラチェット&クランクシリーズ』日本版プロデューサー ... カルチャライズの重要性を世界に訴えた。

<a id="ref-18"></a>18. [Going Beyond Localizing Western Games For Japan, A Studio ...](https://www.siliconera.com/going-beyond-localizing-western-games-for-japan-one-studio-focuses-on-culturalization/) - "Character graphics and the art style is a big point. Instead of realistic characters, Japanese peop...

<a id="ref-19"></a>19. [How Ratchet & Clank Is Changed In Japan - YouTube](https://www.youtube.com/watch?v=oZmVcotzTsk) - Get The Japanese Ratchet & Clank Games ▻ https://www.play-asia.com/paOScore/search/ratchet+clank?tag...

<a id="ref-20"></a>20. [ラチェット&クランク 単語 - ニコニコ大百科](https://dic.nicovideo.jp/a/%E3%83%A9%E3%83%81%E3%82%A7%E3%83%83%E3%83%88&%E3%82%AF%E3%83%A9%E3%83%B3%E3%82%AF) - プロデュース、ゲームデザイン：ソニーピクチャーズモバイル 日本版ローカライズは本編と同じ鶴見六百(六百デザイン)が手がける。 「物質転送 ...

<a id="ref-21"></a>21. [Why Game Localization Needs AI - Blog - Lara Translate](https://blog.laratranslate.com/why-game-localization-needs-ai/) - The localization team retained the game's deeply Japanese identity while adapting modern slang, emot...

<a id="ref-22"></a>22. [『龍が如く7』の「外国人が英語で道を尋ねてくるシーン」、英語版 ...](https://automaton-media.com/articles/newsjp/20201014-140055/) - 『龍が如く7』の「外国人が英語で道を尋ねてくるシーン」、英語版ではどうローカライズしたのか。第四の壁を破る、『龍が如く』らしいユーモラスな手法。

<a id="ref-23"></a>23. [Poundmates? : r/yakuzagames - Reddit](https://www.reddit.com/r/yakuzagames/comments/jscix4/poundmates/) - How often did you use poundmates in Yakuza: LAD? I used all my poundmates for the first time in the ...

<a id="ref-24"></a>24. [『UNDERTALE』個人制作に近づくインディーゲームの魅力を ...](https://gamerszone.jp/post/534) - 翻訳小説や洋画の字幕制作と同じように、ローカライズ、なによりゲーム翻訳者が、もっと前面に出てきてくるようになるべきだ。良くも悪くも日本語に守られ ...

<a id="ref-25"></a>25. [『Undertale』『Deltarune』の公式翻訳が日本語だけの理由](https://gamestalk.net/undertale-deltarune-toby-fox-translation-vision-japanese-only/) - 『UNDERTALE』と『DELTARUNE』の生みの親、Toby Fox氏が2026年3月29日、Blueskyへの投稿で日本語以外の公式翻訳が存在しない理由を説明した。Fox氏は「公式にリリースす...

<a id="ref-26"></a>26. [Toby Fox氏がBlueskyで『Undertale』『Deltarune』に日本語以外の ...](https://x.com/gamenohanashi/status/2038674568462938370) - Fox氏は翻訳開始前に10行に1回の割合で注釈を入れた詳細資料を用意。SNSで常時つながり、質問にはその日のうちに回答する体制だった。 福市氏の証言でもう ...

<a id="ref-27"></a>27. [Undertale and Japanese Localization](https://japaneserpg.wordpress.com/2017/06/16/undertale-and-japanese-localization/) - What I'm more concerned about today is the localization into Japanese that was just announced. In ge...

<a id="ref-28"></a>28. [Sans - ピクシブ百科事典](https://dic.pixiv.net/a/Sans) - この非公式日本語版でUndertaleに初めて触れたプレイヤーも多かったことから、長らく「俺」がサンズの一人称として浸透していた。 ところが、2017年8月16日より ...

<a id="ref-29"></a>29. [Undertale非公式/公式日本語訳の表現対応の一覧[単語]](https://dic.nicovideo.jp/a/undertale%E9%9D%9E%E5%85%AC%E5%BC%8F%2F%E5%85%AC%E5%BC%8F%E6%97%A5%E6%9C%AC%E8%AA%9E%E8%A8%B3%E3%81%AE%E8%A1%A8%E7%8F%BE%E5%AF%BE%E5%BF%9C%E3%81%AE%E4%B8%80%E8%A6%A7) - 俺, オイラ, サンズ(Sans)の一人称。 とある場面では公式訳版でも「オレ」になる。 ; Sans · 兄ちゃん, Papyrus(パピルス)のサンズ(Sans)への呼び方。 ニコ ...

<a id="ref-30"></a>30. [『UNDERTALE』と『DELTARUNE』のクリエイターToby Fox氏が ...](https://mudauchi.info/gnr/articles/5895/) - Fox氏が自身の作品を日本語と英語以外の言語に翻訳しない理由として、翻訳が「自身のビジョン」と「合致」することを重視しているためとのことです。特に ...

<a id="ref-31"></a>31. [ゲームローカライズで「AI翻訳」はNGなのか？活用方法は？ - ブログ](https://blog.sunflare.com/blog/001778.html) - 結論として、ゲームローカライズにおいてAI翻訳がNGというわけではありません。 しかし、用途や品質基準を明確にしないまま使うことは、大きなリスクを ...

<a id="ref-32"></a>32. [生成AI×翻訳：AI翻訳事業のリアルを語る｜Katsuki Noda - note](https://note.com/ktknd/n/nb1d04718687d) - 外国で生まれたゲームが日本語版になって我々の前に姿を見せるとき，どうしても気になるのが翻訳（ローカライズ）の問題だ。非のwww.4gamer.net.

<a id="ref-33"></a>33. [Translator On Kingdom Come 2 Claims He Was Replaced With AI](https://kotaku.com/kingdom-come-2-translator-gen-ai-fired-warhorse-2000682854) - Kingdom Come: Deliverance 2's Translator Says He Was Fired Because Warhorse Plans To Use 'AI For All...

<a id="ref-34"></a>34. [Warhorse Studios Faced Backlash Over Kingdom Come 2 AI ...](https://www.linkedin.com/posts/nexsouk_warhorse-studios-faces-backlash-as-kingdom-activity-7444062151457239040-Q32J) - Warhorse Studios Faces Backlash for Firing Czech Translator and Replacing Them with AI In a controve...

<a id="ref-35"></a>35. [Investigating Steam's new language-specific review scores](https://games.alphacrc.com/investigating-steams-new-language-specific-review-scores/) - Poor localization in one language can cap a game's potential in that market, even if it's a hit else...

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
