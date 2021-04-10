#!/bin/bash     
#title          :no-env
#desc           :prevent .env files from being committed
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :see installer
#environment    :bash 5.0.17(1)-release
#===============================================================================

allowenv=$(git config --type=bool hooks.allowenv)

if [[ "$allowenv" != "true" && $(git diff --cached --name-only | grep ".env" | wc -c) != 0 ]]; then
    cat <<\EOF
Error: A .env file has been detected in the staging area.
Add the .env file to your .gitignore to prevent it from being committed. 

If you intended to commit the .env file or files, disable this check via:
    git config hooks.allowenv true
EOF
    exit 1;
fi
