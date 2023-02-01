# Dotfiles

## 使い方

おおよそ以下で動作する

```sh
# sudo snap install curl
bash -c "$( curl -fsSL https://raw.githubusercontent.com/GunseiKPaseri/dotfiles/main/setup.sh )"
```

## 動作確認

- ubuntu(Server) 22.04.1
- ubuntu(Desktop) 22.04

## 行われる設定

### withoutsudo

- このリポジトリのクローン
- brewの導入

### essential

- apt serverの変更
- apt update
- apt-fastの導入
- 必須系プログラムの導入
- apt upgrade
- needrestartの非表示化
- 日本語化
- NTP設定
- pip3とapt-selectの導入
- build-essentialの導入
- gitの導入
- brewの導入
- vimの導入
- tmuxの導入
- fishの導入
  - fisher各種プラグインの導入
    - peco
    - extract
    - gitignore
    - spin
  - シェルスタイルの設定
    - HackGenNerdのインストール(optional)
    - bobthefishまたらstarship(optional)
- asdfの導入
- dockerの導入

### full

- モダンコマンドの導入
  - ag (grep)
  - batcat (cat)
  - duf (df)
  - dust (du)
  - exa (ls)
  - hexyl (od)
  - procs (ps)
  - fd (find)

## 別途行うべき設定

### git

- [ ] `git config --global user.name <YOUR NAME>` `git config --global user.email <YOUR EMAIL>`

### IME

- [ ] Mozcの設定でツール→プロパティ→キー設定で入力なし・直接入力においてMuhenkan・Henkan設定
