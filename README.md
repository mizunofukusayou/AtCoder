# AtCoder

[AtCoder](https://atcoder.jp) を解くためのディレクトリ。

## ディレクトリ構成

```
.
├── .envrc             # direnv 設定
├── .gitmodules
├── .include
│   └── bits
├── .nvim.lua          # プロジェクトローカルの NeoVim 設定
├── .vscode            # VsCodeのデバッグ設定（c_cpp_properties / launch / tasks）
├── 00.cpp 〜 04.cpp   # 各問題の回答ファイル
├── a.cpp 〜 g.cpp     # 各問題の回答ファイル
├── tmpl.cpp           # 新規問題作成時のテンプレート
├── input.txt          # 実行時に渡すテストケース入力
├── docs
│   └── Gemini         # Gemini との対話で深めた内容を、html や md でまとめさせたもの
├── library
│   ├── live_library         # 外部の競プロライブラリ（サブモジュール）
│   └── mizunofukusayou      # 自作ライブラリ（サブモジュール）
├── note.md            # 残しておきたい知識や気づきのメモ
├── flake.nix / flake.lock
└── README.md
```

## セットアップ

### Nix

[Zero to Nix](https://zero-to-nix.com/) を参考に `flake.nix` を使えるようにする。

```bash
direnv allow
```

direnv 自体が未インストールの場合は先にインストールする。

```bash
# Nix 経由
nix profile install nixpkgs#direnv

# Homebrew 経由
brew install direnv
```

> [!NOTE]
> Nix を通して `clang` をインストールすると `-fsanitize=undefined,address` によるメモリ不正を監視したデバッグができない
> ため、`xcode-select install` でインストールした clang を使う前提とする。

### NeoVim

NeoVim をインストールし、`vim.opt.exrc = true` を設定してプロジェクトローカルの設定（`.nvim.lua` ）を読み込めるようにする。

以下が導入済みであることを前提とする。

- プラグインマネージャー経由の `snacks.nvim`
- LSP サーバーとしての `clangd`

### library

初期化

```bash
git submodule update --init --recursive
```

更新

```bash
git submodule update --remote --recursive
```

追加

```bash
git submodule add --depth 1 <リポジトリのURL> <パス>
# 例: git submodule add --depth 1 git@github.com:atcoder/live_library.git library/live_library
git config -f .gitmodules submodule.<パス>.shallow true
```

## 使い方

### 新しい問題を解く

`a.cpp, ...` を開き、`space + t + i` でファイルを初期化する。

### ビルド・実行

テストケースをクリップボードにコピーした状態で、テストしたいファイルを開き `space + j + j` でビルド・実行する。

### 提出

`space + k + k` でファイルをコピーできるので、問題ページに貼り付けて提出する。
