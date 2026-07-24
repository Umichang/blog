---
description: "「ローグライク（Roguelike）」は1980年のゲーム『Rogue』に始まるジャンル名であり、長らくコミュニティ内で独自の定義が積み重ねられてきた。"
---

# 結局ローグライクってなんなのさ？

## エグゼクティブサマリー

「ローグライク（Roguelike）」は1980年のゲーム『Rogue』に始まるジャンル名であり、長らくコミュニティ内で独自の定義が積み重ねられてきた。2008年に「ベルリン解釈」として定義が体系化されたが、2010年代以降のインディーゲームブームにより「ローグライク」という言葉が拡大解釈され、本来の定義から大きく外れたゲームにも広く適用されるようになった。これに対して「ローグライト（Roguelite）」という語が登場し、「古典的ローグライク」と「ローグライクから派生した現代的ゲーム」を区別しようとする動きが起きた。しかし現在でも両語は混同されることが多く、ユーザーの直感を惑わせる状況が続いている。

---- 

## 1. 起源：『Rogue』（1980年）

ローグライクという概念のすべての起点は、1980年頃にマイケル・トイとグレン・ウィックマン（後にケン・アーノルドが加わる）がUNIXシステム向けに開発した『Rogue: Exploring the Dungeons of Doom』である。カリフォルニア大学サンタクルーズ校の学生だったトイとウィックマンは、当時人気のテキストアドベンチャー『Colossal Cave Adventure』（1976年）やテーブルトップRPG『ダンジョンズ＆ドラゴンズ』に触発されつつ、毎回異なる体験を生み出す「手続き的生成（procedural generation）」の仕組みを盛り込んだゲームを作り上げた。[[1](#ref-1)][[2](#ref-2)]

ゲームの目標は、ランダムに生成されるダンジョンの最深部に潜り「イェンドールのアミュレット」を取得して帰還することであり、死亡した場合はすべてをリセットして最初からやり直す「パーマデス（恒久的な死）」が採用されていた。『Rogue』がBSD Unixのディストリビューションにバンドルされることで世界中の大学に広まり、同様のゲームを作ろうとする開発者が多数現れ、このジャンルの原型が形成された。なお、ランダム生成ダンジョンなど類似の要素を持つ作品として1978年の『Beneath Apple Manor』が『Rogue』に先行しているが、ジャンル名は広く普及した『Rogue』に由来している。[[3](#ref-3)][[4](#ref-4)][[2](#ref-2)]

---- 

## 2. 「ローグライク」という言葉の誕生（1980年代〜1993年）

「ローグライク」という用語が広く定着したのは、ゲームの誕生から10年以上経った1993年頃のことである。それ以前にも同種の表現は散発的に見られたが、この年にUsenet上で行われた議論を通じて用語として確立された。Usenet（初期のインターネット掲示板）の`rec.games.roguelike`グループ階層の設立に向けた議論の中で、「一人用の、ダンジョンを舞台とするファンタジーRPG」を総称するために用語が選ばれたのが起源とされている。この時代の代表的なゲームとして参照されたのは『Rogue』のほか、『Hack』（後の『NetHack』）、『Moria』、『Angband』などである。[[5](#ref-5)][[2](#ref-2)]

1998年にはこれらのゲームの「開発」について議論する派生グループ（`rec.games.roguelike.development`）が作られ、その時点ではすでに「ローグライク」という言葉はコミュニティ内で確立された用語となっていた。同時期の「Doomクローン」（後の「FPS」）という言葉の変遷と並行する現象と言える。[[2](#ref-2)]

### 日本における展開：「不思議のダンジョン」

日本では1993年にチュンソフト（現・スパイク・チュンソフト）が『トルネコの大冒険 不思議のダンジョン』を発売し、ローグライクのゲームプレイを国内に広めた。続いて1995年12月に発売された『不思議のダンジョン2 風来のシレン』は、『NetHack』などの海外ローグライクから多くの要素を吸収しつつ独自の進化を遂げ、日本のローグライクゲームのデファクトスタンダードとなった。『トルネコの大冒険』の操作体系は後の国産ローグライクゲームにも大きく引き継がれている。[[6](#ref-6)][[7](#ref-7)]

---- 

## 3. ベルリン解釈（2008年）：定義の体系化

2008年9月、ドイツのベルリンで「International Roguelike Development Conference 2008（IRDC2008）」が開催された。ここでローグライク開発者たちが議論を重ね、ジャンルの定義を体系化した「ベルリン解釈（Berlin Interpretation）」が生まれた。[[8](#ref-8)][[9](#ref-9)][[10](#ref-10)]

### 規範的ゲーム（カノン）

ベルリン解釈は特定のゲームを「規範（canon）」として設定し、それらと比較することで「どれだけローグライクか」を判断する指標とした。[[10](#ref-10)]

> **規範5作品：ADOM、Angband、Linley's Dungeon Crawl（現在のDungeon Crawl Stone Soupの前身）、NetHack、Rogue**

### 価値の高い要素（High Value Factors）

ローグライクを定義する上で特に重要とされる9つの要素は以下の通りである：[[11](#ref-11)][[10](#ref-10)]

| 要素                | 内容                                  |
| ----------------- | ----------------------------------- |
| **ランダムな環境生成**     | マップ・アイテム配置・モンスター配置が毎回ランダムに生成される     |
| **パーマデス**         | 死亡すると最初からやり直し。セーブはできても、ロード時に削除される   |
| **ターン制**          | 1コマンドが1アクション。時間を気にせず行動を選択できる        |
| **グリッド制**         | 世界がタイルの格子で表現され、キャラクターは1タイルを占有       |
| **非モーダル（ノンモーダル）** | 移動・戦闘・その他の行動が同じモードで行われ、いつでも任意の行動が可能 |
| **複雑性**           | 多様な問題解決手段が存在し、アイテム同士・敵との相互作用が豊富     |
| **リソース管理**        | 食料・回復薬などの限られたリソースを管理する必要がある         |
| **ハック＆スラッシュ**     | 多くのモンスターを倒すことがゲームの重要な要素             |
| **探索と発見**         | ダンジョンを注意深く探索し、未識別アイテムの用途を発見していく     |

### 価値の低い要素（Low Value Factors）

以下の6要素は古典的ローグライクに見られるが、欠いていてもジャンルから外れるとまでは言えないとされた：[[10](#ref-10)]

- 単一プレイヤーキャラクター
- モンスターがプレイヤーと同じルールに従う
- 戦術的挑戦
- ASCII表示
- ダンジョン構造（部屋と通路）
- 数値の可視化（HP・ステータス等）

### ベルリン解釈の重要な前提

ベルリン解釈は「開発者やゲームを制限するためのものではない」と明記されており、「これらの要素を欠いていてもローグライクではないとは言えない、また持っていてもローグライクとは限らない」と述べている。あくまでコミュニティがジャンルを理解するためのガイドラインであり、境界を引く検定試験ではない。[[12](#ref-12)][[10](#ref-10)]

---- 

## 4. 「ローグライト」の誕生と普及（2010年代〜）

### インディーゲームによるジャンル拡大

2010年代に入り、ベルリン解釈のローグライクとは異なるゲームデザインを持ちながらも「ランダム生成」と「パーマデス」を採用したゲームが次々に登場した。ターンベース・グリッド制を採用せず、アクションや他のジャンルと組み合わせた作品がその代表である。

- **Spelunky**（2008年/Derek Yu作）：横スクロールアクション＋手続き的生成ダンジョンの先駆け[[11](#ref-11)]
- **The Binding of Isaac**（2011年/Edmund McMillen・Florian Himsl作）：ゼルダ風トップダウンシューター＋ローグライク要素。2014年までに300万本以上を売り上げ、ジャンルへの関心を大幅に再燃させた[[13](#ref-13)]
- **FTL: Faster Than Light**（2012年/Subset Games作）：宇宙船管理シミュレーション＋ランダムイベント[[11](#ref-11)]

### 「ローグライト」という言葉の誕生

「ローグライト（Rogue-lite）」という用語を初めて用いたのは、2013年発売の**『Rogue Legacy』**の開発元Cellar Door Games（トロント拠点、Kenny LeeとTeddy Leeの兄弟による2人組スタジオ）であるとされている。彼らは、自分たちのゲームが「ローグライク」に類似しているが、より親しみやすい（アクセシブルな）設計になっていることを示すために、「lite（軽い）」という語を組み合わせた。[[14](#ref-14)][[11](#ref-11)]

この命名の背景には、プレイヤーが死亡しても一部の成長や獲得要素が次のランに引き継がれる「メタプログレッション（恒久的な進行）」の採用があった。これは古典的ローグライクには存在しなかった概念である。[[11](#ref-11)]

---- 

## 5. ローグライクとローグライトの比較

以下の表で、両概念の主要な違いを整理する。

| 特徴             | ローグライク（古典的）                  | ローグライト（現代的）                                  |
| -------------- | ---------------------------- | -------------------------------------------- |
| **ランダム生成**     | ◎ 必須（高価値要素）                  | ◎ 必須                                         |
| **パーマデス**      | ◎ 完全なリセット                    | △ 一部の要素は引き継ぎ可                                |
| **メタプログレッション** | ✕ なし                         | ◎ 多くの場合あり（解放要素、恒久強化など）                       |
| **ターン制**       | ◎ 必須（高価値要素）                  | ✕ 不問（アクション型が多い）                              |
| **グリッド制**      | ◎ 必須（高価値要素）                  | ✕ 不問                                         |
| **難易度**        | 高め（コアゲーマー向け）                 | 比較的低め（一般向け）                                  |
| **代表作**        | NetHack、Angband、風来のシレン、Elona | Hades、Dead Cells、Slay the Spire、Rogue Legacy |

最も本質的な違いは**「死亡時に何が失われ、何が残るか」**にある。古典的ローグライクではゲーム内のすべてがリセットされ、プレイヤー自身の「知識と判断力」だけが強化されていく。一方ローグライトでは、ゲーム内のキャラクターや解放要素も蓄積されていくため、繰り返しプレイが「ゼロからの再挑戦」ではなく「成長を重ねた前進」として機能する。[[15](#ref-15)][[16](#ref-16)]

---- 

## 6. 言葉の混乱とマーケティング問題

### なぜ混乱が起きるのか

2010年代以降、ゲーム市場において「ローグライク」という言葉がSteamやApp Storeなどのプラットフォームでマーケティング用語として機能し始めた。「ローグライク」とタグ付けすることで注目を集めやすくなるため、ベルリン解釈から大きく外れたゲームにも安易に使われるようになった。[[17](#ref-17)][[18](#ref-18)]

その結果、「ローグライク」は現在のゲームコミュニティでは「パーマデスと手続き的コンテンツを組み合わせたゲーム」という曖昧な意味で広く使われており、純粋なローグライクを求めるユーザーが「ローグライク」タグで検索しても、ターン制でもグリッド制でもない別ジャンルのゲームが大量にヒットする状況が生まれている。[[10](#ref-10)]

### ゲームジャンルとしての混乱の実態

現在「ローグライク」と呼ばれる人気タイトルの多くは、ベルリン解釈には当てはまらない。例えば：[[8](#ref-8)]

- **Hades**（アクションRPG）：アクション制、グリッドなし、メタプログレッション大量導入 → ローグライト
- **Slay the Spire**（デッキ構築）：ターン制ではあるがグリッドなし、メタプログレッションあり → ローグライト
- **Dead Cells**（アクションプラットフォーマー）：アクション制、2Dスクロール、メタプログレッションあり → ローグライト
- **風来のシレン**シリーズ：ターン制、グリッド制、完全パーマデス（一部作品に例外あり）→ 古典的ローグライク

これは「三国志ものの映画に馬が出てくるから、馬が出る映画はすべて歴史映画だ」と言うのに等しい論理の飛躍である。[[11](#ref-11)]

### コミュニティの反応

長年にわたりゲーム批評家たちはこの問題を指摘してきた。故TotalBiscuit（人気ゲーム評論家）はローグライクとローグライトの違いについて長時間の動画で解説を試みたが、誤用の拡大は止まらなかった。「ローグライクという言葉はすべての意味を失ってしまったのか」という議論はRedditなどで繰り返し行われており、マーケティングがジャンル名を形骸化させた典型例として論じられている。[[19](#ref-19)][[11](#ref-11)]

---- 

## 7. 現在の状況と実用的な整理

コミュニティとゲーム研究の双方で、現在では以下のような整理が有力である。[[20](#ref-20)][[8](#ref-8)]

1. **「古典的ローグライク（Classic Roguelike）」**：ベルリン解釈に忠実な作品群。ターン制、グリッド制、完全パーマデス、ランダム生成。NetHack・Angband・風来のシレン・Elonaなど。

2. **「ローグライト（Roguelite）」**：パーマデス（もしくはその変形）とランダム生成を採用しつつ、メタプログレッションや別ジャンルのゲームメカニクスを組み込んだ現代的作品群。Hades・Dead Cells・Slay the Spireなど。

3. **「（広義の）ローグライク」**：一般的なゲーム市場での用法。上記両方、さらにはランダム要素がある程度存在するゲームを含む曖昧なカテゴリ。

結局のところ「ローグライト」という語自体も定義が揺れており、ゲームを厳密に区分する共通言語として機能しきれていないのが現状である。プレイヤーが「自分が求めているゲームタイプ」を正確に伝えるには、「ターン制か」「メタプログレッションがあるか」「完全パーマデスか」といった具体的なメカニクスで説明するほうが、ジャンル名に頼るより確実と言える。[[21](#ref-21)][[22](#ref-22)]

---

## References

<a id="ref-1"></a>1. [Rogue (video game) - Wikipedia][1] - Rogue is a dungeon crawling video game by Michael Toy and Glenn Wichman with later contributions by ...

<a id="ref-2"></a>2. [Roguelike - Wikipedia][2] - Roguelike (or rogue-like) is a style of role-playing game traditionally characterized by a dungeon c...

<a id="ref-3"></a>3. [Roguelike Vs Roguelite: What's the Difference? - GameRant][3] - So, at its core, it would seem the two genres can be summed up like this: "All Roguelites are Roguel...

<a id="ref-4"></a>4. [rogue 1980 - Procedural Generation - Isaac Karth][4] - Michael Toy, Glenn Wichman, and Ken Arnold originally developed Rogue on university computers runnin...

<a id="ref-5"></a>5. [A short history of the Roguelike term][5] - by Slash, priest of the Temple of the Roguelike, January 2018 The "roguelike" term started being use...

<a id="ref-6"></a>6. [『風来のシレン』シリーズに見る日本におけるローグライクの進化 ...][6] - 『初代』シレン（SFC版）と『NetHack』の決定的な違いが、「一度行ったダンジョンの階層に後戻りできるか」です。『NetHack』は複数のダンジョンや拠点を ...

<a id="ref-7"></a>7. [「風来のシレン6」発売が待ち遠しい！ 日本にローグライクを ...][7] - チュンソフトのオリジナルキャラである風来人の"シレン"を主人公として，「不思議のダンジョン」をシリーズとして確立させた。 左が「トルネコ」，右が「 ...

<a id="ref-8"></a>8. [ローグライクとローグライトの定義・違いをわかりやすく徹底解説 ...][8] - 「ベルリン解釈」を尊重したとすると、現在「ローグライク」といわれている人気ゲームのほぼすべては解釈に当てはまりません。 ベルリン解釈における ...

<a id="ref-9"></a>9. [Roguelike Vs Roguelite: The Differences Explained - SVG][9] - The term "roguelike" first referred to any titles similar to "Rogue." As the sub-genre grew more pop...

<a id="ref-10"></a>10. [Berlin Interpretation - RogueBasin][10] - ==High value factors== ====Random environment generation==== The game world is randomly generated in...

<a id="ref-11"></a>11. [ARTICLE: A History of the words roguelike and rogue-lite (they do ...][11] - The developers of the game Rogue Legacy are the first ones to have coined the term rogue-lite. ... F...

<a id="ref-12"></a>12. [Genre, Prototype Theory and the Berlin Interpretation of Roguelikes][12] - The very inclusion of a list of "low value" factors can be thought of as a concession that games do ...

<a id="ref-13"></a>13. [The Binding of Isaac (video game) - Wikipedia][13] - The game's title and plot are inspired by the Biblical story of the Binding of Isaac. In the game, I...

<a id="ref-14"></a>14. [Total Biscuit - I will now talk about roguelite for about 50 minutes][14] - I felt like this was the biggest thing Rogue Legacy gave to me as a player. I only had to be "good e...

<a id="ref-15"></a>15. [ローグライクとローグライトの違いって何？｜みみんと - note][15] - 【まとめ】一目でわかる！ライクとライトの決定的な違い · ローグライク → 死んだら全部リセットプレイヤーの「頭脳（知識と経験）」だけが強くなる。

<a id="ref-16"></a>16. [「ローグライト」とは？特徴やローグライクとの違いをわかり ...][16] - ローグライクとローグライトの違いは多くの場所で語られており、パーマデスにその違いが見られるという意見は共通しています。しかし、度合いやそれ ...

<a id="ref-17"></a>17. [なぜローグライクとローグライトの違いについての混乱が ... - Reddit][17] - 問題は混乱がないことではなく、ゲームをマーケティングしている人々が区別や定義を全く気にしていないことです。彼らはローグライク = $%$$であることを ...

<a id="ref-18"></a>18. [Stupid marketing of non roguelike games][18] - It's extremely infuriating how marketing of games that are not roguelikes exploits the genre. Why do...

<a id="ref-19"></a>19. [「ローグライク」という言葉はすべての意味を失ってしまっ ... - Reddit][19] - インディーゲームは今や「ローグライク」という言葉を、永久死のあるゲームを指すのに使っています。ローグにほぼ一致していることが期待されるゲーム、 ...

<a id="ref-20"></a>20. [『ローグライク』とは何か？ 〜ベルリン解釈に基づくジャンル名の ...][20] - そこで今回、ローグライクを構成する要素を示した『ベルリン解釈』をもとに、これらローグライクというゲームジャンルの再定義を試みました。 Ⅱ．ベルリン ...

<a id="ref-21"></a>21. [【保存版】eスポーツ用語『ローグライク』『ローグライト』とは ...][21] - ローグライクは遊ぶたびに変化するステージが特徴で、毎回新しい冒険ができるのが魅力です！ ローグライクの由来. ローグライク(Rogue-like)の「ローグ( ...

<a id="ref-22"></a>22. [ローグライク?ローグライト?違いをご存じですか?][22] - しかし、実際問題としてこれまでのsteam行脚やゲームプレイなどで、ライトとライクの違いはそこまで遊んでいて気にならず、むしろこの線引きは溶け合い ...

[1]:	https://en.wikipedia.org/wiki/Rogue_(video_game)
[2]:	https://en.wikipedia.org/wiki/Roguelike
[3]:	https://gamerant.com/roguelike-vs-roguelite-whats-the-difference/
[4]:	https://procedural-generation.isaackarth.com/2015/03/09/rogue-1980.html
[5]:	https://blog.roguetemple.com/history/
[6]:	https://www.gamespark.jp/article/2024/11/10/146820.html
[7]:	https://www.4gamer.net/games/738/G073898/20231220058/
[8]:	https://minorgame.syowp.com/archives/roguelike-roguelite.html
[9]:	https://www.svg.com/865133/roguelike-vs-roguelite-the-differences-explained/
[10]:	https://www.roguebasin.com/index.php/Berlin_Interpretation
[11]:	https://saveorquit.com/2018/09/02/article-a-history-of-the-words-roguelike-and-rogue-lite-they-do-have-a-different-meaning/
[12]:	https://gamestudies.org/2403/articles/cartlidge
[13]:	https://en.wikipedia.org/wiki/The_Binding_of_Isaac_(video_game)
[14]:	https://www.reddit.com/r/roguelikes/comments/6gacqx/total_biscuit_i_will_now_talk_about_roguelite_for/
[15]:	https://note.com/miminnto_2219/n/n44a9bac939d9
[16]:	https://game-matching.jp/g-job-agent/news_articles/178
[17]:	https://www.reddit.com/r/truegaming/comments/cvtg6k/why_is_there_so_much_confusion_over_the/
[18]:	https://forums.roguetemple.com/index.php?topic=5703.0
[19]:	https://www.reddit.com/r/gaming/comments/4iaeds/has_the_term_roguelike_lost_all_meaning/
[20]:	http://blog.livedoor.jp/treckless/archives/23665024.html
[21]:	https://gamer2.jp/post/roguelike-roguelight/
[22]:	https://gamebakkari.com/2026/03/25/rouge/

----

この文書は、Perplexity、Claude、OpenAI Codex の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
