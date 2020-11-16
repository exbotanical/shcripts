#!/bin/bash
function get_repo_name {
    # this is the name that will be used on GH, or elsewhere
    read -p "[+] Use '$dir_name' as public-facing repo name? (y/n) " answer

    case $answer in
        y )
            repo_name=$dir_name
            ;;
        n )
            read -p "[+] Enter your new repository name: " repo_name
            # default back to curr if invalid opt given
            if [ "$repo_name" = "" ]; then
                repo_name=$dir_name
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
    echo "# $repo_name" > README.md
}

function init_git {
    echo "[+] Initializing a new Git repository in $repo_name..."
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

get_repo_name
create_readme
create_gitignore
init_git

echo "[+] Done"