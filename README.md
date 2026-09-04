
## ディレクトリ説明
### `.docs`
初期化
```bash
git submodule update --init --recursive
```

更新
```bash
git submodule update --remote --recursive
```

設定
```bash
git submodule add <リポジトリのURL> <パス>
git config -f .gitmodules submodule.<パス>.shallow true
```
