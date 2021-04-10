#!/bin/bash
#title          :headerize.bash
#desc           :add headers to a script
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./headerize.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

# FIXME
# TODO rewrite this

Nl=$'\n'
IFS=$Nl

now=$(date +%m/%Y)
divider=$(printf '=%.0s' {1..79})
max_chars=55

function get_script_name {
    read -p "[+] Enter the full script name (with extension): " title
    # supplant whitespace
    title=${title// /_}
    # strconv lower
    title=${title,,}

    # check if script exists
    if [ ! -e "$title" ]; then
        read -p "[*] ${title} does not exist. Create it? (y/n) :" answer

        case $answer in
            y )
                touch $title
                echo "[+] Created $title"
                ;;
            n )
                echo "[*] Exiting..."
                exit 0
                ;;
        esac
    fi
}

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
    if [[ "$env_version" == "-1" || "$env_version" == "" ]]; then
        echo "[-] ${env} version not found, writing placeholder..."
        env_version="0.0.0-development"
    fi
}

# get title
get_script_name

# get env
get_env_and_validate

# get description, limit to $max_chars
get_desc_and_validate

# read -p "[+] Enter author name: " author
author="Matthew Zito (goldmund)"

# get script version
read -p "[+] Enter script version (or enter to default to 1.0.0): " version
[[ $version == "" ]] && version="1.0.0"

# # append header to beginning of file

echo "[+] Formatting script with headers..."

headerpfx=(
'#environment'
'#usage'
'#version'
'#created'
'#author'
'#desc'
'#title'
)

headerval=(
":${env} ${env_version}"
":./$title"
":$version"
":$now"
":$author"
":$desc"
":$title"
)

# write divider
sed -i "1s/^/$(printf '%s\n\n\n' "\#${divider}")\n/" $title

# write fields
for ((i=0; i < ${#headerpfx[@]}; i++)); do
  # use var expansion in headervals to escape possible backslashes
  sed -i "1s/^/$(printf '%-16s%-8s\n' "${headerpfx[i]}" "${headerval[i]//\//\\/}")\n/" $title
done;

# write shebang
sed -i "1s/^/$(printf '%-16s\n' "${shebang//\//\\/}")\n/" $title
