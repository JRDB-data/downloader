# JRDB-data/downloader

## このレポジトリについて

[JRDB](http://www.jrdb.com/) が提供する各種競馬データをダウンロードするためのスクリプトを提供しています。

データの利用には JRDB のメンバーになり、Basic 認証のためのユーザIDとパスワードを入手することが必要ですのでご注意ください。

[JRDB 会員登録ページ](http://www.jrdb.com/order.html)

ダウンロードされるファイルは文字コード `CP932` の固定長ファイル形式（.txt）になっております。

必要に応じて文字コード、ファイル形式の変換を行なってください。

## 初期設定

### リポジトリのクローン

``` sh
git clone git@github.com:JRDB-data/downloader.git
```

### 環境設定

環境変数の管理に `direnv` を使用しています。
お持ちでない方は以下を参考にインストールをお願い致します。

```sh
brew install direnv

## 以下 zsh, .zshrc は自分が使用しているシェルに合わせて適宜変更してください。
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
soruce ~/.zshrc
```

.env ファイルを作成して環境変数を定義してください。
以下に必要な環境変数と記載例を示します。

`JRDB_USER`, `JRDB_PASSWORD` は JRDB の会員登録時に発行されたものを入力ください。

```.env
JRDB_USER=XXXXXXXX
JRDB_PASSWORD=XXXXXXXX
DOWNLOAD_FILE_OUTPUT_DIRECTORY=${HOME}/dev/JRDB-data/files/downloaded_files/
```

`DOWNLOAD_FILE_OUTPUT_DIRECTORY` にはダウンロードファイルの出力先をご指定ください。上記の例のように入力した場合、以下のような形でダウンロードされたファイルが作成されます。

```
~/
└── dev
    └── JRDB-data
        └── files
            └── downloaded_files
                ├── Bac
                │   └── bac220319.txt <== JRDB からダウンロードされたファイル
                └── Ks
                    └── kza220319.txt <== JRDB からダウンロードされたファイル
```

以下のコマンドで環境変数をロードします。

```sh
direnv allow .
```

## スクリプトの使用方法

### 単一のファイルを取得する

データタイプと日付を指定して、指定されたファイルのダウンロードを行います。

データタイプと日付の指定は対話式で行います。

```sh
sh downloader.sh
```

初めにデータタイプを入力します。

```sh
Filetype? (ex. Ks)

以下のファイルタイプが選択できます。
===================================
JRDB 騎手データ  : Ks
JRDB 番組データ  : Bac
JRDB 登録馬データ: Kta
JRDB 馬基本データ: Ukc
JRDB 競争馬データ: Kyi
===================================
Bac # <= データタイプを入力
```

次に取得したいファイルの日付を入力します。

```sh
Filedate? (ex. 220319)
yymmdd の形式で入力してください。
220319 # <= 日付を入力
```

指定したディレクトリにファイルがダウンロードされます。

``` sh
❯❯ !(git:main) ~/dev/JRDB-data/files/downloaded_files/Bac
❯ ls
bac220319.txt
```

おそらく他の JRDB で提供されているファイルにも使用することは可能かと思われますが、動作確認済みなのは以下のデータタイプのみです。こちらは今後拡大していく予定です。

- JRDB 騎手データ  : Ks
- JRDB 番組データ  : Bac
- JRDB 登録馬データ: Kta
- JRDB 馬基本データ: Ukc
- JRDB 競争馬データ: Kyi

### 特定の日付のファイルを一括でダウンロードする

``` sh
sh download_all.sh
```

対話式で日付を指定します。

```sh
Filedate? (ex. 220319)
yymmdd の形式で入力してください。
220319 # <= 日付を入力
```

指定したディレクトリにファイルがダウンロードされます。

```sh
❯❯ !(git:main) ~/dev/JRDB-data/files/downloaded_files
❯ tree
.
├── Bac
│   └── bac220319.txt
├── Ks
│   └── kza220319.txt
├── Kta
│   └── kta220319.txt
├── Kyi
│   └── kyi220319.txt
└── Ukc
    └── ukc220319.txt
```

なお、現在一括ダウンロードされるファイルは以下のデータタイプのものですが、今後拡張される予定です。

- JRDB 騎手データ  : Ks
- JRDB 番組データ  : Bac
- JRDB 登録馬データ: Kta
- JRDB 馬基本データ: Ukc
- JRDB 競争馬データ: Kyi

### 特定のデータタイプのファイルを年度ごとに取得する

``` sh
sh bulk_downloader.sh
```

対話式でデータタイプを指定します。

```sh
Filetype? (ex. Ukc)

以下のファイルタイプが選択できます。
===================================
JRDB 馬基本データ: Ukc
===================================
Ukc # <= データタイプを入力
```

対話式で日付を指定します。

```sh
Fileyear? (ex. 2021)
YYYY の形式で入力してください。
2021 # <= 日付を入力
```

指定したディレクトリにファイルがダウンロードされます。

```
❯❯ !(git:main) ~/dev/JRDB-data/files/downloaded_files
❯ tree
.
└── Ukc
    ├── 2021
    │   ├── ukc210105.txt
    │   ├── ukc210109.txt
    │   ├── ukc210110.txt
    │   ├── ukc210111.txt
    ...(省略)
```

なお、現在使用可能なデータタイプは以下です。こちらは今後拡大される予定です。

- JRDB 馬基本データ: Ukc

## おわりに

追加して欲しい機能、バグ報告等の issue, PR は常にお待ちしております！
使用方法の質問などもお気軽にお問合せください！
