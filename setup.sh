#! /bin/sh

# === SHELL CONFIG ===
set -e # stop with a error
set -u # forbidden undefined vars

# === STEP CONFIG ===
STEP_COUNT=18
COUNTER=1

set -x
TMPDIR=/tmp/dotfiles
mkdir -p $TMPDIR
{ set +x ; } 2>/dev/null

# === COLOR CONFIG ===
ESC="\e["
ESCEND="m"

COLOR_CYAN="${ESC}36;1${ESCEND}"
COLOR_YELLOW="${ESC}33;1${ESCEND}"
COLOR_OFF="${ESC}${ESCEND}"

# === SELECT MODE

MODE_SELECTOR=""
MODE_WITHOUTSUDO=0
MODE_ESSENTIAL=1
MODE_FULL=2
while :
do
  printf "${COLOR_YELLOW}SELECT MODE [withoutsudo/essential/full]: ${COLOR_OFF}"
  read MODE_SELECTOR
  case "${MODE_SELECTOR}" in
    "withoutsudo" )
      MODE=$MODE_WITHOUTSUDO
      printf "${COLOR_CYAN}Run only tasks that do not require sudo.${COLOR_OFF}\n"
      break
      ;;
    "essential" )
      MODE=$MODE_ESSENTIAL
      printf "${COLOR_CYAN}Run essential tasks.${COLOR_OFF}\n"
      break
      ;;
    "full" )
      MODE=$MODE_FULL
      printf "${COLOR_CYAN}Run all tasks.${COLOR_OFF}\n"
      break
      ;;
  esac
done

# === SET APT SERVER FIRST TIME [sudo]
MSG="SET apt server to Yamagata Univ first time."

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  set -x
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
  sudo sed -i.bak -r 's@http://([a-z]{2}\.)?archive\.ubuntu\.com/ubuntu/?@https://linux.yz.yamagata-u.ac.jp/ubuntu/@g' /etc/apt/sources.list
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === APT UPDATE [sudo] ===
MSG="apt update"

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo apt-get update
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL apt-fast [sudo] ===
MSG="INSTALL apt-fast"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "apt-fast" > /dev/null 2>&1; then
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

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo apt-fast -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo apt-fast -y install apt-transport-https
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === APT UPGRADE [sudo] ===
MSG="apt upgrade"

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo apt-fast -y upgrade
  sudo apt-fast -y clean
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === set hide needrestart [sudo] ===
MSG="Hide needrestart"

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif !(type "needrestart" > /dev/null 2>&1); then
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
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
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
fi

COUNTER=`expr $COUNTER + 1`

# === Set NTP ===

MSG="Set NTP"

if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  sudo apt-fast -y install ntp
  sudo apt-fast -y install ntpdate
  sudo apt-fast -y install tzdata
  sudo service ntp stop
  sudo /usr/sbin/ntpdate ntp.nict.jp
  sudo /usr/sbin/service ntp start
fi

# === INSTALL pip3 & apt-selector [sudo] ===
MSG="INSTALL pip3 && apt-select"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  if !(type "pip3" > /dev/null 2>&1); then
    # unexist pip3
    set -x
    sudo apt-fast -y install python3-pip
    pip3 install --upgrade pip
    export PATH="$PATH:$HOME/.local/bin"
    echo "export PATH=\"\$PATH:\$HOME/.local/bin\"" >> $HOME/.bashrc
    { set +x ; } 2>/dev/null
  fi
  set -x
  # install python tool
  sudo apt-fast -y install python3-setuptools
  # run python
  pip3 install apt-select

  # run
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
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL build-essential [sudo] ===
MSG="INSTALL build-essential"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  set -x
  sudo apt-fast -y install build-essential
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL git [sudo] ===
MSG="INSTALL git"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
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
fi

COUNTER=`expr $COUNTER + 1`

# == CLONE dotfiles.git ===
MSG="CLONE .dotfiles.git"

if !(type "git" > /dev/null 2>&1); then
  # unexist git
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (need git command)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  cd ~
  rm -rf ./.dotfiles
  git clone https://github.com/GunseiKPaseri/.dotfiles.git
  bash ./.dotfiles/dots_linux.sh
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL brew [sudo] ===
MSG="INSTALL brew"
if type "brew" > /dev/null 2>&1; then
  # exist brew
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo '# Set PATH, MANPATH, etc., for Homebrew.\n' >> $HOME/.profile
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL vim ===
MSG="INSTALL vim"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "vim" > /dev/null 2>&1; then
  # exist vim
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  if type "gnome-shell" > /dev/null 2>&1; then
    # exist gnome-shell
    set -x
    sudo apt-fast -y install vim-gnome
    { set +x ; } 2>/dev/null
  else
    set -x
    sudo apt-fast -y install vim-gtk3
    { set +x ; } 2>/dev/null
  fi
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL tmux ===
MSG="INSTALL tmux"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "tmux" > /dev/null 2>&1; then
  # exist tmux
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo apt-fast -y install tmux
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL fish ===
MSG="INSTALL fish"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "fish" > /dev/null 2>&1; then
  # exist fish
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo add-apt-repository ppa:fish-shell/release-3 -y
  sudo apt-fast update
  sudo apt-fast -y install fish
  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL fisher ===
