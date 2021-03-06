# RebuldTagプラグイン

## はじめに

このプラグインは、テンプレートの中で、特定のテンプレートに対して、強制的に再構築をさせることができます。

## インストール

本パッケージに含まれる「**plugins**」ディレクトリ内のディレクトリ「RebuildTag」を、Movable
Typeインストールディレクトリの「**plugins**」ディレクトリの下にコピーしてください。\
作業後、Movable Typeのシステム・メニューのプラグイン管理画面を表示し、プラグインの一覧に「RebuildTag」が表示されていることを確認してください。

## 使い方

### MTタグ

#### mt:Rebuld (ファンクションタグ)

##### モディファイヤ

- template_ids
    - 強制的に再構築させるテンプレートのIDを指定する。複数のIDを指定する場合は、カンマ(,)で区切ります。
- force_rebuild = "0|1"
    - 1の場合、強制的にファイルを出力します。

## 例

```
<mt:Rebuild template_ids="400,4001" force_rebuild="1">
```

#### mt:RebuldEntries (ファンクションタグ)

##### モディファイヤ

- ids
    - 強制的に再構築させる記事/ページのIDを指定する。複数のIDを指定する場合は、カンマ(,)で区切ります。
- force_rebuild = "0|1"
    - 1の場合、強制的にファイルを出力します。

## 例

```
<mt:RebuildEntries ids="400,4001" force_rebuild="1">
```

