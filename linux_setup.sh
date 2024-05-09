#! /bin/sh

# === SHELL CONFIG ===
set -e # stop with a error
set -u # forbidden undefined vars

# === STEP CONFIG ===
STEP_COUNT=18
COUNTER=1

# === COLOR CONFIG ===
ESC="\e["
ESCEND="m"

COLOR_CYAN="${ESC}36;1${ESCEND}"
COLOR_YELLOW="${ESC}33;1${ESCEND}"
COLOR_OFF="${ESC}${ESCEND}"

# === SET APT SERVER FIRST TIME [sudo]
MSG="SET apt server to Yamagata Univ first time."

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

set -x
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sudo sed -i.bak -r 's@http://([a-z]{2}\.)?archive\.ubuntu\.com/ubuntu/?@https://linux.yz.yamagata-u.ac.jp/ubuntu/@g' /etc/apt/sources.list
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

# === APT UPDATE [sudo] ===
MSG="apt update"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
sudo apt-get update
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

# === INSTALL apt-fast [sudo] ===
MSG="INSTALL apt-fast"
if type "apt-fast" > /dev/null 2>&1; then
  # exist apt-fast
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  set -x
  sudo add-apt-repository ppa:apt-fast/stable -y
  sudo apt-get update
  sudo apt-get -y install apt-fast
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === APT INSTALL CORE [sudo] ===
MSG="apt install core package"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
sudo apt-fast -y install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
sudo apt-fast -y install apt-transport-https
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

# === APT UPGRADE [sudo] ===
MSG="apt upgrade"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
sudo apt-fast -y upgrade
sudo apt-fast -y clean
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

# === set hide needrestart [sudo] ===
MSG="Hide needrestart"

if !(type "needrestart" > /dev/null 2>&1); then
  # unexist needrestart
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (No command needrestart)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  YN_SELECTOR=""
  printf "${COLOR_YELLOW}Hide \"Which services should be restarted?\"? (y/N): ${COLOR_OFF}"
  read YN_SELECTOR
  case "${YN_SELECTOR}" in
    [Yy]* )
      set -x
      echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf
      { set +x ; } 2>/dev/null
      ;;
  esac
fi
COUNTER=`expr $COUNTER + 1`

# === Select Japanese [sudo] ===
MSG="Set Japanese"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
YN_SELECTOR=""
printf "${COLOR_YELLOW}SET JAPANESE? (y/N): ${COLOR_OFF}"
read YN_SELECTOR
case "${YN_SELECTOR}" in
  [Yy]* )
    set -x
    sudo apt-fast -y install \
      language-pack-ja \
      manpages-ja \
      manpages-ja-dev
    sudo timedatectl set-timezone Asia/Tokyo
    export LANG=ja_JP.UTF-8 
    export LC_ALL=ja_JP.UTF-8 
    export LANGUAGE=ja_JP.UTF-8 
    sudo sed -i 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen
    sudo locale-gen
    sudo update-locale LANG=ja_JP.UTF-8
    sudo dpkg-reconfigure -f noninteractive locales 
    sudo /usr/sbin/update-locale LANG=$LANG LC_ALL=$LANG
    sudo apt-fast -y install language-selector-common
    sudo apt-fast -y install $(check-language-support)
    sudo apt -y install xdg-user-dirs-gtk 
    LANG=C LC_ALL=C xdg-user-dirs-gtk-update
    { set +x ; } 2>/dev/null
    ;;
esac

COUNTER=`expr $COUNTER + 1`

# === Set NTP ===

MSG="Set NTP"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
sudo apt-fast -y install ntp
sudo apt-fast -y install ntpdate
sudo apt-fast -y install tzdata
sudo service ntp stop
sudo /usr/sbin/ntpdate ntp.nict.jp
sudo /usr/sbin/service ntp start
{ set +x ; } 2>/dev/null

# === Enable pip venv ===

MSG="Enable python venv"

if !(type "pip3" > /dev/null 2>&1); then
  # unexist pip3
  set -x
  sudo apt-fast -y install python3-pip
  pip3 install --upgrade pip
  export PATH="$PATH:$HOME/.local/bin"
  echo "export PATH=\"\$PATH:\$HOME/.local/bin\"" >> $HOME/.bashrc
  { set +x ; } 2>/dev/null
fi
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
sudo apt-fast -y install python3-venv
python3 -m venv .venv

# === INSTALL build-essential [sudo] ===
MSG="INSTALL build-essential"

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
sudo apt-fast -y install build-essential
{ set +x ; } 2>/dev/null

COUNTER=`expr $COUNTER + 1`

# === INSTALL brew [sudo] ===
MSG="INSTALL brew"
if type "brew" > /dev/null 2>&1; then
  # exist brew
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo '# Set PATH, MANPATH, etc., for Homebrew.\n' >> $HOME/.profile
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL git [sudo] ===
MSG="INSTALL git"
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

set -x
sudo apt-fast -y install git
{ set +x ; } 2>/dev/null
printf "${COLOR_YELLOW}GEN SSH KEY? (y/N): ${COLOR_OFF}"
read YN_SELECTOR
case "${YN_SELECTOR}" in
  [Yy]* )
    set -x
    ssh-keygen -t ed25519
    { set +x ; } 2>/dev/null
    printf "${COLOR_YELLOW}GENERATED SSH KEY! [PressEnter]${COLOR_OFF}"
    read YN_SELECTOR
    ;;
esac

COUNTER=`expr $COUNTER + 1`

# === INSTALL chezmoi ===

printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
set -x
brew install chezmoi
{ set +x ; } 2>/dev/null

# === CLEAN STEP ===
MSG="clean"
printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

set -x
sudo apt-fast -y autoremove
sudo apt-fast -y clean
{ set +x ; } 2>/dev/null

# === set thisfile ===

echo "You Should have an SSH connection to GitHub."
cat ~/.ssh/id_ed25519.pub
echo "After that Let's do this."
echo ""
echo "chezmoi init git@github.com:GunseiKPaseri/.dotfiles.git"
echo "chezmoi apply"
