# dir\_image

任意のディレクトリ配下の画像ファイルを表示するための [Sinatra](http://www.sinatrarb.com/) ベースのウェブアプリケーションです。

## インストール

    $ git clone https://github.com/yuanying/dir_image.git
    $ cd dir_image
    $ bundle install

## 設定

インストールしたディレクトリの、config.yml を編集。

    tmp_dir: '~/.random_image'      # アプリケーションが使用する一時ファイル置き場。
    image_dirs: ['~/Pictures']      # 公開する画像が含まれているフォルダのリスト。

## 実行

    $ bundle exec rackup
    [2012-02-09 16:22:43] INFO  WEBrick 1.3.1
    [2012-02-09 16:22:43] INFO  ruby 1.8.7 (2011-06-30) [i686-darwin11.2.0]
    [2012-02-09 16:22:43] INFO  WEBrick::HTTPServer#start: pid=45945 port=9292

http://localhost:9292/ で動作しているのを確認する。

## Copyright

Copyright &copy; 2012 Yuanying. See LICENSE for details.
