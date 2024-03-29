#!/bin/bash
#desc           :flushes firewall rules
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./flush_iptables.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

flush() {
  # Avoid ssh lock by accepting all traffic
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT
  # Purge firewalls / chains rules
  iptables -F
  # Purge chains
  iptables -X
  # Counters
  iptables -Z
  # Flush nat, mangle
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X
  iptables iptables -t raw -F
  iptables -t raw -X
}

main() {
  read -p "[*] Warning: this script will modify your IP Tables configurations. Continue? (y/n) " answer
  case $answer in
    y )
      if [[ ! -x $TABLES_DIR ]]; then
        echo "[-] \"${TABLES_DIR}\" not found.";
        exit $E_FILENOTFOUND;
      fi

      echo "[+] Flushing IP Tables..."
      flush
      echo "[+] Flush completed."
      ;;
    n )
      exit 0
      ;;
    * )
      main
      ;;
  esac
}

##############################
###        Constants       ###
##############################

# exit codes
ROOT_UID=0
E_NOTROOT=87
E_FILENOTFOUND=2

# vars
TABLES_DIR='/sbin/iptables'

##############################
###      *Begin Exec*      ###
##############################

# stop here if being sourced
return 2>/dev/null

# stop on errors
set -o errexit

if [[ $EUID -ne $ROOT_UID ]]; then
  echo "[-] This script should be run as root.";
  exit $E_NOTROOT;
fi

main
