#!/bin/bash
#title          :git_bootstrap
#desc           :bootstrap a new git repository
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./git_bootstrap.bash
#environment    :bash 5.0.17
#===============================================================================

# FIXME
# TODO rewrite this
Nl=$'\n'
IFS=$Nl

get_repo_name () {
  local repo_dir=$1
  # this is the name that will be used on GH, or elsewhere
  read -p "[+] Use '$repo_dir' as public-facing repo name? (y/n) " answer

  case $answer in
    y )
      repo_name=$repo_dir
      ;;
    n )
      read -p "[+] Enter your new repository name: " repo_name
      # default back to curr if invalid opt given
      if [ "$repo_name" = "" ]; then
          repo_name=$repo_dir
      fi
      ;;
    *)
      get_repo_name
      ;;
  esac
}

create_readme () {
  echo "[+] Creating README at $Readme_f..."
  touch $Readme_f
  echo "# $1" > $Readme_f
}

init_git () {
  local repo_name=$1
  echo "[+] Initializing a new Git repository in $repo_name..."
  git init
}

create_gitignore () {
  echo "[+] Creating $Git_ignore_f..."
  touch $Git_ignore_f

  while true; do
    read -p "[+] Enter file name to add to $Git_ignore_f (or 'q' to quit): " filename
    if [ $filename = "q" ]; then
      break
    else
      echo $filename >> $Git_ignore_f
    fi
  done
}

main () {
  local dir_name=`basename $(pwd)`

  get_repo_name $dir_name
  create_readme $repo_name
  create_gitignore
  init_git $repo_name

  echo "[+] Done"
}

Git_ignore_f='.gitignore'
Readme_f='README.md'

# stop here if being sourced
return 2>/dev/null

# stop on errors and unset variable refs
set -o errexit
set -o nounset
