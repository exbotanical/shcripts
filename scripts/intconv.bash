#!/bin/bash
#title          :intconv.bash
#desc           :conv hex, binary to decimal
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./intconv.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

Locale="$(basename "$0")"

usage () {
  cat <<EOF
Convert binary or hexadecimal values to decimal

Usage: ${Locale} OPTION [ARG]

Options:
  -b convert a binary value
  -h convert a hexadecimal value

Examples:
  ${Locale} -b 00011010
  ${Locale} -h A0B1FF
EOF
  exit 0
}

main () {
  while getopts ":b:h:" opt; do
    case "$opt" in
    b )
      echo "$((2#$OPTARG))" 2>/dev/null
      ;;
    h )
      echo "$((16#$OPTARG))" 2>/dev/null
      ;;
    \? )
      usage
      ;;
    esac
  done
}

main $*
