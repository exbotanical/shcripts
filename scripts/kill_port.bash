#!/usr/bin/env bash
#title          :kill_port
#desc           :kill process running on given port
#author         :Matthew Zito (goldmund)
#created        :02/2021
#version        :1.0.0
#usage          :bash ./kill_port.bash
#environment    :bash 5.0.17
#===============================================================================
IFS=$'\n'

E_ARGS=88
E_BADARG=89

get_pid() {
  local target_port=$1
  echo $(lsof -n -i :$target_port 2>/dev/null | grep LISTEN | awk '{ print $2 }')
}

main() {
  local port=$1

  if [[ ${#port} -lt 4 || ${#port} -gt 5 ]]; then
    panic $E_BADARG "Invalid port number: $port"
  fi

  pid=$(get_pid $port)

  if [[ -z "$pid" ]]; then
    echo "[*] Port not in use"
    exit 0
  fi

  kill $pid 2>/dev/null && echo "[+] Process terminated"

  exit
}

# util
current_time() {
  echo $(date +'%Y-%m-%dT%H:%M:%S%z')
}

panic() {
  local exit_status=$1

  shift # pop exit status; we don't want to print it

  echo "[-] ERROR ($(current_time)): $*" >&2
  exit $exit_status
}

# script begin
if [[ -z "$1" ]]; then
  panic $E_ARGS "A parameter is required"
fi

main $1
