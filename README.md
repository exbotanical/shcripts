## A collection of bash scripts
```
Author: Matthew T Zito (goldmund)
License: MIT
```

## Contents
- [Inventory](#enum)
    - [Productivity](#prod)
    - [Git Hooks](#hooks)
    - [Logging](#log)
    - [Configuration](#conf)
- [Installation & Usage](#use)

### <a name="enum"></a> Inventory

##### <a name="prod"></a> Productivity

* `git_bootstrap` - bootstrap a new git repository with .gitignore and README files
* `sh_bootstrap` - bootstrap a new bash script with a formatted header, add execute permissions, launch in text editor
* `headerize` - add formatted headers to a script of a variety of interpreters and environments...super flexible tool!! 

##### <a name="hooks"></a> Git Hooks

* `no-env` - catch .env files in the staging area and prevent them from being included in your git commits. includes installer script

##### <a name="log"></a> Logging

* `print_log_events` - print from a given log file only those events executed by the current user

##### <a name="conf"></a> Configuration

* `flush_iptables` - flush all firewall rules, tables, chains, and mangles
* `enable_port_fwd` - enables port forwarding

### <a name="use"></a> Installation & Usage

**Download:** `curl -O https://raw.githubusercontent.com/MatthewZito/sh/master/scripts/<script_name.sh>`

##### no-env | Keep .env files out of your git history
Committing `.env` files is an often devastating albeit easy mistake to make. Use this script to prevent nasty bots or Google Dork script kiddies from snagging API keys (or worse!) from your public repositories.

This package includes a pre-commit hook and an installer script. Once installed, the hook executes *before* you make a git commit; it parses the staging area for any `.env` files. If a `.env` file is found, the commit will be aborted and you'll be notified. 

At this point, you may want to include the `.env` file(s) in your `.gitignore`. If you wish to commit the file(s) anyway, you can bypass the hook with `git commit --no-verify` *or* you can set the option `git config hooks.allowenv true` - the script will then ignore `.env` files until set to `false`.

**Instructions:**
1. Download the hook & installer to your repository root:
`curl -O "https://raw.githubusercontent.com/MatthewZito/sh/master/hooks/no-env/{no-env.sh,installer.sh}"`
2. Add execute permissions to the installer:
`chmod u+rx installer.sh`
3. Execute the installer:
`./installer.sh`