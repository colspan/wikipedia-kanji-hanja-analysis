# wikipedia-kanji-hanja-analysis

## 概要

Wikipediaをコーパスとした日韓漢字読み比較を実装した。
一般的に知られている[日韓の漢字読みの対応](http://colspan.hatenablog.com/entry/2014/11/04/211152)を定量的に明らかにする。


## 分析情報源

| データ | 情報源 |
|:-----------|:------------|
| コーパス | [Wikipedia ダウンロード](http://ja.wikipedia.org/wiki/Wikipedia:%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%83%80%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%89) |
|ハングル漢字変換|[한글 &lt;-&gt; 한자 코드 변환](http://nlp.kookmin.ac.kr/data/hanja.html)|
|日本語形態素解析|[Chasen](http://chasen-legacy.sourceforge.jp/)|
|漢字読み仮名変換|[Kakasi](http://kakasi.namazu.org/)|
|漢字読み旧仮名遣い仮名変換|[歴史的仮名遣い変換辞書「快適仮名遣ひ」](http://www5a.biglobe.ne.jp/~accent/form/henkan.htm)|
|韓国語体(旧字体)日本語体(新字体)変換 |[旧字体・新字体変換](http://www.geocities.jp/qjitai/)|
</table>
</div>

## 依存関係

* Python (パイプライン制御)
   * luigi
* Ruby (解析全般)
   * kakasi
   * mecab
   * json
   * romaji

## 分析結果
Wikipediaの題名突き合わせによって抽出した約1500文字、のべ約1700通りの漢字読みを用いた。

## 実行方法

### Wikipediaダンプデータ入手
```sh
cd data_generator
./fetch_dump_wikipedia.sh
```

### 解析
```sh
./wikipedia-jpkr-analysis.py
```


### Wikipedia

## その他
[d3.jsによる可視化](http://colspan.github.io/kanji-hanja/)も別途実装した。
