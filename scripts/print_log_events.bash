#!/bin/bash
#title          :print_log_events.bash
#desc           :print all current user log events
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./print_log_events.bash
#environment    :bash 5.0.17
#===============================================================================

usage () {
  cat <<EOF
Print only the events matching user $USER in a given log file

Usage: ${Locale} OPTION

Options:
  -h display this usage dialog
  -f specify the filename of the log to process

Examples:
  ${Locale} -f auth.log
  cat auth.log | ${Locale}
EOF
  exit 0
}

get_input () {
  echo $(cat /dev/stdin)
}

proc_input () {
  echo "[+] Printing all events"
  get_input | grep -rh $USER | tail -$MAX
}

main () {
  cd "$LOG_DIR"

  if read -t 0; then
    get_input | proc_input
    exit 0
  elif [[ ${@} ]]; then

    while getopts ":hf:" opt; do
      case "$opt" in
        h )
          usage
          ;;
        f )
          cat "$OPTARG" | proc_input
          exit 0
          ;;
        \? )
          echo -e "Invalid option: -$OPTARG\nTry $Locale -h for usage" 1>&2
          exit 1
          ;;
      esac
    done
  else
    usage
  fi
}

LOG_DIR="/var/log"
MAX=100
Locale="$(basename "$0")"

main $*
