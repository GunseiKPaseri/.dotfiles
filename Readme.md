# Dotfiles

## 使い方

### WSLの場合

WSLの場合はWSL内の`/etc/wsl.conf`を管理者権限で書き換え

```toml:/etc/wsl.conf
[boot]
systemd=true
```

Windows側で再起動

```ps1
wsl --shutdown
```

実行後個別にdockerを入れる必要あり

### 共通

以下を実行

```sh
# sudo snap install curl
bash -c "$( curl -fsSL https://raw.githubusercontent.com/GunseiKPaseri/.dotfiles/main/setup.sh )"
```

## 動作確認

- ubuntu(Server) 22.04.1
- ubuntu(Desktop) 22.04
- ubuntu(WSL) 22.04.1

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
- chezmoiによるdotfileの設定
- vimの導入
- tmuxの導入
- zshの導入
  - sheldonの導入
  - pecoの導入
- asdfの導入
- dockerの導入

### full

- モダンコマンドの導入
  - ag (grep)
  - batcat (cat)
  - difft (diff)
  - duf (df)
  - dust (du)
  - exa (ls)
  - fd (find)
  - hexyl (od)
  - magika (file)
  - procs (ps)

## 別途行うべき設定

### git

- [ ] `git config --global user.name <YOUR NAME>` `git config --global user.email <YOUR EMAIL>`

### IME

- [ ] Mozcの設定でツール→プロパティ→キー設定で入力なし・直接入力においてMuhenkan・Henkan設定
