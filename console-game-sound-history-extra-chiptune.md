---
description: "ファミコンやゲームボーイの音で曲を作る道具を紹介し、『原神』の聴き比べと『ショベルナイト』を通じて、かつての音源の制約が選び取る表現に変わるところをたどる。「ゲーム機サウンドの歴史」番外編。"
category: sound-audio
difficulty: green
---

# 制約を、選んで鳴らす——ゲーム機サウンドの歴史 番外編

ゲーム機は、何を、いくつ、どこから鳴らせるのか。本編では、その答えが音源や記録媒体、スピーカーやヘッドホンの変化とともに移り変わる歴史を見てきた。

[第7回「音を、どこから聞かせるか」](console-game-sound-history-07-spatial-audio.md)の最後では、かつての制約が、作り手の選び取る音楽の個性になると予告した。その音を使って新しい曲を作ったり、既存の曲を編み直したりする音楽文化が **チップチューン** である。番外編では、曲を作る道具から始めて、同じ旋律が違う音源でどう聞こえるかを確かめよう。

***

## 第1章　チップチューンとは

チップチューンと呼ばれる音楽の範囲には幅がある。ここでは、昔のゲーム機やパソコンの音源チップの音を使って作る音楽を指す。実機の音源チップを鳴らす方法もあれば、音源の動作をソフトで **エミュレート（再現）** する方法もある。どちらでも、使う音源を選ぶと、出せる音色や同時に鳴らせる音の数が曲づくりの条件になる。

