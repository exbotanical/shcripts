#!/bin/bash     
#title          :no-env pre-commit hook installer
#desc           :install no-env pre-commit hook
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0  
#usage          :bash ./installer.sh
#environment    :bash 5.0.17(1)-release
#===============================================================================

# preliminary checks
[[ ! -e .git ]] && { 
    echo "[-] Please run this script in the same root as your .git directory"; 
    exit 1;
}

[[ ! -e .git/hooks/ ]] && {
    echo "[-] Git hooks directory not found"; 
    exit 1;
}

[[ ! -f no-env.sh ]] && {
    echo "[-] The no-env git hook was not found.";
    exit 1;
}

[[ -e .git/hooks/pre-commit ]] && {
    echo "[-] A precommit hook already exists in this repository. Disable it to run this installer.";
    exit 1;
}

# install as pre-commit hook
mv no-env.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
echo "[+] no-env pre-commit hook has been installed."
exit 0
