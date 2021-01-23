#!/bin/bash     
#title          :sh_bootstrap.sh
#desc           :bootstrap a new bash script
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :bash ./sh_bootstrap.sh
#environment    :bash 5.0.17
#===============================================================================

now=$(date +%m/%Y)
divider=$(printf '=%.0s' {1..79})
max_chars=55

function select_title {
    read -p "[+] Enter a name for the new script: " title
    # supplant whitespace
    title=${title// /_}
    # strconv lower
    title=${title,,}
    # add ext if not extant
    [ "${title: -3}" != '.sh' ] && title=${title}.sh
    # check if script exists
    if [ -e "$title" ]; then
        echo "[-] $title already exists. Input a different name"
        select_title
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

select_title
# get description, limit to $max_chars
get_desc_and_validate
# read -p "[+] Enter author name: " author
author="Matthew Zito (goldmund)"
read -p "[+] Enter script version (or enter to default to 1.0.0): " version

[[ "$version" == "" ]] && version="1.0.0"

# create file, write header to said file
printf "%-16s\n\
%-16s%-s\n\
%-16s%-s\n\
%-16s%-s\n\
%-16s%-s\n\
%-16s%-s\n\
%-16s%-s\n\
%-16s%-s\n\
%s\n\n\n" '#!/bin/bash' '#title' ":$title" '#desc' \
":$desc" '#author' ":$author" '#created' ":$now" '#version' \
":$version" '#usage' ":bash ./$title" '#environment' \
":bash $BASH_VERSION" \#$divider > "$title"

# render file exec
chmod +x "$title"
# open w/cursor below header
/usr/bin/clear 
vim +10 "$title"
