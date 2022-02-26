# 内部ルール：ブランチ名（開催日までに削除すること）
- 開発する際はdevelopブランチから切ること

ブランチ名：
> feature/issuesNo./対応する内容

例：
> feature/1/post_controller_unit_test

# 内部ルール：プルリク（開催日までに削除すること）
- 自分以外のメンバーをアサインすること
- プルリクタイトルは下記の通り記載すること

プルリクタイトル
> resolve #issuesNo. 対応内容

例：
> resolve #10 post_controllerの単体テスト実装


# 環境構築:macOS (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)

### 1. git clone
`git clone https://github.com/miracleave-ltd/mirameetVol28.git`

###  2. ディレクトリ移動
`cd mirameetVol28`

###  3. ビルド
`make build`

### 4. webpakerのインストール

`docker-compose run app rails webpacker:install`

### 5. docker containerをupする
`make up`

### 6. db を作成
`make login`

`rails db:create`

`rails db:migrate`

### 7. 起動の確認
`localhost:3000`
にアクセスして表示されれば、完了です。

# 環境構築:Windows (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)
## 前提
WSL2がinstallされている
https://chigusa-web.com/blog/wsl2-win11/

Docker Desktop for Windowsがinstallされている
https://hub.docker.com/editions/community/docker-ce-desktop-windows/

Docker Desktop for Windowsの設定 > Resources > WSL INTEGRATIONでUbuntuをチェック
https://codeaid.jp/blog/docker-windowswsl2/

以下コマンドはWSL上で実施すること
※ pcの「ローカルディスク:c」で操作したい場合は
`cd /mnt/c`
に移動してから実施することをお勧めします。

例：Desktopにクローンして操作したい場合
`cd /mnt/c/Users/ユーザー名/Desktop`

macOSと同じmakeコマンドを使用したい場合は、別途installすること（installしなくても下記手順で実施できます。）
参考:https://zenn.dev/genki86web/articles/6e61c167fbe926

### 1.改行コード設定（git cloneした際に改行コードがLFからCRLFになるのを防ぐ）
`git config --global core.autocrlf input`
### 2. git clone
`git clone https://github.com/miracleave-ltd/mirameetVol28.git`

###  3. ディレクトリ移動
`cd mirameetVol28`

###  4. ビルド
`docker-compose build`

### 4. webpakerのインストール
`docker-compose run app rails webpacker:install`

途中、ファイル重複しているため、上書きするか聞かれる場合は全て「N」を入力してEnter

### 5. docker containerをupする
`docker-compose up`

### 6. db を作成
appコンテナにログインする
`docker exec -it app sh`
または
`docker exec -it app bash`

ログイン後dbを作成する
`rails db:create`

`rails db:migrate`

### 7. 起動の確認
ブラウザで
`localhost:3000`
にアクセスする

## 補足：　make コマンド
### コンテナ削除（ボリューム合わせて削除します。）
`make destroy`

