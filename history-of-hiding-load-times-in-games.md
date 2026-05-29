# ゲームにおける「ロード時間の隠蔽」技術史：黎明期から現代リマスターまで

## はじめに：なぜロード時間は生まれたのか

ゲームの歴史において、「ロード時間」という問題が大きくなったのはROMカートリッジからCD-ROMへの移行期だ。ROMカートリッジはランダムアクセスが高速なため、マップやデータをほぼ瞬時に読み込めた。しかしCD-ROMは大容量・低コストというメリットの代償として、データの読み取り速度が遅く、データを呼び出すたびに数秒から数十秒の待機が発生した。[^1]

プレイヤーにとって「何も起きない時間」は体験の断絶であり、没入感を著しく損なう。そこで開発者たちは「ゲームをいかに止めずにロードを終えるか」というデザイン上の課題に挑み始めた。本稿ではその主要な解法をケーススタディとして取り上げ、さらに近年のSSD高速化がその設計に何をもたらすかを論じる。

***

## ロード隠蔽の分類

ロード時間を隠す手法は、大きく以下の4つに分類できる。

| カテゴリ | 概要 | 代表例 |
|---|---|---|
| **演出型** | アニメーションやムービーでロードを包む | バイオハザード（扉）、メトロイドプライム（扉） |
| **地形型** | 狭い通路・エレベーターなど移動制限でロードを隠す | マスエフェクト、ゴッド・オブ・ウォー、Uncharted |
| **先読み型** | 次のデータを事前にバッファに載せる | ドラゴンクエストVII |
| **遊戯型** | ロード中にミニゲームを遊ばせる | リッジレーサー（ナムコ特許） |

***

## ケーススタディ

### Case 01：バイオハザード（1996年／PlayStation）——「扉の演出」という傑作

1996年、カプコンがPlayStation向けに発売した初代『バイオハザード』には、部屋を移動するたびに「扉がゆっくりと開くムービー」が流れる。このシーンは当初ホラー演出と思われていたが、実体はPS1のCD-ROMロード時間を隠すために考案された技術的なソリューションだ。[^2][^3][^4]

開発チームはロード待ちをプレイヤーに意識させないよう工夫を重ね、「扉が開くムービーを挿入する」アイデアで問題を解決した。この演出が天才的なのは、ロードの隠蔽と同時に「扉の先に何が待ち受けるかわからない」という緊張感を生み出し、ホラーゲームとしての雰囲気まで強化したことだ。技術的制約がゲーム体験を豊かにした好例として、いまでも語り継がれている。[^5][^6][^2]

続く『バイオハザード2』でも同様の扉演出が採用され、シリーズのアイコンとなった。[^7]

***

### Case 02：ドラゴンクエストVII（2000年／PlayStation）——「先読みローディング」特許

PS版『ドラゴンクエストVII エデンの戦士たち』（2000年）は、PSプラットフォーム向けドラクエの第1弾として、日本のPS用ソフト歴代出荷本数第1位を記録した大作だ。[^8]

PS版でのCD-ROM読み込みタイムラグを抑えるために採用されたのが**先読みローディング**と呼ばれる独自技術だ。具体的な手法は以下のとおり。[^9][^8]

- **バッファメモリへのキャッシュ**：CD-ROMのバッファメモリに頻用データをキャッシュする
- **マップの先読み**：画面切り替え時に「移動先の次のマップ群」を読み込む（移動先ではなく、その先を準備する）
- **データ分割読み込み**：モンスターの立ちポーズデータとアニメーションデータを別々に読み込み、初期表示を優先する

これらの技法は開発を担当したハートビートの山名学（DQVIIではディレクション／プログラムディレクションを担当）によって特許出願された。プレイヤーがマップを移動している間に次の場所を準備することで、画面切り替え時の体感的なロード時間を短縮している。**ただし**、この先読み処理の実行中に読み込みが中断されるとフリーズするというバグが多発し、後の再版（PSone版や廉価版のアルティメットヒッツ）で修正された。技術的野心がトラブルも引き起こした、教訓深いケースである。[^10][^8]

