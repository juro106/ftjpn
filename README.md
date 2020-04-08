# ftjpn

日本語のft移動、操作を便利にするプラグインです。

デフォルトの機能を維持したまま、新たに別なキーをマッピングすることなく、`.`で`。`、`,`で`、`への移動を可能にします。

## `.`で、`.`と`。`の両方へ移動可能。

`f.`と打てば、現在のカーソル位置から`.`と`。`のどちらか近い方を選んで移動します。

`;`で順方向、`,`で逆方向へ繰り返し。デフォルトの動作そのままです。

## オプション: キーの設定

.vimrcでキーを設定します。配列の先頭の文字がマッピングされます。

```
let g:ftjpn_key_list = [
 \ ['.', '。', '．'],
 \ ]
```
このように設定した場合、ノーマルモードで`f.`と打てば `.`と`。`と `．` の合わせて３文字への移動が可能になります。

３文字の中で最も近い場所にある文字に移動します。`F`なら逆方向、`t`と`T`の動作もデフォルトと同じです。

## `d` `c` `y` `v`も同じように動作します

削除やヤンク、ビジュアルモードでも使えます。

`df.`で`。`までカット。`ct,`なら`、`の手前まで削除して挿入モードへ。`yf`や`vt` 同様です。

### 設定例

```
let g:ftjpn_key_list = [
    \ ['.', '。', '．'],
    \ [',', '、', '，'],
    \ ['t', 'と'],
    \ ['n', 'に'],
    \ ['w', 'を'],
    \ ['h', 'は'],
    \ ['g', 'が'],
    \ ['d', 'で'],
    \ ['o', 'の'],
    \ ['c', '（', '）'],
    \ ['k', '「', '」', '『', '』', '【', '】'],
    \ ['!', '！'],
    \ ['?', '？'],
    \ [';', '!', '?', '^', '$', '#', ':', '&', '%', '~', '*', '！', '？'],
    \ ]
```

`.`や`,`以外でも設定可能です。

`t`を`と`にも対応させたり、`w`を`を`に対応させることが出来ます。文章の区切りになりやすい文字を設定しておくと移動が楽になります。

例えば`;`に複数の記号を設定しておけば、`f;`と打つだけで色々な記号に移動できます。

全て本来の機能を維持したまま設定可能です。

### キーマッピング

``` vim
let g:ftjpn_no_defalut_key_mappings = 1

let g:ftjpn_f = 'f'
let g:ftjpn_F = 'F'
let g:ftjpn_t = 't'
let g:ftjpn_T = 'T'
```

キーマップを変える場合、vimrcに `let g:ftjpn_no_defalut_key_mappings = 1` としてから、各キーを設定して下さい。

### 欠点: 英語と日本語が混ざっているときがめんどう

例文 1) Hello World. 私は日本人です。東京から来ました。My name is Vim.

カーソルが行頭にあり、`私は日本人です。`の`。`に直接移動したい時。`f.`と打っても`Hello World.`の`.`が選ばれてしまいます。

こういう場合は`f。`と打つか（めんどくさい…）、あるいは`f.` `f.`（ちょっと大変）と２回続けることでようやく`私は日本人です。`の`。`に移動出来ます。近いほうが選ばれてしまう弊害です。

例文 2) こんにちは世界。I am Japanese. I am from Tokyo. 私の名前はヴィムです。

この場合も同様の困難が待ち受けています。

行頭で`f.`とすると、`こんにちは世界。`の`。`へと移動してしまいます。例 1)と同じく`f.`を２回繰り返すことになります。

もう１つの解決策は`f`を押して1秒以上待つことです。そうすれば`f`は通常の`f`になり、`.`を押しても`。`は無視されて`I am Japanes.`の`.`へ移動出来ます。

逆に言えばデフォルトのオペレータ待機モードのように永遠に待ってはくれないということです。`df`や`cf`、`yf`、`vf`のときも同様です（`<space>u`と打って`[unite]`の文字が出ている間に次のキーを打たないといけない、あれと同じことです）。

とはいえ、1行の中に日本語と英語がごちゃまぜで書かれていることは稀でしょう。

サクサク移動するためのキーマッピングなので1秒で時間切れだからといって困ることもあまりないとは思います。

この２つの欠点が些細な問題であることを願います。

## キー設定のコツを模索中

`fe`があまり有効ではないのと同じように、日本語も出現率が高い文字を設定しても役に立たないでしょう。

かといって、そもそもあまり出てこない文字では全く意味がありません。

上手いこと区切りとして優秀な文字を設定できれば`f`の移動がかなり快適になるとはずです。制限された枠組みの中で最適解を導き出す…ワクワクしますね。

参考までに私が考えた例を掲載します。


### S級
|日本語|key 候補|意味合い|
|--|--|--|
|が|g|Subject, but
|を|w,o|Object
|は|h|is
|と,て|t,o,e|and, with
|に|n,i|to
|の|n,o|'s
|で|d,e,|by

`、`や`。`によって大きな区切りへの移動ができるようになったので、それとは少し離れてかつ大切な場所に移動する手段が欲されます。

主語や目的語の近くに現れる文字を設定しておきたいところです。

### A級
|日本語|key 候補|意味合い|
|--|--|--|
|へ|h,e|to
|で|d,e|by
|だ|d,a|$
|な|n,a|like
|ば|b|and 
|し|s,i|do
|す|s,u|do,$ 
|る|r,u|do,$
|た|t,a|did
|か|k|or 
|こ|k,o|thing
|よ|y,o|by
|こ|k,o|
|ま|m,a|

`る`や`か`はたくさん出てきますが、案外微妙な場所に出現することが多い印象です。移動した後には当然消去かヤンクをしたいはずなので、「だったら別な場所行くわ」という扱いになってしまいます。

### 漢字
|日本語|key 候補|意味合い|
|--|--|--|
|何|n,i,w|what,why
|時|j,z,t,i|when
|誰|w,h,d|who
|場|b,w,a|where
|所|t,w,s|where
|方|h,o,u|how
|法|h,o,u|how
|同|=|
一|1||
二|2||
三|3||
四|4||
五|5||
六|6||
七|7||
八|8||
九|9||

漢字を目印にするのはあまり上手い作戦ではないような気がしていますが、あればあったで便利かもしれません。

### カッコ系
|カッコ|key 候補 |
|--|--|
|「」 |k
|「 |k
|」|K
| （）|c
| （）|(
| 【】|b,
| 『』|K
| ‘’|'
| “”|"
| 〈〉|<
| 〔〕|
| ｛｝|
