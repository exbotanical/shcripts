## A collection of bash scripts
```
Author: Matthew T Zito (goldmund)
License: MIT
```
## Contents

- [Productivity](#prod)
- [Git Hooks](#hooks)
- [Logging](#log)
- [Configuration](#conf)

### <a name="prod"></a> Productivity

* `git_bootstrap` - bootstrap a new git repository with .gitignore and README files
* `sh_bootstrap` - bootstrap a new bash script with a formatted header, add execute permissions, launch in text editor
* `headerize` - add formatted headers to a script of a variety of interpreters and environments...super flexible tool!! 

### <a name="prod"></a> Git Hooks

* `no-env` - catch .env files in the staging area and prevent them from being included in your git commits. installer script

### <a name="log"></a> Logging

* `print_log_events` - print from a given log file only those events executed by the current user

### <a name="conf"></a> Configuration

* `flush_iptables` - flush all firewall rules, tables, chains, and mangles
* `enable_port_fwd` - enables port forwarding