---
description: "北米NESの10NESからSwitch 2のオンライン利用制限まで、任天堂の海賊版対策を本体・ゲーム・法の三つからたどる。正規のプレイヤーを巻き込んだ事例から、検出と救済の設計を考える。"
category: hardware-tech-protection
difficulty: yellow
---

# 海賊版をどう止め、正規のプレイヤーをどう守るか——任天堂の対策史を、本体・ゲーム・法の三つの手段で読む

> 2026年11月12日改版：記事全体を全面的に書き直しました。内容の変更はGitの履歴から追えます。

## はじめに

ゲーム機にカートリッジを差すと、本体はゲームを始める前に、そのソフトを起動してよいか確かめることがある。北米のNintendo Entertainment System（NES）では、この確認が無断複製品の抑止と、ライセンスを通じてソフトの品質や発売を管理する仕組みの両方を支えた。[[1](#ref-1)]

任天堂の対策史を、本体・ゲーム・法の三つの手段からたどる。本体はソフトの起動やサービスへの接続を制御する。ゲームはプレイ中にも異常を確かめ、挙動を変えられる。法律は装置やサービスの流通に働きかけ、利用規約は運営が接続を制限する際の根拠になる。どの手段でも、対象の線引きや判定を誤れば、正規に遊ぶ人に影響が及ぶ。

```
# 仕上げAIへ図表制作依頼
本体・ゲーム・法の三つの手段を3段に並べ、左から右へ進む共通の年代軸を1本置いた年表風の概念図。
1980年代：本体「1985年 北米NESの10NES」。
1990年代：ゲーム「北米版MOTHER2」「N64の初代スマブラ」、法「1992年 10NES訴訟」「1999年 日本で回避装置を規制」。
2000年代：本体「ゲームキューブのディスク」「2009年 Wii本体更新4.2」、法「2009年 R4の輸入・販売差止め」。
2010年代：本体「2018年 Switchの起動時の脆弱性・3DSのオンライン照合」、法「2011年 刑事罰導入」「2018年 回避サービスも規制」。
2020年代：本体「2025年 Switch 2のオンライン利用制限」、法「2024年 Yuzu訴訟の和解」「2025年 米国版利用規約の更新」。
同年代内の出来事は順序が読み取れるように配置する。2018年の本体欄では、Switchの脆弱性の公表を3DSの更新より左に置く。出典は本文の各参照。本文にない年や件数は補わない。背景は白。ラベルとaltは日本語。
```

***

## 本体が鍵を確かめる

### 北米NESの「ロック」と「キー」

1985年に北米で発売されたNESには、10NESと呼ばれる仕組みがあった。本体側のチップが「ロック」、カートリッジ側のチップが「キー」を担い、両者の通信で承認済みのカートリッジかどうかを確かめる。確認を通らなければゲームは起動しない。日本のファミリーコンピュータには、この仕組みはなかった。[[1](#ref-1)]

アタリゲームズとその子会社テンゲンは、任天堂の許諾を得ずにNES向けカートリッジを販売するため、互換チップを開発した。その過程でアタリ側は、米著作権局に虚偽の情報を申告して10NESのソースコードの写しを入手した。1992年、米連邦巡回区控訴裁判所は、任天堂の著作権侵害の主張が本案で認められる見込みがあると判断し、仮差止めを維持した。本体に組み込んだ鍵を、裁判では鍵を動かすプログラムの著作権が支えたのである。[[2](#ref-2)]

### ディスクの検証と、本体更新による対策

2000年代のゲームキューブでは、任天堂独自の光ディスクを本体が検証した。Hackadayの報告によれば、周辺機器メーカーは、その検証の弱点を突いて、任天堂の承認を経ない自社製ディスクを起動させた。物理的に複製しにくいディスクを採用しても、本体が正規品と判定する条件に弱点があれば、そこで制限を破られうる。[[3](#ref-3)]

本体のプログラムを更新できるようになると、出荷後にも検査の内容を変えられるようになった。Wiiの本体更新4.2は、無許可で追加されたチャンネルなどを検出し、取り除く処理を含んでいた。ニンテンドー3DSでは2018年7月の本体更新11.8で、Switchと同様に、オンラインでソフトの利用資格を照合する仕組みが加わったとNeowinが報じた。本体の中だけで完結していた確認の一部を、サービス側でも行えるようになった。[[4](#ref-4)][[5](#ref-5)]

### 出荷後に書き換えられない部分

2018年4月、初期のNintendo Switchに搭載されたTegra X1というチップの起動用ROMに、脆弱性があると公表された。起動用ROMは電源を入れた直後に動くプログラムを収めた書き換え不能な領域で、出荷済みの本体では更新によってこの欠陥自体を修正できない。同年7月、対策済みの本体が出荷され始めたとGame Developerが報じた。[[6](#ref-6)][[7](#ref-7)]

出荷済みの本体に修正できない弱点が残っても、サービス側で利用資格を照合したり、違反と判断した本体やアカウントの利用を制限したりする余地はある。このような利用制限を **BAN** と呼ぶ。回避装置の流通に対しては、法的手段も残る。2025年6月には、複製したゲームデータを読み込めるカートリッジ型の機器である **フラッシュカート（マジコン）** を使ったSwitch 2で、本体からオンラインサービスに接続できなくなったと報じられた。[[7](#ref-7)][[8](#ref-8)]

***

## ゲームの中で気づかせる

1990年代に発売された『MOTHER2』の北米版『EarthBound』には、コピー機器を検出すると敵の出現を増やし、要所でセーブデータを消す仕掛けがあると報じられている。報道が紹介した映像では、クリア目前でセーブデータが消えている。起動時に通過できても、プレイの途中や終盤で対策が発動しうる例である。[[9](#ref-9)]

NINTENDO 64の『大乱闘スマッシュブラザーズ』にも、起動回数に応じて段階的に挙動を変える仕掛けがあったと、解析を基に報じられた。対策が発動する条件下では、吹っ飛び方が変わるといった変化が起き、69回目の起動以降は、どのキャラクターを選んでもマリオになるとされる。[[10](#ref-10)][[11](#ref-11)]

### 仕掛けを遅らせる理由

PlayStation向けの『Spyro: Year of the Dragon』（2000年）で対策を手がけたInsomniac Gamesのギャビン・ドッド氏は、発売直後の販売を守るために、対策の解除までの時間を稼ぐことを目指した。起動後に発動する仕掛けを重ねれば、起動できた時点で対策を外し終えたと解読者が判断しやすい。ドッド氏によると、前作の『Spyro 2』は約1週間で解読されたが、今作では正常に動作する解除用の修正データが出るまで2か月以上かかった。[[12](#ref-12)]

ドッド氏が最大の懸念に挙げたのは誤検知だった。仕掛けによる挙動は普通の不具合と見分けにくい。そこでチームは、発動しうる場所ごとに、何を確認するか、何が起きるまで待つかを一覧にして検証した。信頼性に確信が持てない場合に備え、製品用のプログラムを組み立てる段階で対策全体を無効にできる設定も用意した。[[12](#ref-12)]

海賊版対策を題材にしたファンの創作も広まった。『マリオパーティDS』で海賊版を検知すると恐ろしい警告が出る、という映像はその一つで、ゲーム内に実在する警告画面として受け取られた。[[13](#ref-13)]

***

## 法で止める

### 日本：装置の販売から、回避サービスの提供まで

ソフトの起動や複製を技術で制限する仕組みを、不正競争防止法では **技術的制限手段** という。1999年の改正で、その制限を回避する装置などの提供が不正競争に加えられ、差止めや損害賠償を求める対象になった。[[14](#ref-14)]

任天堂とソフトメーカー54社は、ニンテンドーDS向けのマジコン「R4」の輸入・販売業者を提訴した。2009年2月27日、東京地裁は輸入・販売の差止めを認めた。本体で起動を制限する仕組みを設けた上で、その制限を回避する装置の流通を裁判で止めた事例である。[[15](#ref-15)][[16](#ref-16)]

2011年の改正では、回避以外の機能を併せ持つ装置にも規制の対象が広がり、回避装置の提供に刑事罰が導入された。関税法も改正され、対象となる装置は輸入禁制品になった。2012年2月にはWiiの改造を代行した業者に有罪判決が言い渡され、同年5月にはマジコン販売業者に対する初の刑事摘発があった。[[17](#ref-17)][[18](#ref-18)][[19](#ref-19)]

別のマジコン訴訟では、2013年7月9日、東京地裁が輸入・販売の差止めに加え、任天堂に総額9,562万5,000円を賠償するよう命じた。2016年1月12日に最高裁が上告を棄却し、上告審として受理しないと決定したことで判決は確定した。任天堂の発表は同月19日である。[[20](#ref-20)][[21](#ref-21)]

2018年の改正では、技術的制限手段を回避するサービス（役務）の提供も不正競争に加わった。また、2025年1月には、改造したNintendo Switchを販売した男性が商標法違反の疑いで逮捕され、改造Switchの販売をめぐる同法での摘発は全国初と報じられた。装置やサービスを対象とする不正競争防止法に加え、改造品を販売する際の商標の扱いも争点になりうる。[[22](#ref-22)][[23](#ref-23)]

### 米国：刑事事件と民事訴訟

2022年2月、米連邦地裁は、海賊版の利用を可能にする機器を販売していたTeam Xecuterのゲイリー・ボウザー氏に禁錮40か月を言い渡した。販売や広報を担った人物が刑事責任を問われた例である。[[24](#ref-24)]

2024年3月には、ゲーム機の動作を別の機器上で再現するソフトウェアである **エミュレータ** の一つ、Nintendo Switch向けの「Yuzu」を開発したTropic Hazeが、任天堂に240万ドルを支払う条件で和解し、配布を停止した。この件では、任天堂がYuzuによる保護機能の回避を問題とし、当事者の合意を受けて裁判所が配布などを禁じる命令を出した。[[25](#ref-25)][[26](#ref-26)]

2025年9月には、改造したSwitch本体などを販売したライアン・デイリー氏に対し、米連邦地裁が当事者の合意に基づいて200万ドルの支払いを命じ、対象機器の販売などを恒久的に禁じた。[[27](#ref-27)][[28](#ref-28)]

### 利用規約で定める措置

2025年5月、任天堂はニンテンドーアカウント利用規約を更新した。米国版では、無許可の複製や保護機能の回避などに関する制限に違反すると、アカウントサービスや対象の任天堂機器の全部または一部が恒久的に使えなくなりうる、と明記された。日本版にも知的財産権や禁止事項に関する条項がある一方、米国版には仲裁など独自の条項もある。本体の使用不能に言及しているのは米国版の規約上の措置であり、先に触れたSwitch 2の報道で確認された影響はオンラインサービスの停止である。[[8](#ref-8)][[29](#ref-29)][[30](#ref-30)][[31](#ref-31)]

***

## 正規のプレイヤーを巻き込むとき

2009年のWii本体更新4.2では、改造していないとする利用者からも、本体が起動しなくなったという報告が出た。米国任天堂は、改造されていない本体で更新後に問題が起きた場合、無償で修理すると表明した。異常の原因が判定処理にあったかどうかとは別に、改造への対策を含む更新によって、正規の利用者にも本体を使えない時間が生じた。[[4](#ref-4)][[32](#ref-32)]

2025年7月には、中古で買った初代Switch用のゲームカードをSwitch 2で遊んだ利用者が、本体のオンライン利用を止められたと報じられた。購入の証拠を任天堂のサポートに示したところ、制限は解除されたという。報道は、前の持ち主がカードのデータを複製してから売った可能性を指摘している。停止の判定に使われた条件は公表されていない。[[33](#ref-33)][[34](#ref-34)]

ドッド氏が誤検知を最も恐れた理由は、正規に遊ぶ人の画面にも対策の副作用が現れうるからだ。『Spyro』の開発チームは、発売前に発動箇所を確かめ、仕掛けを外せるようにした。Wiiの修理や中古カード利用者の制限解除では、発売後にサポートが遊べる状態へ戻す役割を担った。対策を動かす条件と、影響を受けた人を元に戻す手段の両方が、プレイヤーの体験を左右する。[[12](#ref-12)][[32](#ref-32)][[33](#ref-33)]

***

## プランナーが持ち帰れること

### 検出と措置を別々に決める

何を異常とみなすか、検出後にどの機能を止めるか、誤って発動した場合にどう戻すか。この三つは、仕様の段階で決めておきたい。たとえばカードに関する異常だけで本体全体のオンライン利用を止めるなら、正規の中古購入者にも影響が及ぶ可能性を考える必要がある。サポートが購入記録を受け付け、判定を見直し、制限を解除できるところまでが、対策の設計範囲に入る。

### 止めるか、時間を稼ぐか

ドッド氏の目的は、発売直後の販売を守れるだけの時間を稼ぐことだった。オンライン運営でも、検出と同時にBANするか、追加の確認を待ってから措置を取るかは、目的によって変わる。待つあいだに不正利用が広がるなら、影響のある機能を一時的に制限する余地がある。判定が曖昧で、止めた際の影響が大きいなら、確認を重ねてから措置の範囲を決める方が、正規の利用者への影響を抑えやすい。[[12](#ref-12)]

### 強い措置ほど、見直せる仕組みを持つ

出荷済みの本体に修正できない弱点があれば、装置の流通には法が、サービスの利用には規約が対策を支える。規約上の措置が重くなるほど、一度の誤判定でプレイヤーが失うものも大きくなる。どこまで止めるかを決めるときは、解除の条件、問い合わせ先、プレイを再開できるまでの時間も合わせて考えたい。

## References

<a id="ref-1"></a>1. [Casey O'Donnell「The Nintendo Entertainment System and the 10NES Chip: Carving the Video Game Industry in Silicon」][1] — Games and Culture 6(1)、2011年。

[1]: https://doi.org/10.1177/1555412010377319

<a id="ref-2"></a>2. [米国著作権局「Atari Games Corp. v. Nintendo of Am. Inc., 975 F.2d 832 (Fed. Cir. 1992)」][2] — Fair Use Index、1992年9月10日の判決の要約。

[2]: https://www.copyright.gov/fair-use/summaries/atari-nintendo-fedcir1992.pdf

<a id="ref-3"></a>3. [Hackaday「How One Company Cracked The GameCube Disc Protection」][3] — Hackaday、2019年2月4日。

[3]: https://hackaday.com/2019/02/04/how-one-company-cracked-the-gamecube-disc-protection/

<a id="ref-4"></a>4. [Nintendo of America「Historique des mises à jour du menu système pour Wii」][4] — 任天堂サポート（フランス語版）、バージョン4.2の項。日本語版の更新履歴には、不正なデータの削除についての記載がない。

[4]: https://fr-americas-support.nintendo.com/app/answers/detail/a_id/14539/p/604/c/898

<a id="ref-5"></a>5. [Neowin「Nintendo's anti-piracy measures arrive on the 3DS with the latest update」][5] — Neowin、2018年。

[5]: https://www.neowin.net/news/nintendos-anti-piracy-measures-arrive-on-the-3ds-with-the-latest-update/

<a id="ref-6"></a>6. [Cisco「NVIDIA TX1 Boot ROM Vulnerability」][6] — Cisco Security Advisory、2018年6月20日。

[6]: https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-20180620-nvidia-tx1-rom

<a id="ref-7"></a>7. [Game Developer「Nintendo reportedly rolls out hardware patch following Switch exploit」][7] — Game Developer、2018年7月11日。

[7]: https://www.gamedeveloper.com/production/nintendo-reportedly-rolls-out-hardware-patch-following-switch-exploit

<a id="ref-8"></a>8. [Nintendo Life「Nintendo Reportedly Banning Switch 2's Using MIG Cartridges」][8] — Nintendo Life、2025年6月。

[8]: https://www.nintendolife.com/news/2025/06/nintendo-reportedly-banning-switch-2s-using-mig-cartridges

<a id="ref-9"></a>9. [Siliconera Staff「Earthbound punishes pirates by deleting game saves」][9] — Siliconera。

[9]: https://www.siliconera.com/earthbound-punishes-pirates-by-deleting-game-saves/

<a id="ref-10"></a>10. [Kosuke Takenaka「初代『スマブラ』実は海賊版対策に“遅延式おしおき”満載だった」][10] — AUTOMATON、2025年9月22日。ゲームの解析を紹介した報道。

[10]: https://automaton-media.com/articles/newsjp/super-smash-bros-20250922-358658/

<a id="ref-11"></a>11. [John Walker「Super Smash Bros. On N64 Had A Very Funny Anti-Piracy Trick」][11] — Kotaku、2025年9月。

[11]: https://kotaku.com/super-smash-bros-n64-piracy-nintendo-2000627887

<a id="ref-12"></a>12. [Gavin Dodd「Keeping the Pirates at Bay」][12] — Game Developer（旧Gamasutra）、2001年10月17日。

[12]: https://www.gamedeveloper.com/business/keeping-the-pirates-at-bay

<a id="ref-13"></a>13. [AUTOMATON「任天堂が『マリオパーティDS』にて“恐ろしい海賊版対策”を施していたという噂が広まる」][13] — AUTOMATON、2021年1月12日。

[13]: https://automaton-media.com/articles/newsjp/20210112-148761/

<a id="ref-14"></a>14. [安田和史「ゲーム市場の動向と平成23年不正競争防止法改正」][14] — 日本大学法学部『知財ジャーナル』第8号、2015年。

[14]: https://www.publication.law.nihon-u.ac.jp/pdf/property/property_8/each/08.pdf

<a id="ref-15"></a>15. [任天堂「ニンテンドーDS用装置に対する訴訟について」][15] — 任天堂ニュースリリース、2009年2月27日。

[15]: https://www.nintendo.co.jp/corporate/release/2009/090227.html

<a id="ref-16"></a>16. [東京地方裁判所「平成20年（ワ）第20886号・第35745号 不正競争行為差止等請求事件」][16] — 裁判所ウェブサイト「裁判例検索」、2009年2月27日判決。

[16]: https://www.courts.go.jp/hanrei/37392/detail7/index.html

<a id="ref-17"></a>17. [経済産業省「不正競争防止法の概要」][17] — 経済産業省。平成以降の主な法律改正の項。

[17]: https://www.meti.go.jp/policy/economy/chizai/chiteki/pdf/unfaircompetition_textbook.pdf

<a id="ref-18"></a>18. [任天堂「ニンテンドーDS用装置の販売者に対する刑事摘発について」][18] — 任天堂ニュースリリース、2012年5月30日。Wii改造代行事件の有罪判決にも言及。

[18]: https://www.nintendo.co.jp/corporate/release/2012/120530.html

<a id="ref-19"></a>19. [GameBusiness.jp「任天堂、『マジコン』販売者に対して初の刑事摘発」][19] — GameBusiness.jp、2012年5月30日。

[19]: https://www.gamebusiness.jp/article/2012/05/30/6177.html

<a id="ref-20"></a>20. [任天堂「ニンテンドーDS用装置に対する訴訟について」][20] — 任天堂ニュースリリース、2013年7月9日。

[20]: https://www.nintendo.co.jp/corporate/release/2013/130709.html

<a id="ref-21"></a>21. [任天堂「ニンテンドーDS用装置に対する訴訟について」][21] — 任天堂ニュースリリース、2016年1月19日。最高裁の決定日は同月12日。

[21]: https://www.nintendo.co.jp/corporate/release/2016/160119.html

<a id="ref-22"></a>22. [経済産業省「不正競争防止法（平成30年改正）の概要」][22] — 経済産業省。技術的制限手段の効果を妨げる行為に、サービスの提供等を追加した項。

[22]: https://www.meti.go.jp/policy/economy/chizai/chiteki/180613meti2.pdf

<a id="ref-23"></a>23. [電ファミニコゲーマー「『Nintendo Switch』を改造・販売した男性が商標法違反疑いで逮捕。全国初の摘発」][23] — 電ファミニコゲーマー、2025年1月16日。

[23]: https://news.denfaminicogamer.jp/news/2501162h

<a id="ref-24"></a>24. [米司法省ワシントン州西部地区連邦検事局「Public voice and principal salesperson for notorious videogame piracy group sentenced to 3+ years in prison for conspiracy」][24] — 米司法省、2022年2月10日。

[24]: https://www.justice.gov/usao-wdwa/pr/public-voice-and-principal-salesperson-notorious-videogame-piracy-group-sentenced-3

<a id="ref-25"></a>25. [Game Developer「Switch emulator Yuzu reaches $2.4 million settlement with Nintendo」][25] — Game Developer、2024年3月4日。

[25]: https://www.gamedeveloper.com/business/switch-emulator-yuzu-reaches-2-4-million-settlement-with-nintendo

<a id="ref-26"></a>26. [米ロードアイランド地区連邦地裁「Nintendo of America Inc. v. Tropic Haze LLC」][26] — Justia掲載の訴訟記録、2024年3月6日の終局判決・恒久的差止命令の項。

[26]: https://dockets.justia.com/docket/rhode-island/ridce/1:2024cv00082/56980

<a id="ref-27"></a>27. [米ワシントン州西部地区連邦地裁「Nintendo of America Inc. v. Daly — Final Judgment and Permanent Injunction」][27] — 2025年9月26日登録、TorrentFreak掲載の判決文。

[27]: https://torrentfreak.com/images/nintendo-daly197112005041.pdf

<a id="ref-28"></a>28. [AUTOMATON「任天堂に訴えられたNintendo Switch本体改造業者、賠償金『約3億円』など命じられる」][28] — AUTOMATON、2025年9月8日。当事者の合意を報道。

[28]: https://automaton-media.com/articles/newsjp/nintendo-switch-20250908-356797/

<a id="ref-29"></a>29. [任天堂「ニンテンドーアカウント利用規約/プライバシーポリシーの更新について」][29] — 任天堂サポート、2025年5月7日。

[29]: https://support.nintendo.com/jp/information/2025/0507/index.html

<a id="ref-30"></a>30. [K.K.@Game*Spark「ニンテンドーアカウント規約変更―米国内向けは海賊版および不正改造への対応強化明記」][30] — GameBusiness.jp、2025年5月10日。

[30]: https://www.gamebusiness.jp/article/2025/05/10/24226.html

<a id="ref-31"></a>31. [Jackson Chen「Nintendo grants itself the power to brick Switches with pirated games」][31] — Engadget、2025年5月10日。米国版の規約文言を引用。

[31]: https://www.engadget.com/gaming/nintendo/nintendo-grants-itself-the-power-to-brick-switches-with-pirated-games-162129077.html

<a id="ref-32"></a>32. [Brendan Sinclair「Wii 4.2 update bricking some systems」][32] — GameSpot、2009年10月5日。

[32]: https://www.gamespot.com/articles/wii-42-update-bricking-some-systems/1100-6230816/

<a id="ref-33"></a>33. [Jackson Chen「Switch 2 user warns about accidental ban after playing preowned game cards」][33] — Engadget、2025年7月12日。利用者の申告をもとにした報道。

[33]: https://www.engadget.com/gaming/nintendo/nintendo-reportedly-bans-switch-2-user-playing-preowned-game-cards-192452163.html

<a id="ref-34"></a>34. [Tom's Hardware「Nintendo bans Switch 2 owner after they played used Switch 1 games」][34] — Tom's Hardware、2025年7月12日。同じ利用者の申告を扱った報道。

[34]: https://www.tomshardware.com/video-games/handheld-gaming/nintendo-bans-switch-2-owner-after-they-played-used-switch-1-games-decision-eventually-reversed-after-proving-innocence

英語資料の説明は、本稿で日本語に要約した。

----

この文書は、Perplexity、Claude、ChatGPT の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
