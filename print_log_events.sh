#!/bin/bash
this_script="$(basename "$0")"

function usage {
    cat <<EOF
Print only the events matching user $USER in a given log file

Usage: ${this_script} OPTION

Options: 
    -h display this usage dialog
    -f specify the filename of the log to process

Examples: 
    ${this_script} -f auth.log
    cat auth.log | ${this_script}
EOF
    exit 0
}

function get_input {
    cat /dev/stdin
}

function proc_input {
    echo "[+] Printing all events"
    get_input | grep -rh $USER | cut -f1,3 -d":"
}

if read -t 0; then
    get_input | proc_input
    exit 0
elif [[ ${@} ]]; then

    while getopts ":hf:" opt; do
        case ${opt} in
            h ) usage ;;
            f )
                cat $OPTARG | proc_input
                exit 0
                ;;
            \? )
                echo -e "Invalid option: -$OPTARG\nTry ${this_script} -h for usage" 1>&2
                exit 1
                ;;
        esac
    done
else
    usage
fi
