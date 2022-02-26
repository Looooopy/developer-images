# How to build and run

Collection of scripts to make it more convient to build, run and prune.

## Prereq

### MacOS

    MacOS do not support long option as --service and so on so we need to install gnu-getopts

    brew install gnu-getopt

Zsh:
    sudo echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
    sudo echo 'export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"' >> ~/.zshrc

bash
    sudo echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.bash_rpofile
    sudo echo 'export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"' >> ~/.bash_rpofile

## Commands

Desciption of available commands

| Command             | Description              |
|---------------------|--------------------------|
| [run](./run.md)     | Run a container          |
| [build](./build.md) | Build images             |
| [prune](./prune.md) | Prune volumes and images |

## Enable more verbose logging

>If you having trouble you can get vebose log outputs by exporting `VERBOSE=yes`

    export VERBOSE=yes

>When you are done and you wish less log outputs just use unset command

    unset VERBOSE
