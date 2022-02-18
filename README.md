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


# 環境構築 (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)

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

## 補足：　make コマンド
### コンテナ削除（ボリューム合わせて削除します。）
`make destroy`

