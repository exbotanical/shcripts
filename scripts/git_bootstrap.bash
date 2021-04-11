#!/bin/bash
#desc           :bootstrap a new git repository
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./git_bootstrap.bash
#environment    :bash 5.0.17
#===============================================================================

Nl=$'\n'
IFS=$Nl

continue? () {
  local repo_name=$1
  read -p "[!] Are you sure you want to initialize $repo_name as a git repository? (y/n)" answer
  case $answer in
  y );;
  n)
    exit 0
    ;;
  *)
    continue?
    ;;
  esac
}

init_git () {
  local repo_name=$1
  echo "[+] Initializing a new Git repository in $repo_name..."
  git init
}

create_readme () {
  local repo_name=$1
  echo "[+] Creating README at $Readme_f..."
  touch $Readme_f
  echo "# $repo_name" > $Readme_f
}


create_gitignore () {
  echo "[+] Creating $Git_ignore_f..."
  touch $Git_ignore_f

  while true; do
    read -p "[+] Enter file name to add to $Git_ignore_f (or 'x' to continue): " filename
    if [[ $filename == "x" ]]; then
      break
    else
      echo $filename >> $Git_ignore_f
    fi
  done
}

main () {
  local dir_name=`basename $(pwd)`

  continue? $dir_name

  init_git $dir_name
  create_gitignore
  create_readme $dir_name

  echo "[+] Done"
}

Git_ignore_f='.gitignore'
Readme_f='README.md'

# stop here if being sourced
return 2>/dev/null

# stop on errors and unset variable refs
set -o errexit
set -o nounset
# no globbing - we don't need it here
set -o noglob

main
