#!/bin/bash     
#title          :headerize.sh
#desc           :add headers to a script
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :bash ./headerize.sh
#environment    :bash 5.0.17(1)-release
#===============================================================================

now=$(date +%m/%Y)
divider=$(printf '=%.0s' {1..79})
max_chars=55
title="$(basename "$0")"

function get_desc_and_validate {
    ok=0

    while [[ $ok == 0 ]]; do
        read -p "[+] Enter script description: " desc

        if [ ${#desc} -gt $max_chars ]; then
            echo "[-] The description cannot exceed ${max_chars} characters"
            get_desc_and_validate
        else
            ok=1
        fi
    done
}

function get_env_and_validate {
    read -p "[+] Enter the name of the interpreter to be used with your script (e.g. 'bash', 'python', 'perl'): " env
     # supplant whitespace
    env=${env// /_}
    # strconv lower
    env=${env,,}

    # TODO handle other edge-case environments
    case $env in
        go )
            echo "[*] Please note that using a shebang with Go is somewhat a workaround..."
            echo "[*] This script will need to be executed as './${title}'"
            shebang="#!/usr/bin/env gorun"
            env_version=$(${env} version 2> /dev/null || echo -1)
            # strip 'go version' prefix
            env_version="${env_version: +13}"
            ;;
        bash )
            env_version=$BASH_VERSION
            shebang="#!/usr/bin/env bash"
            ;;
        *)
            env_version=$(${env} --version 2> /dev/null || echo -1)
            shebang="#!/usr/bin/env ${env}"
            ;;
    esac

    # no version no. found; use placeholder
    if [[ $env_version == "-1" || $env_version == "" ]]; then
        echo "[-] ${env} version not found, writing placeholder..."
        env_version="0.0.0-development"
    fi
}

# get env
get_env_and_validate

# get description, limit to $max_chars
get_desc_and_validate

# read -p "[+] Enter author name: " author
author="Matthew Zito (goldmund)"

# get script version
read -p "[+] Enter script version (or enter to default to 1.0.0): " version
[[ $version == "" ]] && version="1.0.0"

# append header to beginning of file
printf "%-16s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%s\n\n\n" "${shebang}" '#title' ":$title" '#desc' \
":$desc" '#author' ":$author" '#created' ":$now" '#version' \
":$version" '#usage' ":./$title" '#environment' \
":${env} ${env_version}" \#$divider

# echo 'header' | cat - file.txt > temp && mv temp file.txt