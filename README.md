# 環境構築:macOS (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)
## 前提
### 0-1.Docker Desktop for Macがinstallされていること
下記URLの「Get Docker Desktop for Macのダウンロード」からお使いのMacに合わせて、実行ファイルをダウンロードすること

https://matsuand.github.io/docs.docker.jp.onthefly/desktop/mac/install/


### ※これ以降の手順におけるコマンドはターミナル上で実施すること
### 1. git clone
`git clone https://github.com/miracleave-ltd/mirameetVol27.git`

###  2. ディレクトリ移動
`cd mirameetVol27`

###  3. ビルド
`make build`

※万が一、下記のようなエラーが発生した場合は、xcodeがダウンロードされていない可能性があるため、参考記事を見て対応をお願いいたします。

```
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```

[参考記事](https://qiita.com/kooohei/items/6aada548eeb785dd2c91)


### 4. webpakerのインストール

`docker-compose run app rails webpacker:install`

途中、ファイル重複しているため、上書きするか聞かれる場合は全て「N」を入力してEnter
![image](https://user-images.githubusercontent.com/54019059/162644031-57a772ab-50e7-4607-b635-b7f77b400c13.png)


### 5. docker containerをupする
`make up`

### 6. db を作成
`make login`

`rails db:create`

`rails db:migrate`

### 7. 起動の確認
`localhost:3000`
にアクセスして表示されれば、完了です。

※画面表示時に`Webpacker::Manifest::MissingEntryError`のエラーが出た場合、
No.4のwebpacker:installをしたか確認、していない場合は実行。それでも再度エラー、またはinstallしたのにエラーの場合は、下記コマンドを実行してください。

`rails webpacker:compile`


# 環境構築:Windows (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)
## 前提
### 0-1.WSL2とUbuntuがinstallされていること
下記のURLを参考にして、installすること

https://chigusa-web.com/blog/wsl2-win11/

※wsl2のインストールで0x80370102 エラーが出たときの対処方法 
https://monkey999por.hatenablog.com/entry/2020/10/01/221243


### 0-2.Docker Desktop for Windowsがinstallされていること
下記URLの「Get Docker Desktop for Windows」ボタンをクリックしてexeファイルをダウンロードすること

https://hub.docker.com/editions/community/docker-ce-desktop-windows/


### 0-3.「Docker Desktop for Windows」をダウンロード後、下記のURLを参考にして、exeファイルを実行すること
「Install required Windows components for WSL2」にチェックが入っていることを確認する

Docker Desktop for Windowsの設定 > Resources > WSL INTEGRATIONでUbuntuをチェック

https://codeaid.jp/blog/docker-windowswsl2/

macOSと同じmakeコマンドを使用したい場合は、別途installすること（installしなくても下記手順で実施できます。）
参考:https://zenn.dev/genki86web/articles/6e61c167fbe926


### ※これ以降の手順におけるコマンドはWSL上で実施すること
※ pcの「ローカルディスク:c」で操作したい場合は`cd /mnt/c`に移動してから実施することをお勧めします。

例：Desktopにクローンして操作したい場合
> `cd /mnt/c/Users/ユーザー名/Desktop`

### 1.改行コード設定（git cloneした際に改行コードがLFからCRLFになるのを防ぐ）
`git config --global core.autocrlf input`

### 2. git clone
`git clone https://github.com/miracleave-ltd/mirameetVol27.git`

### 3. ディレクトリ移動
`cd mirameetVol27`

### 4. ビルド
`docker-compose build`

### 5. docker containerをupする
`docker-compose up -d`

### 6. appコンテナにログインする
`docker exec -it app sh`
 
または

`docker exec -it app bash`

### 7. webpakerのインストール
`rails webpacker:install`

途中、ファイル重複しているため、上書きするか聞かれる場合は全て「N」を入力してEnter
![image](https://user-images.githubusercontent.com/54019059/162644033-0f6f0117-ceb8-451f-8537-3ba5f9e8c09c.png)


### 8. db を作成
`rails db:create`

`rails db:migrate`

### 9. 起動の確認
ブラウザで
`localhost:3000`
にアクセスする

※画面表示時に`Webpacker::Manifest::MissingEntryError`のエラーが出た場合、
No.のwebpacker:installをしたか確認、していない場合は実行。それでも再度エラー、またはinstallしたのにエラーの場合は、下記コマンドを実行してください。

`rails webpacker:compile`

## 補足：　make コマンド
### コンテナ削除（ボリューム合わせて削除します。）
`make destroy`