誠文堂新光社は、ゲーム機の内蔵音源チップから生まれた音楽ジャンルとしてチップチューンを紹介している。2017年には、その歴史と刊行当時の状況をたどる田中治久（hally）氏の『チップチューンのすべて』を刊行した。[[1](#ref-1)]

***

## 第2章　昔の音源で曲を作る

### ファミコンの音を打ち込む：FamiTracker

**トラッカー** とは、表のような画面に音符や演奏の指示を縦に並べて打ち込む作曲ソフトである。列を見ればどの発音枠を使うかが分かり、縦にたどれば音を鳴らす順番が分かる。

**FamiTracker** は、jsr氏が制作した、ファミコンと海外版のNES向けの曲を作る無料のWindows用トラッカーである。全チャンネルの動作を実時間で再現するため、打ち込んだ曲をその場で聴ける。本体の音源に加え、VRC6、VRC7、ディスクシステムの音源（FDS）、MMC5、ナムコの拡張音源（N163）なども扱える。[[2](#ref-2)]

[第2回](console-game-sound-history-02-pulse-and-wavetable.md)で触れたVRC6やFDS、[第3回](console-game-sound-history-03-fm-synthesis.md)で扱ったVRC7も、いまは曲に合わせて選べる音源である。同じ旋律でも、どの音源に任せるかによって、重ねられる伴奏や使える音色が変わる。

### ゲームボーイを鳴らす：LSDj

**LSDj（Little Sound DJ）** は、ゲームボーイで動く音楽シーケンサーである。シーケンサーは、どの音をいつ鳴らすかを並べて再生する道具だ。実機で使う場合は、LSDjのプログラムを、データを書き換えられるフラッシュカートリッジに入れて起動する。[第2回](console-game-sound-history-02-pulse-and-wavetable.md)で見たゲームボーイの音源が、そのまま曲を作るための音源になる。[[3](#ref-3)]

***

## 第3章　聴き比べる：『原神』の原曲とファミコン音源のアレンジ

bran氏は、FamiTrackerでファミコン風のアレンジを作るチップチューンの作り手である。本人のチャンネル紹介によると、既存のMIDIデータ（音符や演奏指示を記録したデータ）の取り込みや変換を使わず、一から打ち込む。使う音源として、ファミコン本体の2A03のほか、VRC6、MMC5、N163、FDSを挙げている。[[4](#ref-4)]

聴き比べるのは、『原神』の「凛々しい遊侠」（英題 *Gallant Challenge*）である。原曲では、まず冒頭の旋律を追い、その下で伴奏がどんな間隔で音を刻むかに耳を向けてみよう。

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/IwVdrQIKcRw"
    title="『原神』凛々しい遊侠（原曲）"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*『原神』「凛々しい遊侠」（原曲）。『原神-皎月雲間の夢 (Original Game Soundtrack)』収録、℗ miHoYo。配信元：Yu-Peng Chen - Topic（Believe配信）。<https://www.youtube.com/watch?v=IwVdrQIKcRw>*

bran氏のアレンジは、ファミコン本体の音源に、矩形波2つとのこぎり波1つを加えるVRC6を使っている。追加される発音枠については[第2回](console-game-sound-history-02-pulse-and-wavetable.md)で振り返ることができる。同じ旋律を目印にして、旋律の切れ目でどんな音が聞こえるか、低い音や短い音の刻みがどう伴奏を支えているかを聴いてみよう。音色が変わると、旋律と伴奏の受け持ち方の違いも聞こえてくる。

『原神』の運営元は、中国大陸を除く『原神』について、ゲーム素材を使った個人の非商業の二次創作を禁止していないと案内している。ゲーム音楽の利用も個人の非商業利用に限るとしており、ここでは作者本人が公開しているアレンジを紹介する。[[5](#ref-5)]

<div style="aspect-ratio: 16 / 9; width: 100%; margin: 1.5rem 0;">
  <iframe
    src="https://www.youtube.com/embed/TctNU3wHE2Q"
    title="bran — Gallant Challenge (Liyue Battle III) [8-Bit; VRC6] - Genshin Impact"
    style="width: 100%; height: 100%; border: 0;"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen>
  </iframe>
</div>

*bran「Gallant Challenge (Liyue Battle III) [8-Bit; VRC6] - Genshin Impact」。配信元：bran氏本人のYouTubeチャンネル。原曲の権利者はmiHoYo。bran氏は動画の説明欄で、本人のクレジット表記を条件にアレンジの利用を認めている。© All rights reserved by miHoYo. Other properties belong to their respective owners. <https://www.youtube.com/watch?v=TctNU3wHE2Q>*

***

## 第4章　新作のゲームが、昔の音源を選ぶ

2014年に発売された『ショベルナイト』の音楽はJake Kaufman氏が作曲し、『ロックマン』の作曲で知られる松前真奈美氏も楽曲を提供した。Kaufman氏はFamiTrackerを使い、ファミコンの音源とVRC6の発音枠で曲を組み立てた。[[6](#ref-6)][[7](#ref-7)]

Kaufman氏はサウンドトラックの配布ページで **NSF** のデータも公開した。NSFは、ファミコンやNESの音源で曲を鳴らすための演奏プログラムやデータを収めるファイル形式である。配布されたデータは、対応する再生ソフトや、対応カートリッジを使った実機で鳴らせる。[[8](#ref-8)]

開発元のYacht Club Gamesは、残響やこだまのような効果も音符を一つずつ打ち込んで作ったと説明している。一方、ゲーム内では音楽に効果音を重ねられるようにした。曲づくりには昔の発音枠を選び、プレイ中に音楽と効果音をどう聞かせるかは新作の仕様として決めたのである。[[7](#ref-7)]

***

## まとめ　どの制約を、曲づくりの条件にするか

決まった波、少ない発音枠、限られたメモリは、当時のゲーム機で音を作るうえで避けられない条件だった。いまは、作り手が音源を選び、その条件を使って曲の個性を作ることができる。

編者は、限られた発音枠で旋律や伴奏を組み直す作業に、ゲームの仕様づくりと通じるところがあると考える。先に届けたい体験を決めておくと、枠の中で何を残し、何に別の役割を持たせるかを考えやすくなる。

シリーズを振り返るなら、[第1回](console-game-sound-history.md)へ。

## References

<a id="ref-1"></a>1. [誠文堂新光社「『チップチューンのすべて』新刊のご案内」][1] — 誠文堂新光社、2017年5月。

[1]: https://www.idea-mag.com/wp/wp-content/uploads/2017/05/AllAboutChiptune_Press_Release.pdf

<a id="ref-2"></a>2. [jsr「FamiTracker」][2] — FamiTracker公式サイト。Aboutと更新履歴。

[2]: https://famitracker.com/

<a id="ref-3"></a>3. [Little Sound Dj「Little Sound Dj」][3] — LSDj公式サイト。概要と実機での使用方法。

[3]: https://www.littlesounddj.com/lsd/index.php

<a id="ref-4"></a>4. [bran「bran」][4] — YouTube。チャンネル概要。

[4]: https://www.youtube.com/channel/UCDTfibJPnxyb6wAZep7Z-hA

<a id="ref-5"></a>5. [miHoYo「常見法律問題」][5] — HoYoLAB。中国大陸を除く『原神』の案内。中国語原文の要旨を本稿で日本語にした。

[5]: https://www.hoyolab.com/article/143098

<a id="ref-6"></a>6. [Brave Wave Productions「Shovel Knight The Definitive Soundtrack」][6] — Bandcamp、2016年。2014年のオリジナル版と作曲者の紹介。

[6]: https://bravewave.bandcamp.com/album/shovel-knight-the-definitive-soundtrack

<a id="ref-7"></a>7. [Yacht Club Games「Breaking the NES」][7] — Yacht Club Games公式サイト、2014年7月。「Sound limitations」節。

[7]: https://www.yachtclubgames.com/blog/breaking-the-nes/

<a id="ref-8"></a>8. [Jake Kaufman「Shovel Knight Original Soundtrack」][8] — Bandcamp、2014年6月27日。NSF版の配布と再生方法。

[8]: https://virt.bandcamp.com/album/shovel-knight-original-soundtrack

英語・中国語の資料の説明は、本稿で日本語に要約した。

----

この文書は、Perplexity、Claude、ChatGPT の3つのAIの支援を受けて著述されたものです。引用画像を除き、MIT License にて提供されています。
