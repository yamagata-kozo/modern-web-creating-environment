# Overview

このリポジトリはクラスメソッド開発ブログ「SinatraとHamlとScssとCoffeeScriptでモダンなWeb制作環境を構築する #１〜３」で紹介したプロジェクトの成果を公開したものです。

## Features

* haml、scss(sass)、coffescript等のテンプレート、メタ言語を使ってWebサイト制作ができます
* サイトツリーをjsonで記述してrakeコマンドを叩けばコンパイル済みの静的ファイルを保存出来ます

## Usage

gitリポジトリをcloneして、gemをインストール

```
  $ git clone ...
  $ bundle install --path vendor/bundle
```

ローカルでサーバを起動して開発作業...

```
  $ bundle exec rackup
```

Webサイトができたら、site.jsonにサイト名とツリーを記述

```
  {
    "name": "SITE_NAME",
    "tree": [
      "index.html",
      {
        "foo": [
          "bar.html"
        ]
      },
      {
        "admin": [
          "index.html"
        ]
      }
    ]
  }
```

rakeコマンドでサイトを一気に保存！

```
  $ bundle exec rake make_static_file
```


 

