---
description: "NINTENDO64からPlayStation 3、Xbox 360まで、音を鳴らす担当が専用音源からプログラムへ移る流れと、PS2、ゲームキューブ、DS、PSPの異なる道を、処理時間とメモリ、聴き比べからたどる。「ゲーム機サウンドの歴史」第6回。"
category: sound-audio
difficulty: green
---

# 音源チップから、プログラムへ——ゲーム機サウンドの歴史⑥

[第4回「録った音を、小さく詰めて鳴らす」](console-game-sound-history-04-pcm-sampling.md)では、専用の音源が短い録音を楽器として鳴らす仕組みを見た。[第5回「録音を流すか、その場で鳴らすか」](console-game-sound-history-05-cd-era.md)では、その場で曲を演奏する方法に、CDに収めた曲を流す方法が加わった。

今回は、その音を鳴らす仕事の担当が変わっていく。専用の音源チップが担っていた演奏や音の加工を、さまざまな計算に使える演算装置の上で、プログラムが受け持つようになる。

移り変わりには、いくつかの道がある。NINTENDO64は専用音源チップを置かず、PlayStation 2は従来の専用音源を拡張した。ゲームキューブは音の処理に向いた演算装置とプログラムを組み合わせる。携帯機でも、ニンテンドーDSとPSPは異なる構成を選んだ。その先のPlayStation 3とXbox 360まで、 **音を誰が作り、どこへ送るのか** をたどってみよう。

***

## 第1章　NINTENDO64：演奏をプログラムへ任せる

### CPUが準備し、RSPが音を作る

