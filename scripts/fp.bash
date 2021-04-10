#!/usr/bin/env bash
# *light* functional programming in bash

IFS=$'\n'

# not really fp, but including it anyway - get over it
# for_each forea_fn ${arr[*]}
for_each () {
  local fn=$1

  shift

  local -a arr=($@)

  for item in "${arr[@]}"; do
    echo $($fn $item)
  done
}

# map map_fn ${arr[*]}
map () {
  local -a res=()

  local fn=$1

  shift

  local -a arr=($@)

  for (( i=0; i < ${#arr[@]}; i++ )); do
    res[$i]=$($fn ${arr[i]})
  done

  echo "${res[@]}"
}

# filter filter_fn ${arr[*]}
filter () {
  local -a res=()

  local fn="$1"

  shift

  local -a arr=($@)

  for (( i=0; i < ${#arr[@]}; i++ )); do
    $fn ${arr[i]} && res[$i]=${arr[i]}
  done

  echo "${res[@]}"
}

# echo $(echo "${arr[*]}" | map_stream map_fn)
map_stream () {
  local fn=$1
  local arg

  while read -r arg; do
    $fn $arg
  done
}

# echo $(echo "${arr[*]}" | filter_stream filter_fn)
filter_stream () {
  local fn=$1
  local arg

  while read -r arg; do
    $fn $arg && echo $arg
  done
}
