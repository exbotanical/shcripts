#!/bin/bash     
#title          :genhash_short.sh
#desc           :Generate short hash given key
#author         :Matthew Zito (goldmund)
#created        :01/2021
#version        :1.0.0  
#usage          :bash ./genhash_short.sh
#environment    :bash 5.0.17(1)-release
#===============================================================================

# Configurable Opts
max_chars=9
max_out_char=20


max_calc=$((max_out_char - 1))

function get_key_and_validate {
    ok=0

    while [[ $ok == 0 ]]; do
        read -p "[+] Enter unique key: " uniq_key

        if [ ${#uniq_key} -gt $max_chars ]; then
            echo "[-] The unique key cannot exceed ${max_chars} characters"
            get_key_and_validate
        else
            ok=1
        fi
    done
}

get_key_and_validate

in="$uniq_key$(echo $(echo '$uniq_key' | openssl base64) | openssl md5)"
out=(${in//(stdin)= / })
res=${out[0]}${out[1]}

echo -e "[*] Hash generated:\n"

echo -e "${res:0:$max_out_char}\n"