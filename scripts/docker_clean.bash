#!/bin/bash
#title          :docker_clean
#desc           :purge all dangling docker artifacts
#author         :Matthew Zito (goldmund)
#created        :01/2021
#version        :1.0.0
#usage          :bash ./docker_clean.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

TARGET_IMAGES=(
# target image names here
)

prune_docker_imgs () {
  echo -e '[*] Checking for dangling images...\n'

  if [[ $(echo $(docker images -f dangling=true -q) | wc -m) -gt 1 ]]; then
    echo -e '[*] Pruning all dangling images...\n'
    docker rmi $(docker images -f dangling=true -q)
  else
    echo -e '[*] No dangling images were found; skipping...\n'
  fi
}

prune_docker_vols () {
  echo -e '[*] Checking for dangling volumes...\n'

  if [[ $(echo $(docker volume ls) | wc -m) -gt 19 ]]; then
    echo -e '[*] Pruning all dangling volumes...\n'
    docker volume prune
  else
    echo -e '[*] No dangling volumes were found; skipping...\n'
  fi
}

stop_daemon_proc () {
  echo -e '[*] Checking for active daemon processes...\n'

  [[ $(echo $(docker ps -aq) | wc -m) -gt 1 ]] && {
    echo -e '[*] Stopping all running Docker processes...\n'
    docker stop $(docker ps -aq)
  }
  echo -e '[*] No active daemon processes; skipping...\n'
}

purge_images () {
  for ((i=0; i < ${#TARGET_IMAGES[@]}; i++)); do
    echo -e "[*] Purging all ${TARGET_IMAGES[i]} images...\n"
    docker images | grep ${TARGET_IMAGES[i]} | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi ${TARGET_IMAGES[i]}:{}
  done;
}

main () {
  if [[ ${#TARGET_IMAGES} -eq 0 ]]; then
    echo "[-] You must set the target images prior to executing this script"
    exit $E_ARGS
  fi

  read -p "[*] Warning: this script will remove all target containers, images, and dangling volumes. Continue? (y/n) " answer
  case $answer in
    y )
      stop_daemon_proc
      purge_images
      prune_docker_imgs
      prune_docker_vols
      echo "[+] Purge completed"
      ;;
    n )
      exit 0
      ;;
    * )
      main
      ;;
    esac
}

E_ARGS=88

##############################
###      *Begin Exec*      ###
##############################

# stop here if being sourced
return 2>/dev/null

# stop on errors
set -o errexit

main
