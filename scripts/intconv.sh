#!/bin/bash     
#title          :intconv.sh
#desc           :conv hex, binary to decimal
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :bash ./intconv.sh
#environment    :bash 5.0.17(1)-release
#===============================================================================

this_script="$(basename "$0")"

function usage {
    cat <<EOF
Convert binary or hexadecimal values to decimal

Usage: ${this_script} OPTION [ARG]

Options: 
    -b convert a binary value
    -h convert a hexadecimal value

Examples: 
    ${this_script} -b 00011010
    ${this_script} -h A0B1FF
EOF
    exit 0
}

while getopts ":b:h:" opt; do
    case ${opt} in
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

