#!/bin/bash     
#title          :logging_server.sh
#desc           :a logging server
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./logging_server.sh
#environment    :bash 5.0.17(1)-release
#===============================================================================
touch log.txt

while true; do
    nc -l 5000 > >(
        while read -r rq; do
            printf '%s' "$(echo $rq | tr '\r\n' ' ' | tr -d '-')" >> log.txt
            q=$(echo $rq | tr -d '\r\n')           
        
            if echo "$q" | grep -qE '^GET /'; then

                echo "Request: GET"

            elif echo "$q" | grep -qE '^POST /'; then

                echo "Request: POST"

            fi
        done
    echo "" >> log.txt
    )
done

