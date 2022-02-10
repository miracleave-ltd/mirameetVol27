# 内部ルール：ブランチ名（開催日までに削除すること）
開発する際はdevelopブランチから切ること

ブランチ名：
> feature/issuesNo./対応する内容

例：
> feature/1/post_controller_unit_test


# 環境構築 (※ミートアップ参加前に下記手順に従い、起動確認までお願いいたします。)

### 1. git clone
`git clone https://github.com/miracleave-ltd/mirameetVol28.git`

###  2. ビルド
`make build`

### 3. yarnのインストール
`docker-compose run app yarn install --check-files`

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