***

### Case 03：ナムコ「ロード中ミニゲーム」特許（1994年出願）——遊んでいる間に読み込む

1994年に旧ナムコ（現バンダイナムコエンターテインメント）が「ゲームプログラムおよびデータの読込み方法、ならびにこれを用いたゲーム装置」という特許を出願した。これはロード中に別の小さなミニゲームを先に読み込み、バックグラウンドでゲーム本編をロードするという手法だ。[^11][^12]

アーケードゲーム『リッジレーサー』のPS移植版（1994年）ではロード中にシューティングゲーム『ギャラクシアン』が遊べたのが実装例として知られる。ミニゲームの結果が隠し要素に影響するケースもあり、単なるロード隠しを超えてゲームの一部として機能した。[^12]

この特許の影響は業界全体に及び、同じ手法を使いたかった他社メーカーは実装を控えざるを得なかった。日本では2014年12月、米国では2015年11月にようやく特許が消滅し、itch.ioでは「Loading Screen Jam」と題したミニゲームの公募イベントが開催された。一社の特許が約20年間、業界全体の設計選択肢を狭め続けた歴史は、ゲーム法と設計の観点から示唆深い。[^13][^14][^15][^11]

***

### Case 04：マスエフェクト（2007年）——エレベーターの会話がロードを隠す

BioWareの『マスエフェクト』（2007年）では、銀河船「ノルマンディー」内で異なるエリアへ移動する際に**エレベーター**を利用する。エレベーターの乗降シーン中、仲間たちの世間話や時事ニュースの音声が流れ続ける。この演出がロード時間を隠しており、同乗するキャラクターたちのボイスが世界観への没入を途切れさせない巧みな設計だ。[^16][^17]

しかし続編『マスエフェクト2』（2010年）では、改良されたロード技術によってエレベーター演出は廃止され、素直なロード画面に変わった。逆説的に、エレベーター演出は前作の懐かしい記憶として愛されることになった。[^16]

***

### Case 05：ゴッド・オブ・ウォー（2018年）——「ワンカット」でロードを消した

Santa Monica Studioが2018年に発表した『God of War』は、「カメラカットが一切ない」というコンセプトのもと制作された。プロローグからエンディングまで、カットシーンとゲームプレイが画面暗転なしで連続して続く構造だ。[^18][^19][^20]

技術的には、狭い亀裂や穴を通り抜けるシーン、ボートで川を下るシーンなど、プレイヤーの視線を制限しながら移動させる瞬間にバックグラウンドロードを実行している。結果として「ロード時間が存在しない」体験を実現しつつ、演出として絵になる構図も作れている。PS4のHDD環境でもほぼシームレスに動作させたことは技術的偉業とみなされた。[^21][^22][^23]

この手法は後に多くの作品が採用。『Star Wars Jedi: Fallen Order』や『FF7リメイク』など、壁の亀裂を通り抜けるシーンが多い作品はほぼ同じ理由を持つ。プレイヤーからは「次のエリアへの演出」として自然に受け入れられているが、その実態は現代のロード隠蔽手法の主流だ。[^24]

***

### Case 06：メトロイドプライム（2002年）——ドアの「解析エフェクト」

任天堂とRetro Studiosによる『メトロイドプライム』（2002年）では、エリア間の扉は「ビームで撃って開ける」システムを採用した。扉が解析・解除されるエフェクト中に次エリアのロードが実行される。バイオハザードの扉演出と本質的に同じだが、アクションゲームの操作を止めることなく自然な流れとして組み込んだ点が異なる。[^25]

***

### Case 07：Uncharted シリーズ——カットシーンがロードする

Naughty Dogの『Uncharted』シリーズでは、ネイサン・ドレイクが崖を登る・瓦礫を乗り越えるといったスクリプトシーンが多用される。「ゲームに見せかけた演出」として、次のエリアの読み込みを完了させる巧みな設計だ。同社は『The Last of Us』シリーズでも同様の手法を一貫して採用している。[^26][^21]

***

