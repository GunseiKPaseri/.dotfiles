#!/bin/bash
set -euC	# bash option

ESC=$(printf '\033')
declare -l DSPCOLOR="reset"

COLORCHANGE() {
  echo -e -n "${ESC}"
  if [ "$1" = "back" ]; then
    # background color
    printf "\033[4"
  else
    # charactor color
    printf "\033[3"
  fi
  case "$2" in
    "red" )         printf "8;2;255;0;15m";;
    "green" )       printf "8;2;0;145;64m";;
    "yellow" )      printf "8;2;250;191;20m";;
    "blue"  )       printf "8;2;0;0;255m";;
    "purple" )      printf "8;2;146;7;131m";;
    "cyan" )        printf "8;2;0;160;233m";;
    "gray" )        printf "8;2;229;229;229m";;
    "white" )       printf "8;2;255;255;255m";;
    "black" )       printf "8;2;0;0;0m";;
    * )             printf "9m";;
  esac
}
COLORCHANGEFROMBACK() {
  case "$1" in
    "white" | "gray")
      COLORCHANGE "chara" "black";;
    * )
      COLORCHANGE "chara" "white";;
  esac
}
# make bar like powershell
TOPICCHANGE() {
  # > color
  local isUsed=true
  if [ "$DSPCOLOR" = "reset" ]; then
    echo -n ""
    isUsed=false
  else
    echo -n " "
  fi
  # > background color
  COLORCHANGE "back" "$1"
  # > color
  
  COLORCHANGE "chara" "$DSPCOLOR"
  # >
  if "${isUsed}"; then
    echo -n ""
    COLORCHANGE "chara" "reset"
  fi
  echo -n " "
  COLORCHANGEFROMBACK "$1"
  DSPCOLOR="$1"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
nerdPS1() {
  local userName="$1"
  # if userName yourname, use short name
  if [[ $userName == "paseri" ]]; then
    userName="🥦"
  fi
  local hostName="$2"
  # if hostName ..
  if [[ $hostName == "DESKTOP-FOG7J1C" ]]; then
    hostName="" # \uf878
  fi
  local pwdInfo="$3"
  
  # chroot
  if [[ -v debian_chroot ]]; then
    TOPICCHANGE "purple"
    echo -e -n "\uf306 $debian_chroot" # 
  fi
  # (optional) python venv
  if [[ -v VIRTUAL_ENV ]]; then
    local PYTHON_VER="$(python -V)"
    local PYTHON_ENVNAME="$(basename $VIRTUAL_ENV)"
    TOPICCHANGE "cyan"
    # for remove uniquename (pipenv hoge-{uniquename})
    echo -e -n "\ue235 ${PYTHON_VER#Python } ${PYTHON_ENVNAME%-*}" # 
  fi
  
   # host
  TOPICCHANGE "blue"
  echo -n "$userName@$hostName"
  # pwn
  TOPICCHANGE "gray"
  echo -e -n "\ue5ff $pwdInfo" # 
  
 # (optional) git
  # [TODO] `source git-prompt.sh` (you have to download or find)
  if [[ "$(uname -r)" == *microsoft* && "$pwdInfo" =~ ^/mnt/ ]]; then
   # Git is too slow in WSLdir 
   :
  else
    if git status --ignore-submodules &>/dev/null; then
      # You Use Git
      local gitps1="$(__git_ps1)"
      if [[ "$gitps1" =~ [*+?%] ]]; then
        TOPICCHANGE "yellow"
      else
        TOPICCHANGE "green"
      fi
      echo -e -n "\ue725 " # 
      echo -e -n "$(__git_ps1 "%s")"
    fi
  fi
  TOPICCHANGE "reset"
}

__command_rprompt() {
  local rprompt=$(date "+%Y/%m/%d %H:%M:%S")

  local num=$(($COLUMNS - ${#rprompt} - 2))
  printf "%${num}s$rprompt\\r" ''
}
set +e

PS1='$(nerdPS1 \u \h \w)\n\$ '
PROMPT_COMMAND=__command_rprompt
