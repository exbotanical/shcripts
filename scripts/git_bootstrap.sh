#!/bin/bash     
#title          :git_bootstrap.sh
#desc           :bootstrap a new git repository
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :bash ./git_bootstrap.sh
#environment    :bash 5.0.17
#===============================================================================

function get_repo_name {
    # this is the name that will be used on GH, or elsewhere
    read -p "[+] Use '$1' as public-facing repo name? (y/n) " answer

    case $answer in
        y )
            repo_name=$1
            ;;
        n )
            read -p "[+] Enter your new repository name: " repo_name
            # default back to curr if invalid opt given
            if [ "$repo_name" = "" ]; then
                repo_name=$1
            fi
            ;;
        *)
            get_repo_name
            ;;
    esac
}

function create_readme {
    echo "[+] Creating README..."
    touch README.md
    echo "# $1" > README.md
}

function init_git {
    echo "[+] Initializing a new Git repository in $1..."
    git init
}

function create_gitignore {

    echo "[+] Creating .gitignore..."
    touch .gitignore

    while true; do
        read -p "[+] Enter file name to add to .gitignore (or 'q' to quit): " filename
        if [ $filename = "q" ]; then
            break
        else
            echo $filename >> .gitignore
        fi
    done
}

dir_name=`basename $(pwd)`

get_repo_name $dir_name
create_readme $repo_name
create_gitignore 
init_git $repo_name

echo "[+] Done"