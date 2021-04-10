#!/bin/bash
#filename       :mkalias.bash
#desc           :Add permanent aliases
#author         :Matthew Zito (goldmund)
#created        :2/2021
#version        :1.0.0
#usage          :./mkalias.bash
#environment    :bash 5.0.17
#===============================================================================

##############################
###   local runtime conf   ###
##############################

NL=$'\n'
IFS=$NL

##############################
###          Main          ###
##############################

main () {
  local arg=$1

  if [[ $UID -eq $ROOT_UID ]]; then
    panic $E_NOTROOT "This script should not be executed as root"
  fi

  if [[ ! -n $arg ]]; then
    panic $E_USAGE "No arguments were provided $(echo -e "\n\t") $(usage)"
  fi

  if [[ ! -e "$HOME/$CONF_FILE" ]]; then
    setup
  fi

  add_alias $arg
}

##############################
###      Program Fns       ###
##############################

add_alias () {
  local alias_body=$1

  echo "alias $alias_body" >> "$HOME/$CONF_FILE"

  success "Successfully added new alias"
}

##############################
###        Setup Fns       ###
##############################

setup () {
  cd $HOME 2>/dev/null || panic $E_XCD "Unable to change directories"

  chk_pwd $HOME

  get_bashrc
  create_conf
  write_conf
  add_srcline
}

create_conf () {
  touch $CONF_FILE 2>/dev/null || panic $E_CANTCREATE "Unable to create config file"
}

write_conf() {
  cat >$CONF_FILE <<END
# aliases added by $(basename $0)
# file is sourced in $BashRCFile

END

  success "Created mkalias config file in $HOME"
}

get_bashrc() {
  declare -a defaults=(
    ".bash_profile"
    ".bashrc"
  )

  # check defaults first
  for default in ${defaults[@]}; do
    if [[ -f $default ]]; then
      BashRCFile=$default
      break
    fi
  done

  # no matching default - get input from usr
  if [[ $BashRCFile == 0 ]]; then

    echo -e "[*] Unable to find bash runtime config file\n"

    BashRCFile=$(get_filename)
    while [[ ! -f $BashRCFile ]]; do
      echo -e "[-] Cannot find file $BashRCFile\n" # TODO chk for empty input
      BashRCFile=$(get_filename)
    done

  fi
}

# source the mkalias conf file in bashrc
add_srcline() {

  cat >>$BashRCFile <<END

# source aliases
if [ -f ~/$CONF_FILE ]; then
  . ~/$CONF_FILE
fi

END

  success "Added a line to source $CONF_FILE in $BashRCFile"
}

##############################
###          Utils         ###
##############################

usage() {
  cat <<END

SYNOPSIS
  Add a permanent alias

USAGE
  $0 \$1

EXAMPLE
  $0 'cdhome="cd /home/username"'
END
}

get_filename() {
  local filename

  read -p "Enter the filename: " filename
  echo $filename
}

chk_pwd() {
  local target_dir=$1

  if [[ $(pwd) != $target_dir ]]; then
    panic $E_XCD "Unable to 'cd' into $target_dir"
  fi
}

success() {
  local msg=$1

  echo -e "[+] $msg\n"
}

panic () {
  local exit_status=$1

  shift # pop exit status; we don't want to print it

  echo "[-] ERROR ($(current_time)): $*" >&2
  exit $exit_status
}

current_time () {
  echo $(date +'%Y-%m-%dT%H:%M:%S%z')
}

##############################
###        Constants       ###
##############################

# exit codes
E_XCD=86
E_CANTCREATE=76
E_CANTCP=77
E_USAGE=64

# vars
ROOT_UID=0
CONF_FILE=".mkalias.conf"

BashRCFile=0

##############################
###      *Begin Exec*      ###
##############################

# stop here if being sourced
return 2>/dev/null

# stop on errors
set -o errexit
# stop on unset variable refs
set -o nounset

main "$*"
