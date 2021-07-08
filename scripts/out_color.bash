#!/bin/bash
#desc           :echo colored output
#author         :Matthew Zito (goldmund)
#created        :6/2021
#version        :1.0.0
#usage          :bash ./out_color.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================
set -o errexit
set -o nounset

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

DEFAULT='\033[0m'

red () {
  printf "${RED}$@${DEFAULT}"
}

green () {
  printf "${GREEN}$@${DEFAULT}"
}

yellow () {
  printf "${YELLOW}$@${DEFAULT}"
}
