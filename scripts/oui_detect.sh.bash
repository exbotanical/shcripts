#!/usr/bin/env bash
#desc           :detect the oui vendor prefix of your wifi MAC addr
#author         :Matthew Zito (goldmund)
#created        :08/2021
#version        :1.0.0
#usage          :./oui_detect.sh.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================


OUI=$(ip addr list | grep -w 'link' | awk '{print $2}' | grep -P '^(?!00:00:00)' | grep -P '^(?!fe80)' | tr -d ':' | head -c 6)

curl -sS "http://standards-oui.ieee.org/oui/oui.txt" | grep -i "$OUI" | cut -d')' -f2 | tr -d '\t'
