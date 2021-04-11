#!/usr/bin/env bash
#desc           :bootstrap a new bash script
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.2
#usage          :./bash_bootstrap.bash
#environment    :bash 5.0.17
#===============================================================================

Nl=$'\n'
IFS=$Nl

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

  write_header $description ${rest[*]}
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
  echo ${filename%.bash}.bash
}

write_header () {
  local desc=$1 author=$2 created=$3 version=$4 usage=$5 environment=$6

  cat >$filename <<END
#!/usr/bin/env bash
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