### Case 08：Tony Hawk's American Wasteland（2005年）——フィーチャーレスなトンネル

『Tony Hawk's American Wasteland』（2005年）は「ロード画面のないスケートゲーム」を売りに、ロサンゼルスを自由に滑走できるオープン構造を打ち出した。だが実際にはエリア間の移動に長いトンネルが挟まれており、テクスチャの乏しい無機質なトンネルをスケーターが通り過ぎる間に次エリアをロードしている。開発者自身も、従来型のステージをこのローディング・トンネルでつなぎ、トンネル内でロードとアンロードを隠蔽し、滑走速度も落として時間を稼いだと証言している。「あからさまに何もない」通路であるため、ロード隠しとしては少々強引だったとも批評されている。[^27]

***

## コラム：リマスターとSSD時代のジレンマ

### ロード隠しが「演出そのもの」になるとき

近年のPS5やXbox Series Xは、カスタムSSDにより**PS4のHDDと比べて約100倍**の読み込み速度を実現した。PS4のHDDが50〜100MB/sだったのに対し、PS5のSSDは5.5GB/s。SIEの説明によれば、PS4では1GBの読み込みに20秒かかっていたのに対し、PS5では2GBのデータを0.27秒で読み込めるという。この速度差は、かつてのロード隠蔽設計が「必要のない演出」へと変化する問題を生んだ。[^28][^29][^30]

### 事例：マスエフェクト レジェンダリー・エディション（2021年）

2021年発売のリマスター版では、SSDの高速化によりエレベーターの乗降時間が大幅に短縮された。元々1分近かったエレベーター待ちは14秒ほどになり、任意でスキップもできるようになった。[^31][^32][^33]

**功罪両面**が同時に起きたのが興味深い。

- **功**：『マスエフェクト1』のエレベーターは純粋なロード隠しだったため、高速化によってテンポが劇的に改善。プレイヤーは快適に遊べるようになった。[^34]
- **罪**：『マスエフェクト2』には、宇宙の闇とコレクター／リーパーの脅威を想起させる象徴的な映像と不穏なスコアで「宇宙の孤独と脅威」を演出する**"良いロード画面"**が存在した。これはSSDにより数秒で切り上げられ、当時の雰囲気を初めて体験することはもはやできなくなった。[^35]

BioWareは「SSDによってロードが終了してもプレイヤーがスキップを選ぶまでは演出が続く」仕様を実装することで対応した。これはロード隠しの逆、**"ロード完了を演出でごまかす"**という逆転の発想だ。[^31]

### 事例：バイオハザード（バイオRE）シリーズのリマスター展開

原点回帰として、2002年にゲームキューブで発売されたリメイク版（REmake）をHD化した『バイオハザード HDリマスター』（2015年）では、扉の開閉演出は**そのまま残された**。意図的なデザインとして受け継がれ、今日ではシリーズのアイデンティティとなっている。一方で『バイオハザード RE:2』（2019年）以降はリアルタイムエンジンへの変更により扉演出自体が不要になり、技術的な隠蔽から完全な演出へと転化した。

### リマスター制作の設計指針

かつてのロード隠蔽演出を現代ハードでリマスターする際には、以下の選択肢がある。

| アプローチ | 内容 | 向いているケース |
|---|---|---|
| **演出保持** | ロードが終わっても演出を継続再生 | 雰囲気・没入感が核のホラーゲーム等 |
| **スキップオプション付き保持** | 演出を残しつつ任意スキップを追加 | 演出が評価されている作品 |
| **撤廃・シームレス化** | 演出を削除し直接シーン遷移 | アクション・テンポ優先作品 |
| **再設計** | 演出を現代の技術で作り直し | オープンワールド等、大幅リメイクの場合 |

重要なのは「ロード隠しが目的だった演出」と「意図的な演出として機能していたもの」を区別することだ。後者は速度を上げてしまうとゲームの核心を損ないかねない。

***

## 現代ゲームデザインへの示唆

SSDの普及によりロード隠しの必要性は著しく低下した。しかしこの「制約から生まれた発明」は、ゲームデザインに重要な教訓を残している。

