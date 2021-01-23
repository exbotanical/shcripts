#!/usr/bin/env bash
#filename       :sh_bootstrap.sh
#desc           :bootstrap a new bash script
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :./sh_bootstrap.sh
#environment    :bash 5.0.17
#===============================================================================

<<<<<<< HEAD
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
=======
Nl=$'\n'    # Nl is newline
IFS=$Nl     # don't worry about quoting variable expansions except for multiline values

main () {
  local description filename rest=()

  filename=$(get_filename)
  # check if script exists
  while [[ -e $filename ]]; do
    echo "[-] $filename already exists. Input a different name"
    filename=$(get_filename)
  done

  description=$(get_description)
  while (( ${#description} > Max_chars )); do
    echo "[-] The description cannot exceed $Max_chars characters"
    description=$(get_description)
  done

  rest=(
    $(get_author)
    $(get_created)
    $(get_version)
    $(get_usage $filename)
    $(get_environment)
  )

  write_header $filename $description ${rest[*]}
  # render file exec
  chmod +x $filename
  edit_file $filename
}

edit_file () {
  # open w/cursor below header
  /usr/bin/clear
  vim +10 $1
}

get_author () {
  local author

  # read -p "[+] Enter author name: " author
  author="Matthew Zito (goldmund)" # FIXME: make a configuration
  echo $author
}

get_created () {
  date +$Date_format
>>>>>>> 737149b4a0feb320220bd0197350042a21b93fb2
}

get_description () {
  local description

  read -p "[+] Enter script description (max $Max_chars chars): " description
  echo $description
}

get_environment () {
  echo "bash $BASH_VERSION"
}

get_filename () {
  local filename

  read -p "[+] Enter a name for the new script: " filename
  normalize $filename
}

<<<<<<< HEAD
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
=======
get_usage () {
  echo ./$1
}

get_version () {
  local version

  read -p "[+] Enter script version (or enter to default to 1.0.0): " version
  echo ${version:-1.0.0}
}

normalize () {
  local filename=$1

  # supplant whitespace
  filename=${filename//[[:space:]]/_}
  # strconv lower
  filename=${filename,,}
  # add ext if not extant
  echo ${filename%.sh}.sh
}

write_header () {
  local filename=$1 desc=$2 author=$3 created=$4 version=$5 usage=$6 environment=$7

  cat >$filename <<END
#!/usr/bin/env bash
#filename       :$filename
#desc           :$desc
#author         :$author
#created        :$created
#version        :$version
#usage          :$usage
#environment    :$environment
#===============================================================================
END
}

# constants
Date_format=%m/%Y
Max_chars=55

# stop here if being sourced
return 2>/dev/null

# stop on errors and unset variable refs
set -o errexit
set -o nounset

main $*
>>>>>>> 737149b4a0feb320220bd0197350042a21b93fb2
