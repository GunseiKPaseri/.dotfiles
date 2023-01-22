# install

おおよそ以下で動作する

```sh
# sudo snap install curl
bash -c "$( curl -fsSL https://raw.githubusercontent.com/GunseiKPaseri/dotfiles/main/setup.sh )"
```

動作確認

- ubuntu(server) 22.0.1

## ubuntu

- [ ] `LANG=C xdg-user-dirs-gtk-update`
  - `Don't ask me this again` にチェック、`Update Names`を選択
    - 失敗したら再ログインしてチェックして`Keep old Names`を選択
- [ ] aptサーバを選択

## git

- [ ] `sudo apt install git`
- [ ] <https://qiita.com/shizuma/items/2b2f873a0034839e47ce>
- [ ] `git config --global user.name GunseiKPaseri` `git config --global user.email GunseiKPaseri@gmail.com`

## vim

- [ ] `sudo apt install vim-gtk3`

## IME

- [ ] Mozcの設定でツール→プロパティ→キー設定で入力なし・直接入力においてMuhenkan・Henkan設定

## その他

- [ ] `./dots_linux.sh`
  - vimを起動、一度終了して再起動して設定が反映されているか確認