NINTENDO64には、音を鳴らすための専用音源チップがない。代わりに、CPUと、グラフィックスの座標計算も受け持つ **RSP** という演算装置が仕事を分け合う。CPUはカートリッジのROMから音声データをRAMへ写し、音をどう処理するかという指示の一覧「Audio List」を作る。[[1](#ref-1)]

RSPは、 **マイクロコード** と呼ばれる、演算装置の動作を指示する小さなプログラムを使って、その一覧を実行する。圧縮した録音を展開して元の波形へ戻し、効果をかけ、演奏の指示に沿って音を鳴らし、混ぜ合わせる。複数の音を混ぜる処理が、第4回・第5回で見た **ミキシング** である。[[1](#ref-1)]

録音の圧縮には、前の値からの変化や予測を利用してデータ量を減らす **ADPCM** が使える。混ぜ終えた音は、出口にあたるAudio Interfaceから、数値の音を電気信号へ変えるDACへ送られる。出力は16bitのステレオである。[[1](#ref-1)]

### 音に使う時間と場所を分け合う

サンプリング周波数は最大44.1kHzだが、高い値を使うほどCPUの処理時間も多く必要になる。同時に鳴らせる音の数にも、音源チップのような固定の上限はない。Copettiが挙げる目安は、ADPCMなら16〜24チャンネル程度、圧縮していないPCMなら約100チャンネルで、RSPが混ぜられる量によって変わる。[[1](#ref-1)]

実際に鳴らせる数は、ゲームごとの処理の配分によって変わる。RSPはグラフィックスにも使う。カートリッジはCD-ROMより容量が小さく、音声データを置く主メモリも他の処理と共用する。 **音へ使える場所と時間を、ゲーム全体で分け合う** 構成なのである。[[1](#ref-1)]

『悪魔城ドラキュラ黙示録』のオープニング「血脈の印」では、旋律を受け持つ音の立ち上がりや、伸びる音の背後で重なる響きへ耳を向けたい。専用音源の有無と、実際に聞こえる音楽の豊かさを、ひとつの物差しにまとめずに聴いてみよう。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/vilURdeVKmg"
    title="悪魔城ドラキュラ黙示録（NINTENDO64）オープニング 血脈の印"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『悪魔城ドラキュラ黙示録』（NINTENDO64）オープニング「血脈の印」。配信元：Virgin Music Group（『ミュージックフロム 悪魔城ドラキュラ 黒』、℗ 2021 Konami Digital Entertainment）。<https://www.youtube.com/watch?v=vilURdeVKmg>*

***

## 第2章　PlayStation 2：専用の音源を広げる

PlayStation 2は、初代PlayStationの音源SPUを拡張した **SPU2** を搭載する。音声用メモリは2MB、チャンネル数は48である。内部にはCORE0とCORE1という2つの処理部があり、それぞれが24チャンネルを受け持つ。[[2](#ref-2)]

初代SPUと同じ効果を備え、メモリには録音と、効果をかけるための作業領域を置く。さらに、混ぜ終えたステレオの音を、新たな入力として自分へ戻すことができる。そこへリバーブなどをかけ、響きを加えられる仕組みである。リバーブは、音が鳴った後に残る残響を表す効果だった。[[2](#ref-2)]

出力には、DACを通すアナログ音声と、デジタル音声のS/PDIFがある。初代PlayStationのソフトを動かす際には、SPU2は初代のSPUとして振る舞う。[[2](#ref-2)]

NINTENDO64が、複数の仕事に使う演算装置で音を作った一方、PlayStation 2は、録音を鳴らす専用音源の枠を広げた。同じ時期にも、演算をプログラムへ任せる道と、専用音源を発展させる道が並んでいたのである。

***

## 第3章　ゲームキューブ：音の計算をするDSPと、用意されたプログラム

### 回路とプログラムを組み合わせる

ゲームキューブでは、Flipperというチップの中に、81MHzで動くマクロニクス製の **DSP** がある。DSPは、音などの信号処理に向いた演算装置である。決まった楽器だけを鳴らす音源とは異なり、プログラムによって処理を指示できる。[[3](#ref-3)]

音声データや指示を置くARAMは16MBある。容量は大きい一方、アクセスは遅く、CPUなどの用途にも使われる。DSPの内部にはADPCMを展開する回路もあり、プログラムの処理を助ける。処理した音は主メモリへ置かれ、最後の出口であるAudio Interfaceが32kHzでステレオの音を混ぜ、出力する。[[3](#ref-3)]

DSPを動かすマイクロコードとして、任天堂は **AX** という出来合いのプログラムを用意した。開発者は、音を鳴らすために各社で一からそのプログラムを書く代わりに、用意された仕組みを使える。開発キットには、Factor 5の音声制作・再生用ツール群MusyXも含まれた。[[3](#ref-3)]

ここでは、音を作る担当が「回路か、プログラムか」のどちらか一方になるわけではない。音に向いた演算装置、圧縮を展開する回路、そしてそれらを動かすプログラムが組み合わされている。

### その場で演奏する曲と、録音を流す曲

完成した音楽を、必要な分だけ順に読みながら流す **ストリーミング** も使える。第5回のCDの音楽と同じく、曲全体を最初にメモリへ収める代わりに、再生に合わせて読み続ける方法である。

Copettiは、NINTENDO64の『マリオストーリー』（英題：Paper Mario）と、ゲームキューブの『ペーパーマリオRPG』（英題：Paper Mario: The Thousand-Year Door）を比較している。前者の例ではRSPがその場で曲を演奏し、後者の例では録音をストリームとしてDSPへ送る。[[3](#ref-3)]

どちらも、プレイヤーには場面に合った曲として届く。その裏側では、楽器と演奏の指示から曲を組み立てるのか、完成した録音を読み続けるのかという違いがある。プログラムが音を処理するようになっても、この2つの方法は引き続き選択肢になる。

***

## 第4章　ニンテンドーDSとPSP：携帯機の二つの道

### DS：混ぜる仕事を専用の回路へ戻す

ニンテンドーDSは、PCMの録音を鳴らす16チャンネルを備える。扱える録音は8bit、16bit、ADPCMである。[第4回](console-game-sound-history-04-pcm-sampling.md)で見たゲームボーイアドバンスではCPUが音を混ぜていたが、DSでは、その仕事を専用の回路が受け持つ。[[4](#ref-4)]

16チャンネルのうち、最後の6つには、矩形波や独自の波形を鳴らすモードもある。そのうち2つはノイズを出せる。矩形波は、[第2回](console-game-sound-history-02-pulse-and-wavetable.md)で扱った、角張った形の波だった。録音の再生と、波形から音を作る方法が、同じチャンネルの別の使い方として残っている。[[4](#ref-4)]

混ぜた音は、10bit・32kHzのDACから出力される。元の録音が16bitであっても、最後の出力まで同じ精度が保たれるという意味ではない。また、数値の間を補って波形をなめらかにする **補間** は行わない。[[4](#ref-4)]

混ぜ終えた音を、作業用メモリのWRAMへ書き戻すこともできる。サブCPUのARM7が、その音へリバーブなどの効果をかけられるのである。ゲームボーイアドバンスのソフトを動かすときには、DS用とは別の、従来機に合わせた音の仕組みを使う。[[4](#ref-4)]

### 『ファイナルファンタジーIV』のメインテーマを聴く

ここで、第4回のスーパーファミコンへ戻ってみよう。『ファイナルファンタジーIV』のメインテーマについて、スーパーファミコン版とDS版を並べる。まずは、旋律を受け持つ音と、その後ろで重なる音の聞こえ方を耳に残しておきたい。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/ajP0SMURixM"
    title="ファイナルファンタジーIV メインテーマ（スーパーファミコン版）"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『ファイナルファンタジーIV』メインテーマ（スーパーファミコン版）。配信元：NexTone（『FINAL FANTASY IV Original Soundtrack』）。<https://www.youtube.com/watch?v=ajP0SMURixM>*

次はDS版である。こちらはリメイク作品で、編曲も新しくなっている。音色の輪郭や伴奏の重なり方に違いを感じても、それを音源の性能だけへ結びつけず、用意された録音や編曲も含めた違いとして耳を向けたい。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/JS-B5un94-c"
    title="ファイナルファンタジーIV メインテーマ（DS版）"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『ファイナルファンタジーIV』メインテーマ（DS版）。リメイクに伴い編曲も新しくなっている。配信元：NexTone（『(DS Version) FINAL FANTASY IV (Original Soundtrack)』、2008年）。<https://www.youtube.com/watch?v=JS-B5un94-c>*

### 「Bloody Tears」の続きを、DSで聴く

第2回ではディスクシステム版の「Bloody Tears」を、第5回ではPCエンジン版の「血の涙」を聴いた。今回は、DSの『悪魔城ドラキュラ 蒼月の十字架』の「BLOODY TEARS」である。同じ旋律を手がかりに、音の立ち上がりや、伴奏が加わる部分の響きへ耳を向けてみよう。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/qNVQ-uyYMLg"
    title="悪魔城ドラキュラ 蒼月の十字架（ニンテンドーDS）BLOODY TEARS"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『悪魔城ドラキュラ 蒼月の十字架』（ニンテンドーDS）「BLOODY TEARS」。配信元：Virgin Music Group（『ミュージックフロム 悪魔城ドラキュラ 赤』、℗ 2021 Konami Digital Entertainment）。<https://www.youtube.com/watch?v=qNVQ-uyYMLg>*

### PSP：小さな出口を、ソフト音源が支える

PSPの音の回路を、Copettiは「very bare-bones」と表現している。録音を流すPCMの2チャンネルとステレオのミキサーがあり、最大48kHz・16bitに対応する。ここでの2チャンネルは出口側の構成で、ゲーム中に同時に鳴らせる楽器や効果音の総数とは分けて考えたい。[[5](#ref-5)]

その手前で音を作るのが、信号処理に向いた演算装置 **Media Engine** の上で動く、ソニーのソフト音源である。こちらは32チャンネルを扱い、PCM、ADPCM、ATRAC3に対応する。ATRAC3は、録音を小さく保存するための **コーデック（圧縮形式）** のひとつである。[[5](#ref-5)]

ソフト音源はリバーブ、音程の制御、音の立ち上がりから消えるまでの音量変化を決めるADSRも提供する。開発キットのライブラリには、MP3やAACの展開や、MIDIのように演奏の指示から曲を組み立てる仕組みもある。ライブラリとは、開発者がゲームのプログラムから呼び出して使う、処理をまとめた部品である。[[5](#ref-5)]

Copettiの比較では、『ファイナルファンタジーIV』のDS版はその場で曲を演奏し、PSP版の『ファイナルファンタジーIV コンプリートコレクション』はATRAC3の録音を展開して流す。専用の音源回路が少ないことは、そのまま音質が悪いことを意味しない、というのがこの比較の要点である。[[5](#ref-5)]

### PSPで作り直された「血の涙」

『悪魔城ドラキュラ Xクロニクル』は、第5回で扱った『悪魔城ドラキュラX 血の輪廻』を作り直したPSPの作品である。コナミの紹介では、オリジナル版の収録に加え、作り直した版には原曲のイメージを重視した楽曲のアレンジが施されている。[[6](#ref-6)]

「血の涙 -Bloody Tears-」では、第5回の音を思い出しながら、旋律の音色やリズムの聞こえ方の違いへ耳を向けたい。DS版も含め、同じ曲の系譜をたどると、機種の仕組みと、作品ごとの音の用意の仕方を分けて考える手がかりになる。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/uGBdABXutNw"
    title="悪魔城ドラキュラ Xクロニクル（PSP）血の涙 -Bloody Tears-"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『悪魔城ドラキュラ Xクロニクル』（PSP）「血の涙 -Bloody Tears-」。配信元：Virgin Music Group（『ミュージックフロム 悪魔城ドラキュラ 黒』、℗ 2021 Konami Digital Entertainment）。<https://www.youtube.com/watch?v=uGBdABXutNw>*

***

## 第5章　PlayStation 3とXbox 360：音はプログラムの仕事になる

### PlayStation 3：CellのSPUで処理する

PlayStation 3には専用の音源チップがなく、Cellというプロセッサーの中にあるSPUが、ソフトウェアで音を処理する。ここでのSPUは **Synergistic Processor Unit** の略で、初代PlayStationの音源を指したSound Processing Unitとは別物である。[[7](#ref-7)]

ソニーは開発キットのライブラリを通じて、演奏の指示に沿って曲を組み立てる処理、ミキシング、ストリーミングなどを支えた。効果もプログラムで加えられる。作り終えた音は、出力を受け持つRSX側へ送られる。[[7](#ref-7)]

録音を鳴らす専用チャンネルへ指示を渡す構成から、演算装置へ音を作るプログラムを渡す構成へ、仕事の置き場所が移ったのである。

### Xbox 360：圧縮を展開する回路を残す

Xbox 360も、演奏やミキシング、効果をまとめて引き受ける専用音源チップを置かず、CPUがソフトウェアで音を処理する。一方、機器間の入出力をまとめるサウスブリッジの中には、 **XMA（Xbox Media Audio）** という圧縮形式を展開する専用回路がある。[[8](#ref-8)]

この回路は、最大5.1チャンネル、48kHz・16bitの音声を展開できる。主メモリから圧縮データを読み、PCMへ戻して、主メモリの指定された場所へ置く。その後、CPUが効果をかけ、DACへ送る。圧縮の展開を回路に任せることで、その分のCPUの時間を他の仕事へ回せる。[[8](#ref-8)]

この段階では、演奏や音を混ぜる処理の中心はプログラムとなり、音専用の回路に残る役割は、最後の出力や圧縮の展開といった部分へ絞られていく。

ミドルウェアの役割と、場面に応じて音楽を変化させる作り方については、[「インタラクティブ／アダプティブ・ミュージック」](interactive-adaptive-music-explained.md)を参照してほしい。

***

## 第6章　7機種で見る、音の担当とメモリ

ここまでの機種を並べてみよう。発売年は日本での年である。任天堂の3機種は会社の沿革、PlayStation 2とPSP、PlayStation 3はソニーの歴史資料、Xbox 360は発売を振り返るファミ通の記事による。[[9](#ref-9)][[10](#ref-10)][[11](#ref-11)][[12](#ref-12)]

| 機種（日本での発売年） | 音を鳴らす担当 | 専用の回路に残ったもの | チャンネル数の目安 | 音声用メモリ |
| --- | --- | --- | --- | --- |
| NINTENDO64（1996年） | CPUが準備し、RSPのプログラムが演奏・加工・ミキシング | Audio InterfaceとDACによる出力 | RSPが処理できる量で決まる。ADPCMで16〜24程度、PCMで約100 | 主メモリを他の処理と共用 |
| PlayStation 2（2000年） | 専用音源SPU2 | 録音の再生、ミキシング、効果、出力 | 48（24チャンネルのコア2つ） | 2MB。録音と効果の作業領域に使用 |
| ゲームキューブ（2001年） | DSP上のAXなどのプログラム | DSP内のADPCM展開回路、Audio Interfaceによる混合・出力 | — | ARAM 16MB。ほかの用途にも使用し、処理済みの音などは主メモリへ置く |
| ニンテンドーDS（2004年） | 16チャンネルの専用回路。ARM7で効果も処理できる | 録音の再生、波形・ノイズ生成、ミキシング、出力 | 16。一部は波形やノイズの生成に切り替え可能 | 録音や処理結果をRAMへ置く。WRAMへのミックス書き戻しに対応 |
| PSP（2004年） | Media Engine上のソフト音源 | 出口側のPCM 2チャンネルとステレオミキサー | ソフト音源は32 | — |
| PlayStation 3（2006年） | CellのSPU上のプログラム | RSX側の音声出力経路 | 処理できる量で決まる | — |
| Xbox 360（2005年） | CPU上のプログラム | XMA展開回路と音声出力 | 処理できる量で決まる | 主メモリに圧縮データと展開後のPCMを置く |

音の構成・数値の出典は各機種の本文を参照。ここでのチャンネル数は主に、音を個別に鳴らして混ぜるための数である。最後に左右へ送るステレオの2チャンネルや、Xbox 360のXMA回路が展開する最大5.1チャンネルとは、数えている場所が異なる。音声用メモリ欄も、専用領域の容量と、共用メモリの使い方を区別して記した。「—」は、本表で参照した出典に該当事項の記載がないものである。

専用音源のチャンネル数と、ソフトウェアが扱う音の数は、同じ条件の数字ではない。処理する録音の形式や、かける効果が変われば、必要な時間も変わる。表は機種の優劣よりも、 **音の仕事をどこへ割り振る設計だったか** を読むためのものである。

***

## まとめ　音へ、どれだけの時間と場所を配るか

音を鳴らす仕事は、専用音源からプログラムへ移っていった。その間には、専用音源を拡張したPlayStation 2や、DSPと用意されたプログラムを組み合わせたゲームキューブがある。携帯機でも、DSは専用の回路へミキシングを任せ、PSPはソフト音源で出口へ送る音を作った。

音の制約を考える軸も変わる。これまでの「音源が何を鳴らせるか」に加え、 **処理時間とメモリを、音へどれだけ配るか** が大きな条件となった。録音を展開する、演奏する、混ぜる、効果をかけるという仕事自体は続き、その担当と配分の仕方が変わったのである。

次回の第7回では、音の数や質に加えて、音がどこから聞こえるかという、空間の表現へ進む。

## References

<a id="ref-1"></a>1. [Rodrigo Copetti「Nintendo 64 Architecture」][1] — Architecture of Consoles。Audio節。CPU・RSP・Audio Interfaceの分担、出力、処理量とメモリの制約。

[1]: https://www.copetti.org/writings/consoles/nintendo-64/

<a id="ref-2"></a>2. [Rodrigo Copetti「PlayStation 2 Architecture」][2] — Architecture of Consoles。Audio節、Inherited compatibility節。SPU2、メモリ、効果、出力、初代PlayStation互換時の動作。

[2]: https://www.copetti.org/writings/consoles/playstation-2/

<a id="ref-3"></a>3. [Rodrigo Copetti「GameCube Architecture」][3] — Architecture of Consoles。Audio節、Making the most of ARAM節。DSP、AX、MusyX、メモリと出力、Paper Marioシリーズの再生方式の比較。

[3]: https://www.copetti.org/writings/consoles/gamecube/

<a id="ref-4"></a>4. [Rodrigo Copetti「Nintendo DS Architecture」][4] — Architecture of Consoles。Audio節。16チャンネル、録音形式、波形生成、DACの出力と補間、ARM7による効果、GBA互換用の音声系。

[4]: https://www.copetti.org/writings/consoles/nintendo-ds/

<a id="ref-5"></a>5. [Rodrigo Copetti「PlayStation Portable (PSP) Architecture」][5] — Architecture of Consoles。Audio節。出口の回路、Media Engineのソフト音源、ライブラリ、Final Fantasy IVのDS版・PSP版の比較。

[5]: https://www.copetti.org/writings/consoles/playstation-portable/

<a id="ref-6"></a>6. [コナミ「悪魔城ドラキュラ Xクロニクル」][6] — Castlevania ポータルサイト。対応機種、『血の輪廻』のリニューアルとオリジナル版収録、楽曲のアレンジ。

[6]: https://www.konami.com/games/castlevania/jp/ja/page/history_2007_psp

<a id="ref-7"></a>7. [Rodrigo Copetti「PlayStation 3 Architecture」][7] — Architecture of Consoles。Audio節。CellのSPUによるソフトウェア処理、SDKのライブラリ、RSXへの出力。

[7]: https://www.copetti.org/writings/consoles/playstation-3/

<a id="ref-8"></a>8. [Rodrigo Copetti「Xbox 360 Architecture」][8] — Architecture of Consoles。Audio節。CPUによる処理、XMA展開回路、その仕様と主メモリを通る経路。

[8]: https://www.copetti.org/writings/consoles/xbox-360/

<a id="ref-9"></a>9. [任天堂「会社の沿革」][9] — 任天堂。NINTENDO64（1996年）、ゲームキューブ（2001年）、ニンテンドーDS（2004年）の発売年。

[9]: https://www.nintendo.co.jp/corporate/history/index.html

<a id="ref-10"></a>10. [ソニー・インタラクティブエンタテインメント「2000年 PlayStation 2 - PSP」][10] — PlayStation 歴史年表。PlayStation 2、PSPの日本での発売年。PSPの2004年12月の日本発売は、同社の[「詳細年表・PlayStationの歩み」](https://sonyinteractive.com/jp/our-company/expanded-company-timeline/)も参照。

[10]: https://www.playstation.com/ja-jp/playstation-history/2000-ps2-psp/

<a id="ref-11"></a>11. [ソニー・インタラクティブエンタテインメント「2007年 PlayStation 3 - PlayStation Vita」][11] — PlayStation歴史年表。日本でのPlayStation 3発売日は2006年11月11日。

[11]: https://www.playstation.com/ja-jp/playstation-history/2007-ps3-ps-vita/

<a id="ref-12"></a>12. [ファミ通「Xbox 360が日本で発売された日。世界初のハイデフゲーム機として次世代機の先陣を切って登場。『アイドルマスター』や『デッド オア アライブ』シリーズも人気【今日は何の日？】」][12] — ファミ通.com、2020年12月10日。日本での発売は2005年12月10日。

[12]: https://www.famitsu.com/news/202012/10210856.html

英語資料の説明は本稿で日本語に要約した。

----

この文書は、Perplexity、Claude、ChatGPT の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
