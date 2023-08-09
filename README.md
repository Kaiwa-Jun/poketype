# README

## データベース
MySQL5.7

## JS
esbuild

## CSS
Sass & Bootstrap

## 環境構築方法

```
docker compose run --rm web bin/rails db:create
dc run --rm web yarn build
dc run --rm web yarn build:css
docker compose up
```
