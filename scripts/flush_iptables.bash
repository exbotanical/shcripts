#!/bin/bash
#title          :flush_iptables.bash
#desc           :flushes firewall rules
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./flush_iptables.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

tables="/sbin/iptables"

function flush_em {
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

function init {
    read -p "[*] Warning: this script will modify your IP Tables configurations. Continue? (y/n) " answer
    case $answer in
        y )
            [[ ! -x $tables ]] && { echo "[-] \"${tables}\" not found."; exit 1; }
            echo "[+] Flushing IP Tables..."
            flush_em
            echo "[+] Flush completed."
            ;;
        n )
            exit 0
            ;;
        * )
            init
            ;;
    esac
}

[[ $EUID -ne 0 ]] && {
    echo "[-] This script should be run as root."; exit 1; }

init