MSG="INSTALL fisher(fish package manager)"
if !(type "fish" > /dev/null 2>&1); then
  # unexist fish
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need fish)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
  { set +x ; } 2>/dev/null

  # === INSTALL styling ===

  printf "${COLOR_YELLOW} If you want to install bobthefish or etc, need 'nerdfont'"
  printf " (for example , ) \n"
  YN_SELECTOR=""
  printf "install nerd font? (if you access via ssh, needn't)[y/N]: ${COLOR_OFF}"
  case "${YN_SELECTOR}" in
    [Yy]* )
      set -x
      sudo apt-fast -y install unzip
      curl -L --output "$TMPDIR/HackGen.zip" https://github.com/yuru7/HackGen/releases/download/v2.8.0/HackGen_NF_v2.8.0.zip
      unzip $TMPDIR/HackGen.zip -d $TMPDIR/HackGen
      mkdir -p $HOME/.local/share/fonts
      cp $TMPDIR/HackGen/HackGen_NF_v2.8.0/*.ttf $HOME/.local/share/fonts
      { set +x ; } 2>/dev/null
      ;;
  esac

  FISHMODE_SELECTOR=""
  while :
  do
    printf "${COLOR_YELLOW}SELECT fish style\n"
    printf "    default   : ~ (main > \n"
    printf "    bobthefish: ~  main  (~|>)\n"
    printf "    starship  : on  via x.x.x\n"
    printf "${COLOR_YELLOW}[default/bobthefish/starship]: ${COLOR_OFF}"
    read FISHMODE_SELECTOR
    case "${FISHMODE_SELECTOR}" in
      "default" )
        break
        ;;
      "bobthefish" )
        printf "${COLOR_CYAN}Install bobthefish${COLOR_OFF}\n"
        set -x
        fish -c "fisher install oh-my-fish/theme-bobthefish"
        { set +x ; } 2>/dev/null
        break
        ;;
      "starship" )
        printf "${COLOR_CYAN}Install starship${COLOR_OFF}\n"
        if type "brew" > /dev/null 2>&1; then
          # exist brew
          set -x
          brew install starship
          { set +x ; } 2>/dev/null
        else
          set -x
          curl -sS https://starship.rs/install.sh | sh
          { set +x ; } 2>/dev/null
        fi
        set -x
        echo "starship init fish | source" > ~/.config/fish/fromdotfiles/starship.fish
        { set +x ; } 2>/dev/null
        break
        ;;
    esac
  done

  # === INSTALL peco ===

  if !(type "brew" > /dev/null 2>&1); then
    # unexist brew
    printf "Skip Install peco (need brew)\n"
  else
    printf "${COLOR_CYAN}Install peco${COLOR_OFF}\n"
    set -x
    brew install peco
    fish -c "fisher install oh-my-fish/plugin-peco"
    { set +x ; } 2>/dev/null
  fi

  # === plugin ===
  sudo apt-fast -y install tar unrar zip gzip
  fish -c "fisher install oh-my-fish/plugin-extract"

  fish -c "fisher install fisherman/gitignore"

  fish -c "fisher install fisherman/spin"

fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL asdf ===

MSG="INSTALL asdf"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "asdf" > /dev/null 2>&1; then
  # exist asdf
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
  # fish config
  echo -e "source ~/.asdf/asdf.fish" > $HOME/.config/fish/fromdotfiles/asdf.fish
  
  # fish completions
  mkdir -p ~/.config/fish/completions
  ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL docker ===

MSG="INSTALL docker"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
elif type "docker" > /dev/null 2>&1; then
  # exist docker
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (installed)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x

  sudo apt-fast -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt-fast update
  sudo apt-fast -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

  sudo docker run hello-world

  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === INSTALL modern ===

MSG="INSTALL modern command"
if [ $MODE -le $MODE_ESSENTIAL ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (optional)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"
  set -x
  sudo apt-fast install exa bat silversearcher-ag fd-find hexyl duf
  sudo snap install dust procs

  { set +x ; } 2>/dev/null
fi

COUNTER=`expr $COUNTER + 1`

# === CLEAN STEP ===
MSG="clean"
if [ $MODE -le $MODE_WITHOUTSUDO ]; then
  printf "[${COUNTER}/${STEP_COUNT}] SKIP ${MSG} (Need sudo)\n"
else
  printf "[${COUNTER}/${STEP_COUNT}] ${COLOR_CYAN}${MSG}${COLOR_OFF}\n"

  set -x
  sudo apt-fast -y autoremove
  sudo apt-fast -y clean
  { set +x ; } 2>/dev/null
fi
set -x
rm -rf $TMPDIR
{ set +x ; } 2>/dev/null
# === set thisfile ===
source $HOME/.bash_profile
