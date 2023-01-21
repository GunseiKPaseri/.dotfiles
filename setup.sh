#! /bin/sh

# === SHELL CONFIG ===
set -e # stop with a error
set -u # forbidden undefined vars

# === STEP CONFIG ===
STEP_COUNT=12
COUNTER=1

# === COLOR CONFIG ===
ESC="\e["
ESCEND="m"

COLOR_CYAN="${ESC}36;1${ESCEND}"
COLOR_YELLOW="${ESC}33;1${ESCEND}"
COLOR_OFF="${ESC}${ESCEND}"

# === SET APT SERVER FIRST TIME

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}SET apt server to Yamaga Univ first time.${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`

set -x
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://linux.yz.yamagata-u.ac.jp/ubuntu/@g' /etc/apt/sources.list
{ set +x ; } 2>/dev/null
# === APT UPDATE ===

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}apt update && apt upgrade${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`
set -x
sudo apt-get update
sudo apt-get upgrade -y
{ set +x ; } 2>/dev/null

# === INSTALL apt-fast
bash -c "which apt-fast >/dev/null 2>&1" || EXIST_CMD=$?
if [ EXIST_CMD -eq 0]; then
    printf "[${COUNTER}/${STEP_COUNT}] SKIP INSTALL apt-fast\n"
else
    printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL apt-fast${COLOR_OFF}\n"

    set -x
    sudo add-apt-repository ppa:apt-fast/stable -y
    sudo apt-get update
    sudo apt-get -y install apt-fast
    { set +x ; } 2>/dev/null
fi
COUNTER=`expr $COUNTER + 1`

# === Select Japanese ===
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}Set Japanese${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`

YN_SELECTOR=""
read "${COLOR_YELLOW}SET JAPANESE? (y/N): ${COLOR_OFF}" YN_SELECTOR

case "${YN_SELECTOR}" in
    [Yy]* )
        set -x
        sudo apt-fast install -y language-pack-ja manpages-ja manpages-ja-dev
        sudo update-locale LANG=ja_JP.UTF-8
        { set +x ; } 2>/dev/null
        ;;
esac

# === set needrestart
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}Set needrestart${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`

YN_SELECTOR=""
read "${COLOR_YELLOW}Hide \"Which services should be restarted?\"? (y/N): ${COLOR_OFF}" YN_SELECTOR
case "${YN_SELECTOR}" in
    [Yy]* )
        set -x
        echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf
        { set +x ; } 2>/dev/null
        ;;
esac

# === INSTALL python & apt-selector
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL apt-select${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`

sudo apt-fast install -y python3-pip
pip3 install --upgrade pip
export PATH="$PATH:$HOME/.local/bin"
echo "export PATH=\"$PATH:$HOME/.local/bin\"" >> ~/.bashrc

set -x
sudo apt-fast install -y python3-setuptools
pip3 install apt-select
{ set +x ; } 2>/dev/null


set -x
apt-select -C JP -c -t 3 -m one-week-behind
{ set +x ; } 2>/dev/null
# SELECT
if [ -e ./sources.list ]; then
    set -x
    sudo cp ./sources.list /etc/apt/sources.list
    rm ./sources.list
    { set +x ; } 2>/dev/null
fi

set -x
sudo apt-fast update
{ set +x ; } 2>/dev/null

# === INSTALL git ===
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL git${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`
set -x
sudo apt-fast install git
{ set +x ; } 2>/dev/null
read "${COLOR_YELLOW}GEN SSH KEY? (y/N): ${COLOR_OFF}" YN_SELECTOR
case "${YN_SELECTOR}" in
    [Yy]* )
        set -x
        ssh-keygen -t ed25519
        { set +x ; } 2>/dev/null
        read "${COLOR_YELLOW}GENERATED SSH KEY! [PressEnter]${COLOR_OFF}" YN_SELECTOR
        ;;
esac

# == CLONE dotfiles.git ===

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}CLONE dotfiles.git${COLOR_OFF}\n"
COUNTER=`expr $COUNTER + 1`

set -x
cd ~
sudo rm -rf ./dotfiles
git clone https://github.com/GunseiKPaseri/dotfiles.git
bash ./dotfiles/dots_linux.sh
{ set +x ; } 2>/dev/null

# === INSTALL vim ===
bash -c "which vim >/dev/null 2>&1" || EXIST_CMD=$?
if [ EXIST_CMD -eq 0]; then
    printf "[${COUNTER}/${STEP_COUNT}] SKIP INSTALL vim\n"
else
    printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL vim${COLOR_OFF}\n"
    set -x
    sudo apt-fast install vim
    { set +x ; } 2>/dev/null
fi
COUNTER=`expr $COUNTER + 1`

# === INSTALL tmux ===
bash -c "which tmux >/dev/null 2>&1" || EXIST_CMD=$?
if [ EXIST_CMD -eq 0]; then
    printf "[${COUNTER}/${STEP_COUNT}] SKIP INSTALL tmux\n"
else
    printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL tmux${COLOR_OFF}\n"
    set -x
    sudo apt-fast install tmux
    { set +x ; } 2>/dev/null
fi
COUNTER=`expr $COUNTER + 1`

# === INSTALL fish ===
bash -c "which fish >/dev/null 2>&1" || EXIST_CMD=$?
if [ EXIST_CMD -eq 0]; then
    printf "[${COUNTER}/${STEP_COUNT}] SKIP INSTALL fish\n"
else
    printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL fish${COLOR_OFF}\n"
    set -x
    sudo add-apt-repository ppa:fish-shell/release-3 -y
    sudo apt-fast update
    sudo apt-fast install -y fish
    { set +x ; } 2>/dev/null
fi
COUNTER=`expr $COUNTER + 1`

# === INSTALL fisher ===

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}INSTALL fisher(fish package manager)${COLOR_OFF}\n"
set -x
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

source ~/.bash_profile
