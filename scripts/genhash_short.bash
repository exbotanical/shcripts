#!/bin/bash     
#title          :genhash_short.bash
#desc           :Generate short hash given key
#author         :Matthew Zito (goldmund)
#created        :01/2021
#version        :1.0.0  
#usage          :bash ./genhash_short.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

Nl=$'\n'
IFS=$Nl

main () {
  local max_chars_calc=$(($Max_out_chars - 1)) uniq_key calc res out 

  uniq_key=$(get_uniq_key)
  while (( ${#uniq_key} > Max_chars | ${#uniq_key} == 0 )); do
    echo "[-] The uniq_key must be between 1 and $Max_chars characters"
    uniq_key=$(get_uniq_key)
  done

  calc="$(echo $(echo '$uniq_key' | openssl base64) | openssl md5)"
  res=(
    $uniq_key 
    ${calc//(stdin)= /}
  )
  
  out=${res[0]}${res[1]}

  echo -e "[*] Hash generated:\n"

  echo -e "${out:0:$max_chars_calc}\n"
}

get_uniq_key () {
  local uniq_key

  read -p "[+] Enter unique key: " uniq_key
  echo $uniq_key
}

Max_chars=9 
Max_out_chars=20

return 2>/dev/null

set -o errexit
set -o nounset

main $*