**制約はイノベーションの母である。** バイオハザードの扉演出はロードを隠す苦肉の策だったが、それがシリーズのアイデンティティになった。ドラクエVIIの先読み技術は特許にまで発展した。技術的制約に向き合う中で生み出されたゲームデザインは、往々にして体験を豊かにする。

現代のゲームプランナーにとってのヒントは、**「ロードを隠す」のではなく「移行をデザインする」**という発想の転換だ。次のエリアへの通路が単なるデータ転送の待ち時間ではなく、世界観の導入・キャラクターの会話・雰囲気の切り替えとして機能するとき、それは最良のゲーム体験に貢献する。ゴッド・オブ・ウォーのワンカット哲学は、まさにその究極形である。[^19][^18]

技術が進化して制約が消えたとき、そのデザインが純粋に「意味があったか」が問われる。制約に依存した演出は不要になり消えていくが、体験を高める演出は時代を超えて生き残る。

---

## References

1. [Loading screen](https://en.wikipedia.org/wiki/Loading_screen) - In early video games, the loading screen was also a chance for graphic artists to be creative withou...

2. [【バイオハザード】扉の開閉演出に秘められた真実！技術的 ...](https://sin-koutrocom.jp/biohazard-door-opening-origin/) - 開発チームはこのロード時間をプレイヤーに意識させないよう頭を悩ませ、「 扉が開くムービー 」を挿入することでロード待ちを隠すアイデアを生み出した。

3. [🎮今日のゲーム豆知識🎮 「ゲームの『ロード時間 ...](https://x.com/sengawa_daichu/status/2035552052265517167) - 今日のゲーム豆知識   「ゲームの『ロード時間』、実は演出で隠されていた？」   先ほど記念日を紹介した『バイオハザード』。 あの「扉が開く演出」は、 ...

4. [バイオハザードのドア演出はロード時間隠しだった #Shorts](https://www.youtube.com/shorts/8SfbYUh_8-I) - 1996年バイオハザードの名物「ゆっくり開くドア」。本当はホラー演出ではなく、PS1のCD-ROMロード時間を隠すための仕組みだった。

5. [告白：最近になって、初代バイオハザードのドアの演出って ...](https://www.reddit.com/r/residentevil/comments/qswtgd/confession_i_only_recently_learned_that_the_door/) - 告白：最近になって、初代バイオハザードのドアの演出って、実はローディング画面を隠すためだったって知ったんだよね。完全に雰囲気のためだと思って ...

6. [旧式バイオハザードのドア開ける時と階段上がったり下がっ ...](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1469200229) - 旧式バイオハザードのドア開ける時と階段上がったり下がったりする時の演出って ロード時間稼ぎですか? そうですよ。ロード時間を、ドアや階段の演出 ...

7. [【実は〇〇でした】バイオハザード２ ドアムービー秘話 ...](https://www.youtube.com/shorts/vA8h7AehWD4) - クリア後の特典で欲しかったですね▽チャンネル登録よろしくお願いします！ https://onl.tw/UzLsj8Z ▽音声 VOICEVOX:四国めたん、ずんだもん#shorts ...

8. [ドラゴンクエストVII エデンの戦士たち](https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%A9%E3%82%B4%E3%83%B3%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88VII_%E3%82%A8%E3%83%87%E3%83%B3%E3%81%AE%E6%88%A6%E5%A3%AB%E3%81%9F%E3%81%A1) - 過去から現在へ戻る時は、フィールドマップ上の「旅の扉」を用いる。また ... PS版でのゲームの途中のCD-ROM読み込みによるタイムラグは、特殊な技法を使うこと ...

9. [PS版のドラクエ7は何でフリーズするのですか？](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q13176194648) - ドラクエ7のソフトは「先読みローディング」というプログラムが入っていますマップに入ったときの、暗転→マップが見えて動けるようになるなどの時間 ...

10. [ドラゴンクエスト7の通常版とバグ修正版を比較してみた！【PS1 ...](https://www.hiki-live.com/2022/09/dq7-ps1.html) - なぜフリーズバグは起きたのか？ ロード時間短縮による弊害. PS版でのゲームの途中のCD-ROM読み込みによるタイムラグは、特殊な技法を ...

11. [ナムコの「ロード画面中にミニゲームが遊べる特許」が国内外で ...](https://automaton-media.com/articles/newsjp/loading-screen-mini-games-patent-will-be-expired-at-united-states/) - ナムコの「ロード画面中にミニゲームが遊べる特許」が国内外で権利消滅の見通し、海外では「ロード画面ゲームジャム」が開催される。日本では1994年12月2日、米国では1995年11月27日に出願。

12. [ロード待ち時間に挿入されるミニゲームとは？ わかりやすく解説](https://www.weblio.jp/content/%E3%83%AD%E3%83%BC%E3%83%89%E5%BE%85%E3%81%A1%E6%99%82%E9%96%93%E3%81%AB%E6%8C%BF%E5%85%A5%E3%81%95%E3%82%8C%E3%82%8B%E3%83%9F%E3%83%8B%E3%82%B2%E3%83%BC%E3%83%A0) - ミニゲームの成績によって隠し要素が使えるようになるなどの特典もある。ナムコ（後のバンダイナムコエンターテインメント）がこの手法で特許を取得しており、家庭用 ...

13. [「ロード時間のイライラ」解消に大きな進展？ ナムコが持っ ...](https://nlab.itmedia.co.jp/cont/articles/3249678/) - 旧ナムコ（現在はバンダイナムコゲームス）が持っていた、「ゲームのロード時間中にミニゲームで遊べる特許」が今年で消滅することが分かり、話題になっ ...

14. [海外ではロード画面でプレイできるミニゲームを集めた ...](https://gigazine.net/news/20151204-loading-screen-jam/) - 旧ナムコが保有していた特許がアメリカでは2015年11月27日（日本では2014年12月）に切れた。これを受け「Loading Screen Jam」が開催。

15. [PS1のパワプロのロード中のトスバッティングミニゲームやったら ...](https://x.com/unamuhiduki/status/1837116921252302975) - ... ロード中のトスバッティングミニゲームやったら当時パテントトロール的なムーブしてたコナミをリッジレーサーの「ロード中ミニゲーム」特許持ってたナムコ ...

16. [Official Debate. Elevators vs Loading Screens : r/masseffect](https://www.reddit.com/r/masseffect/comments/mxflp/official_debate_elevators_vs_loading_screens/) - In Mass Effect, elevators were used as loading screens in between locations. In Mass Effect 2, good ...

17. [Elevators vs. Loading Screens - Mass Effect Wiki - Fandom](https://masseffect.fandom.com/wiki/User_blog:Effectofthemassvariety/Elevators_vs._Loading_Screens) - A video game that is designed to have a cinematic feel shouldn't have loading screens! Personally, I...

18. [God of War 4 - No Load Screens?!](https://www.youtube.com/watch?v=eULJK9s0LzI) - Yeah, I really messed up the "boop" thing lol Link to Video: https://www.youtube.com/watch?v=l_RpwPc...

19. [God of War Doesn't Feature Any Loading Screens](https://www.playstationlifestyle.net/2018/03/21/god-of-war-gameplay-is-seamless-no-loading-screens-at-all/) - They just put out a new video with the game's Director of Cinematography Dori Arazi, and he reveals ...

20. [TIL God of War (2018) was done in a single shot with no ...](https://www.reddit.com/r/todayilearned/comments/cwkwa9/til_god_of_war_2018_was_done_in_a_single_shot/) - TIL God of War (2018) was done in a single shot with no loading screens or fade-to-black between gam...

21. [The Art of Gaming Trickery: Hidden Loading Screens](https://vividgold.co.ke/blogs/digital-diary/the-art-of-gaming-trickery-hidden-loading-screens) - Let's uncover the genius behind these hidden loading screens that trick us into thinking the action ...

22. [How God of War eliminated loading screens](https://www.linkedin.com/posts/anand-kumar-b24394224_gamedevelopment-godofwar-gamedesign-activity-7346520767947317249-Mfnn) - Basically, God of War was built with no loading screen philosophy. The entire game plays in one cont...

23. [How did God of War achieve no loading screens and could ...](https://www.reddit.com/r/PS4/comments/8g6czb/how_did_god_of_war_achieve_no_loading_screens_and/) - Smartly structured levels and interruptions that hide the streaming in of assets off screen. Every t...

24. [なぜ小さな隙間を通り抜けるのがゲームではこんなに重要なん ...](https://www.reddit.com/r/pcgaming/comments/1e2ajoc/why_is_squeezing_through_tiny_spaces_such_a_thing/) - いつ始まったのかはわからないけど、一番有名な例の一つは『Jedi: Fallen Order』で、常に壁の亀裂を通り抜けるんだよね ...

25. [15 Annoyingly Disguised Loading Screens That Tried Their ...](https://www.youtube.com/watch?v=lh2yGWwIRw4) - Loading screens are a part and parcel of every game these days ... disguise a loading screen as to b...

26. [One of my favorite things about Naughty Dog games](https://www.reddit.com/r/gaming/comments/1jdhfm/one_of_my_favorite_things_about_naughty_dog_games/) - Here's some info. "The game uses a display engine that makes the entire experience seamless, with no...

27. [The secret art of the video game loading screen, and why they won't be going away anytime soon](https://www.gamesradar.com/the-secret-art-of-the-video-game-loading-screen-and-why-they-wont-be-going-away-anytime-soon/) - 開発者の証言：『Tony Hawk's American Wasteland』は従来型のステージを「ローディング・トンネル」でつなぎ、トンネル内でロード／アンロードを隠蔽し、スケーターの速度も落として時間を稼いだ。

28. [PS5には超高速なSSDを搭載！ ロード時間が1GB20秒から ...](https://game.watch.impress.co.jp/docs/news/1241849.html) - PS5に搭載されるSSDは、従来のSSDやHDDと比べて超高速になるとのこと。帯域幅はPS4のHDDが50〜100MB/sのところ、PS5のSSDは5.5GB/s。

29. [「PlayStation 5」のスペック一部公開。「PS4」と比べて性能は ...](https://kakakumag.com/game/?id=15200) - PS5は超高速SSD採用によりロード時間がほぼなくなる。これにより、ゲームデザインの自由度が飛躍的に向上するとのこと。

30. [PS5技術解説動画（The Road to PS5）でゲーム機外観は公開 ...](https://varis.jp/ps5-technical-explanation/) - PS5のシステム設計詳細が公開。次世代機PS5における超高速カスタムSSDや後方互換性、3Dオーディオへのこだわりが紹介された。

31. [Mass Effect Legendary Edition Changes Iconic Elevator ...](https://gameinformer.com/2021/02/03/mass-effect-legendary-edition-changes-iconic-elevator-sequences) - The elevator loading screens in the first game have become a meme in itself, so what did BioWare do ...

32. [Remastered 'Mass Effect' does something about those ...](https://mashable.com/article/mass-effect-remaster-legendary-edition-release-date-details) - "The elevator times are now faster across all platforms," BioWare producer Crystal McCord said durin...

33. [Mass Effect Legendary Edition includes the option to skip ...](https://www.gamesradar.com/mass-effect-legendary-edition-includes-the-option-to-skip-the-elevator-loading-screens/) - Mass Effect Legendary Edition will give you the option to skip its notoriously long elevator loading...

34. [Holy crap do the the faster load times make a huge ...](https://www.reddit.com/r/masseffect/comments/ns5kmn/holy_crap_do_the_the_faster_load_times_make_a/) - The elevator on the Normandy was so damn slow. Playing the legendary edition on PS4 has me finishing...

35. ['Mass Effect' remaster exposes an unexpected shortcoming ...](https://www.inverse.com/gaming/mass-effect-legendary-edition-loading-screens) - Both new video game consoles boast impressive solid-state drives that load more data faster than eve...
