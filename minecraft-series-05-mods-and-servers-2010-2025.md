---
description: "BukkitとForgeが広げた遊びから、公式パートナーサーバー、収益化や通報のルール、Java版の難読化撤廃までをたどり、作り手・運営者・Mojangの分担を考える。「Minecraft――一人の個人制作から世界最大級のIPへ」第5回。"
category: series-ip-strategy
difficulty: green
---

# 公式が作らなかった遊びを、誰が作ったのか――MinecraftのModとサーバー（2010〜2025年）

2017年7月7日、64,533人が『Minecraft』のHypixelに同時に接続していた。Hypixelは、独立して運営されている『Minecraft』のサーバー網だ。ギネス世界記録は同日の数字を、最も人気のある『Minecraft』のサーバー網と、ゲームを問わず、把握されている中で最も人気のある独立運営サーバーの二部門で認定した。[[1](#ref-1)][[2](#ref-2)]

[第3回](minecraft-series-03-microsoft-acquisition-2014.md)では、独立したサーバーの運営者が何を売り、どう事業を続けるかをめぐって、Mojangとの間に議論が起きたところまで見た。[前回](minecraft-series-04-world-generation-2010-2021.md)で追ったのは、Mojangが地形を作る規則を更新する話だった。今回は、その地形の上に遊び場を作った人たちの話である。プレイヤーが作ったMod（ゲームの改造）と、プレイヤーや事業者が運営するサーバーは、それぞれどこまで遊びを変えられたのか。運営が広がるにつれて、作品の持ち主であるMojangはどんな判断を引き受けたのか。

***

## 2010〜2011年｜運営の道具と、ゲームを変える道具

2010年に開発が始まったBukkitは、Java版のサーバーに「プラグイン」と呼ばれる追加機能を組み込むための仕組みだ。追加機能がゲームに指示を出せるよう、呼び出し方を決めておく。この取り決めをAPIという。CraftBukkitは、通常のサーバーソフトを置き換え、Bukkit向けのプラグインを動かす改造サーバーソフトである。管理者がサーバーに組み込めば、プレイヤーは改造していないゲームで接続できる。既存のブロックを使ったミニゲームは作れるが、プレイヤー側にも登録が必要な新しい種類のブロックやアイテムは、サーバー側だけでは足せない。[[3](#ref-3)][[4](#ref-4)][[5](#ref-5)]

管理者は、誰にどの操作を許すかを決める権限管理、指定の場所へ移動させるテレポート、他人の建物を壊せないようにする土地の保護などを組み合わせられる。例えば、広場では全員が歩き回れ、建築区画では持ち主だけがブロックを置けるようにする。別の区画に移動すれば、同じブロックを使った対戦が始まる。ゲーム本体が共通でも、管理者が何を組み合わせ、どんなルールで運営するかによって、訪れた先の遊びは変わる。[[4](#ref-4)]

2011年には、複数の改造を一緒に使えるようにするMinecraft Forgeの開発が始まった。Forgeはゲーム本体とModの間に入り、Modを読み込んで動かす仕組みで、こうした仕組みをModローダーと呼ぶ。新しいブロックやアイテム、それを使った仕組みまで足せる。例えば新しい機械を置いて動かすModで一緒に遊ぶなら、サーバーにも、参加する人のゲームにもForgeとそのModが要る。サーバーが機械の動作を処理できても、参加者のゲームがその機械を知らなければ、同じものとして扱えないからだ。画面表示だけを変えるなど、片側で完結するModもある。[[6](#ref-6)][[5](#ref-5)]

Bukkitでは管理者が改造を引き受け、参加者は手持ちのゲームのまま入れる。Forgeで新しい物を足す場合は、運営者と参加者が同じ改造をそろえる分、ゲームの中に置けるものや動かせる仕組みが増える。

後年の[Bedrock版](minecraft-endless-design-java-bedrock-strategy.md)では、対応するワールドに持ち主が公式の仕組みであるAdd-Onを有効にしてブロックやアイテム、見た目や振る舞いを追加でき、公式の貸し出しサーバーでは参加時に必要なデータが自動で届く。[[7](#ref-7)][[8](#ref-8)]

***

## 2012〜2014年｜公式APIの約束と、Bukkitの持ち主

2012年2月28日、MojangはBukkitの開発者4人を雇い、サーバーとModを支える公式APIを作ると発表した。SpoutやForgeも候補として話題に上るなか、開発を率いたJens Bergensten氏は、Mojangが改造そのものより先まで見据えており、Bukkitの開発者は常にサーバー管理者を念頭に置いてきたと説明した。既存のBukkitは当面続き、公式APIが出たら移りやすくしたいという計画だった。[[3](#ref-3)]

一方で、サーバーの運営を続けるには資金が要る。2014年6月にMojangが示した、入場料・広告・見た目だけのアイテムを認め、遊びの有利不利に関わるものの販売に線を引く収益化方針は、[第3回](minecraft-series-03-microsoft-acquisition-2014.md)で扱った。

同年8月21日、Bukkitのリードは、ゲームの利用条件を定めるEULA（利用許諾契約）の変更と、そのルールをMojangが実際に適用し始めたことを理由に、開発を終えると宣言した。Bergensten氏は、MojangがBukkitを買い取っており、終了を決める権限はリード本人にはないと述べた。リードも、Mojangによる買い取りが雇用の条件だったと認めた。9月には、元開発者が、CraftBukkitなどの公開をやめるよう求める著作権の削除通知を出した。[[9](#ref-9)][[10](#ref-10)]

多くのサーバーが頼る道具の持ち主が誰で、誰が開発の継続を決められるのかが、終了宣言をきっかけに表に出た。サーバー運営者から見ると、Bukkit向けにそろえたプラグインを使い続けられるか、本体の次の更新に合わせて誰がCraftBukkitを直すかという問題でもあった。2012年に構想された、サーバーとModを広く支える公式APIは、その後も公開されていない。Mojangが後に用意したのは、用途を絞った拡張の仕組みや、作り手が本体の動きを調べやすくする手立てだった。[[3](#ref-3)][[9](#ref-9)]

***

## 2017年｜ゲームの中にサーバーへの入口を作る

Java版では、プレイヤーや事業者が自分でサーバーを立て、運営者が知らせた接続先にプレイヤーが入る。2017年6月、Mojangは家庭用ゲーム機やスマートフォンなどで遊べるBedrock版に向けて、Lifeboat、Mineplex、InPvP、CubeCraftの4組と組むと発表した。対応機種のプレイヤーは、ゲーム内のサーバー一覧から、事業者が運営する遊び場に直接入れる。公式がその一覧に載せる相手を選び、保護者向けの設定や安全機能も用意する形だった。[[11](#ref-11)]

自分で接続先を知らせて人を集めるJava版のサーバーに対して、この枠では、Mojangがゲーム内の入口を用意し、提携先がその先の遊びを運営する。仲間内のワールドを持ちたい人には、ワールドの持ち主が参加者を招待でき、公開サーバー一覧から誰でも入る形をとらない[公式の貸し出しサービスRealms](minecraft-endless-design-java-bedrock-strategy.md)もある。[[11](#ref-11)]

同年10月25日には、Java版1.13の最初の開発版でデータパックが導入された。データパックは、サーバー管理者や一人で遊ぶ人が、通常のゲームのままワールドごとにデータを追加・差し替えられる公式の仕組みだ。サーバーで使う場合、参加者は個別にModを入れなくてよい。導入時には、関数（複数のコマンドをまとめたもの）、戦利品の表（敵が落とす品や宝箱の中身を決めるもの）、建造物のデータ、進捗（ゲーム内の達成項目）などが扱えた。例えば、探索先の宝箱に入る品や、攻略の達成を知らせる条件を独自のものにできる。[[12](#ref-12)]

データパックで変えられる範囲は、本体がデータとして読み込む対象に沿って決まる。Forgeを使うModのように、独自の動作を持つ新しい種類のブロックを自由に登録する仕組みではない。本体の機能として更新される一方、形式が変われば作り手はパックを合わせ直す必要がある。[[5](#ref-5)][[12](#ref-12)]

***

## 2019年｜改造する人に、元の名前を渡す

Java版の配布プログラムには長く、難読化が施されていた。プログラム内で処理やデータに付けた名前を短い記号のような名前へ置き換え、中身を読み解きにくくする処理である。Modの作者が例えばアイテムを使ったときの動作を変えたければ、まず、どの処理がそれを担当しているかを見つける必要があった。Mojangは2019年、置き換えた名前と元の名前の対応表を公開した。これは作者や開発ツールが使う資料で、遊ぶ人が入れる追加機能ではない。対応表で名前を引けるようになっても、どこを改造すれば狙った動きになるかは作者が調べる。[[13](#ref-13)]

***

## 2022年｜所有と安全をめぐる二つの線引き

### Mojangはゲーム内の遊びとNFTのひもづけを認めず

2022年7月20日、Mojangは、ブロックチェーン技術を『Minecraft』のクライアント（遊ぶ人の端末で動くゲーム）やサーバーに組み込むことを認めず、ワールドや見た目のデータなど、ゲーム内のコンテンツにひもづけたNFTの作成も認めないと発表した。ブロックチェーンは取引などの記録を複数の参加者で共有する仕組みで、ここでいうNFTは、その記録を使って個別のデジタル項目の所有を示すものだ。例えば運営者がNFTの所有を確かめる仕組みを組み込めば、持っている人だけに特定の見た目を使わせることができる。Mojangは、こうした希少性と排除を土台にした所有の仕組みが、誰もが創作に参加し、一緒に遊ぶという『Minecraft』の価値に合わないと説明した。[[14](#ref-14)]

この線は現行の利用ガイドラインにも残る。Modの規定は、NFTを持っているかを直接・間接に確かめ、見た目や機能などを解放するものを、認めない例として挙げている。[[15](#ref-15)]

### サーバーの外にも通報先を用意する

同年7月27日、Java版1.19.1にプレイヤー通報機能が入った。参加者がゲームの標準画面で問題のあるチャット発言と通報理由を選び、Mojangに直接送れる。運営者が通報用のプラグインを入れる仕組みではなく、独立運営のサーバーにも及ぶ。Mojangは、どのサーバーでも安全に遊べるようにするためだと説明した。公式の質疑応答によれば、独立したJava版サーバーのチャットを常時監視するのではなく、提出された通報を担当者が人の手で審査する。前後の発言も判断材料になり、処分を受けた人は再審査を申し立てられる。[[16](#ref-16)][[17](#ref-17)]

報道では、コミュニティサーバーを自分たちで管理してきた運営者から、サーバーで追放した参加者が通報機能を悪用し、自分たちのアカウントが止められるのではないかという懸念が出た。運営者が自分のサーバーだけで行う追放と、Mojangの判断でオンラインプレイが停止されることでは、処分の及ぶ範囲が違う。Mojangのコミュニティ担当者は、意見を聞く姿勢を示しつつ、通報機能を含む設計方針は撤回しない考えを示した。[[18](#ref-18)][[19](#ref-19)]

***

## 2025年｜配布するゲームに元の名前を残す

2025年10月29日、MojangはJava版の難読化そのものをやめると発表した。11月には通常の開発版と並行して難読化していない試験版を配り、Mod作者やツールの開発者が移行を試せるようにした。12月16日に公開した26.1の最初の開発版では、クライアントとサーバーの配布プログラムを難読化せず、今後もその形で配布すると告知した。[[13](#ref-13)][[20](#ref-20)][[21](#ref-21)]

2012年の公式API構想は、追加機能が本体とやり取りするための決まった入口を用意するものだった。2025年の変更が助けるのは、その入口を自分たちで作ったり、本体の動作を調べてModを直したりする人だ。対応表を引く手間が減り、エラーの記録から問題が起きた処理を探しやすくなる。更新のたびにModが動くかを確認する仕事は残る。Mojangは、EULAと利用ガイドラインが引き続き適用されることも明記している。[[3](#ref-3)][[13](#ref-13)]

***

## 現行の利用ガイドラインで、サーバーは何を売れるか

2014年に表面化した収益化の問題は、現在の公式の利用ガイドラインにも続いている。2026年11月17日に確認した「Servers and hosting」では、誰に何を売るかに加え、買ったものが競争やほかの参加者の体験にどう影響するかで線を引いている。[[15](#ref-15)]

| 項目 | 現行ガイドラインでの扱い |
| --- | --- |
| 入場料 | 全員に同じ料金を課すなら可。課金する間は運営者がサーバーを所有または管理し、管理用のものを除き、有効にしたModを支払った全員が使えるようにする。 |
| 寄付 | 寄付した人だけが使える特典を渡さない範囲で可。目標額に達したとき、参加者全員に特典を渡すことはできる。 |
| 見た目のアイテム | 販売可。マントや、プレイヤーのマントのように見せるものは対象外である。 |
| 遊びに影響する特典 | 競争上の有利を与えず、ほかの参加者の体験を損なわない範囲で販売可。 |
| ゲーム内の仮想通貨 | 現実の価値を持たず、換金できず、別のサーバーで利用・移転できないなどの条件を満たせば可。公式通貨との混同も避ける。 |
| ゲーム外の所有・利用資格 | ゲーム外のコンテンツ、商品、サービスを持っているか、利用できるかによって入場を制限することは不可。 |

例えば、寄付の目標を達成した日に全員で参加できるイベントを開くことと、寄付した人だけが使える道具を渡すことでは、同じ寄付でも扱いが分かれる。また、現行の文面では、遊びに影響するかどうかだけで販売の可否は決まらない。競争上の有利と、ほかの参加者の体験への影響をそれぞれ見る必要がある。[[15](#ref-15)]

***

## 2010〜2025年の年表

| 年 | 遊びを作る仕組み | サーバー運営・公式の方針 |
| --- | --- | --- |
| 2010 | Bukkitの開発開始。[[3](#ref-3)] | — |
| 2011 | Forgeの開発開始。[[6](#ref-6)] | — |
| 2012 | MojangがBukkitの開発者4人を雇い、公式APIの構想を発表。[[3](#ref-3)] | — |
| 2014 | Bukkitの終了宣言を受け、Mojangが所有を明らかにする。後にCraftBukkitなどへの削除通知が出される。[[9](#ref-9)][[10](#ref-10)] | [6月にサーバーの収益化方針を提示](minecraft-series-03-microsoft-acquisition-2014.md)。 |
| 2017 | Java版1.13の開発版にデータパックが登場。[[12](#ref-12)] | Bedrock版のパートナーサーバーを発表。Hypixelが同時接続64,533人を記録。[[11](#ref-11)][[1](#ref-1)][[2](#ref-2)] |
| 2019 | Java版の難読化の対応表を公開。[[13](#ref-13)] | — |
| 2022 | — | ブロックチェーン技術の組み込みを認めない方針を公表。Java版1.19.1で通報機能を導入。[[14](#ref-14)][[16](#ref-16)] |
| 2025 | 10月にJava版の難読化撤廃を発表し、12月に26.1の開発版で実施。[[13](#ref-13)][[21](#ref-21)] | — |

***

## 編者の考察｜遊びを任せるときに決めておくこと

[Modを許す範囲を考えた記事](modding-merits-demerits-culture-law-developers.md)では、開発元によって方針がどう異なるかを見た。『Minecraft』の事例からは、許可の文面とあわせて、開発元・作り手・運営者の間で仕事をどう分けるかという三つの判断が見えてくる。

1. **何を作れるかと、誰が導入するかを一緒に決める。** 初めて来た人もすぐに入れる対戦なら、サーバー側の改造でできることから考える。全員が新しい機械を扱う遊びなら、参加者も同じModを入れ、更新時にはその組み合わせをそろえる必要がある。公式の拡張機能を用意するなら、どのデータを変えられ、更新に伴う変更を誰が知らせるかまでが仕様になる。
2. **広がる前に、外部の道具が止まった場合を考える。** 運営が依存する道具については、誰が更新や配布を決められるか、引き継ぐ人がいるかを確認する。開発が止まれば、しばらく旧版を使うか、別の仕組みに移るかを運営者が決めることになる。手持ちのワールドや参加者の権限を移せるかは、その判断にかかる時間を左右する。
3. **線を引くときは、守りたいものも公表する。** 有料の特典が対戦の公平さに触れる場面、ゲーム外の所有が参加条件になる場面、運営者と作品の持ち主の両方が安全に責任を持つ場面では、それぞれルールが必要になる理由が異なる。誰が判断し、その判断がどこまで及ぶかを明らかにしておけば、新しい売り方や技術が出たときにも、どの条件を見直すのかが伝わる。

サーバーとModがプレイヤーや運営者の手で遊ぶ場所を広げたのに続き、第6回では、MojangとMicrosoftが教育版を通じて教室へと場所を広げた経緯を追う。

## References

<a id="ref-1"></a>1. [Guinness World Records「Most popular Minecraft server network」][1] — Guinness World Records、記録日2017年7月7日。

[1]: https://www.guinnessworldrecords.com/world-records/385022-most-popular-minecraft-server-network

<a id="ref-2"></a>2. [Guinness World Records「Most popular independent server for a videogame」][2] — Guinness World Records、記録日2017年7月7日。把握されている独立運営サーバーの記録。

[2]: https://www.guinnessworldrecords.com/world-records/488904-most-popular-independent-server-for-a-videogame

<a id="ref-3"></a>3. [Tom Curtis「Mojang hires mod team to build official Minecraft API」][3] — Game Developer、2012年2月28日。Bukkitの開発開始年とMojangの発表を伝える。Bergensten氏の発言は大意。

[3]: https://www.gamedeveloper.com/business/mojang-hires-mod-team-to-build-official-i-minecraft-i-api

<a id="ref-4"></a>4. [Cody M. Sommer『Building Minecraft Server Modifications - Second Edition』][4] — Packt、2015年。「Deploying a Spigot Server」の「An introduction to Spigot」でBukkit APIとCraftBukkitの関係を説明している。

[4]: https://www.packtpub.com/en-us/product/building-minecraft-server-modifications-second-edition-9781785883026

<a id="ref-5"></a>5. [Minecraft Forge「Sides」][5] — Forge Documentation。「One-Sided Mods」を参照。

[5]: https://docs.minecraftforge.net/en/latest/concepts/sides/

<a id="ref-6"></a>6. [Aaron Mills「A Brief History of Minecraft Modding」][6] — Packt、2015年6月3日。Forgeの誕生とModを併用するための仕組みの変遷を説明している。

[6]: https://www.packtpub.com/en-us/learning/tech-guides/brief-history-minecraft-modding

<a id="ref-7"></a>7. [Minecraft Help「Learn about Minecraft: Bedrock Edition Add-Ons」][7] — Minecraft Help。Add-Onが変更できる内容と利用範囲を参照。

[7]: https://help.minecraft.net/hc/en-us/articles/4409140076813

<a id="ref-8"></a>8. [Minecraft Help「Activate Add-Ons in Minecraft: Bedrock Edition」][8] — Minecraft Help。Realmsでの有効化と参加時の配布を参照。

[8]: https://help.minecraft.net/hc/en-us/articles/24120525083533

<a id="ref-9"></a>9. [Andy Chalk「Minecraft Bukkit team lead tries to end development, but Mojang steps in」][9] — PC Gamer、2014年8月21日。BukkitのリードとBergensten氏の発言は大意。

[9]: https://www.pcgamer.com/minecraft-bukkit-team-lead-tries-to-end-development-but-mojang-steps-in/

<a id="ref-10"></a>10. [GitHub「2014-09-05-CraftBukkit.md」][10] — GitHub DMCAリポジトリ、2014年9月5日。CraftBukkitなどを対象とする削除通知の公開記録。

[10]: https://github.com/github/dmca/blob/master/2014/2014-09-05-CraftBukkit.md

<a id="ref-11"></a>11. [Marsh Davies「Servers coming to consoles and mobile!」][11] — Minecraft.net、2017年6月16日。提携先とゲーム内のサーバー一覧、Realmsとの違いを説明している。

[11]: https://www.minecraft.net/en-us/article/servers-coming-consoles-and-mobile

<a id="ref-12"></a>12. [Nathan Adams「Minecraft Snapshot 17w43b」][12] — Minecraft.net、2017年10月25日。URLの末尾は17w43a。記事はJava版1.13最初の開発版でのデータパック導入と、17w43bでの修正をあわせて掲載している。

[12]: https://www.minecraft.net/en-us/article/minecraft-snapshot-17w43a

<a id="ref-13"></a>13. [Minecraftスタッフ「Removing obfuscation in Java Edition」][13] — Minecraft.net、2025年10月29日。2019年の対応表の公開、撤廃の手順、EULAと利用ガイドラインの適用を参照。

[13]: https://www.minecraft.net/en-us/article/removing-obfuscation-in-java-edition

<a id="ref-14"></a>14. [Minecraftスタッフ「Minecraft and NFTs」][14] — Minecraft.net、2022年7月20日。「Our Policy on Minecraft and NFTs」を参照。本文中の説明は大意。

[14]: https://www.minecraft.net/en-us/article/minecraft-and-nfts

<a id="ref-15"></a>15. [Mojang「Minecraft Usage Guidelines」][15] — Minecraft.net、2026年11月17日参照。「Servers and hosting」「Mods」を参照。

[15]: https://www.minecraft.net/en-us/usage-guidelines

<a id="ref-16"></a>16. [Mikael Hedberg「Minecraft Java Edition 1.19.1」][16] — Minecraft.net、2022年7月27日。「Player Reporting」「Suspensions & Bans」を参照。

[16]: https://www.minecraft.net/en-us/article/minecraft-java-edition-1-19-1

<a id="ref-17"></a>17. [Minecraftスタッフ「Addressing Player Reporting Tool」][17] — Minecraft.net、2022年6月30日。導入前に公開された公式の質疑応答。

[17]: https://www.minecraft.net/en-us/article/addressing-player-chat-reporting-tool

<a id="ref-18"></a>18. [GamesRadar+「Minecraft’s new chat reporting system is here to stay, says Mojang community manager」][18] — GamesRadar+、2022年7月。サーバー運営者の懸念とMojangのコミュニティ担当者の説明を紹介。本文は大意。

[18]: https://www.gamesradar.com/minecrafts-controversial-new-chat-reporting-system-is-here-to-stay-says-mojang/

<a id="ref-19"></a>19. [Joshua Wolens「Minecraft players are in an uproar over its new reporting system, but Mojang won't back down」][19] — PC Gamer、2022年7月28日。

[19]: https://www.pcgamer.com/minecraft-players-are-in-an-uproar-over-its-new-reporting-system-but-mojang-wont-back-down/

<a id="ref-20"></a>20. [Minecraft Java Team「Minecraft Snapshot 25w45a」][20] — Minecraft.net、2025年11月4日。「Experimental release – unobfuscated version」を参照。

[20]: https://www.minecraft.net/en-us/article/minecraft-snapshot-25w45a

<a id="ref-21"></a>21. [Minecraft Java Team「Minecraft 26.1 Snapshot 1」][21] — Minecraft.net、2025年12月16日。

[21]: https://www.minecraft.net/en-us/article/minecraft-26-1-snapshot-1

----

この文書は、Perplexity、Claude、ChatGPT の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
