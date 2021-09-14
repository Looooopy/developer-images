# Developer images

This project aims to setup docker containers with all essential binaries to do

- Code editing

- Machine configuration through a terminal

## Pre req

* [Docker](https://docs.docker.com/engine/install/)

* Windows (bare metal)

    >TODO: Create a script for this

    * Install Chocolatey

        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    * Install Git

        choco install git

    * Install Nerd font

        Install nerd font 'Jet Brains Mono' (required for Neo Vim Plugin: nvim-tree.lua to show correct symbols for code files and folders)

            git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
            cd nerd-fonts
            git sparse-checkout add patched-fonts/JetBrainsMono
            set-executionpolicy remotesigned
            .\install.ps1 JetBrainsMono

    * Install Windows Terminal

        choco install microsoft-windows-terminal

    * Use Nerd font in [Windows Terminal]()

            cd C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
            open settings.json in your txt editor
            add these lines under you WSL (example "name": "Ubuntu-20.04",)
                "fontFace": "JetBrainsMono Nerd Font",
                "fontWeight": "semi-bold",

* MacOS (bare metal)

    >TODO: Create a script for this and document what to do

    * Nerdfonts

    * Use Nerd font in iTerm2


## Running a container

### How to build and run

Collection of scripts to make it more convient to build and run.

### Run

Syntax:

    developer-images>
    ./run [tmux or nvim] [latest or specific] [sh]

Sample:

> Run tmux latest

    developer-images>
    ./run tmux

> Run tmux specific version and bypass start of tmux and just login to shell

    developer-images>
    ./run tmux specific sh

### Build

Syntax:

    developer-images>
    ./build [latest or specific] [base, tmux and/or nvim]

Sample:

> Build all images versions

    developer-images>
    ./build

> Build tmux and nvim latest and not base image (it still need to be prsent)

    developer-images>
    ./build latest tmux nvim

> Build base and tmux latest

    developer-images>
    ./build latest base tmux

### docker-compose instead of script

If you just want to run a specific container with [options](#options)

    developer-images>
    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm [options]

If you jsut want the shell

    developer-images>
    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm [options] sh

## Options

Available build options

| Options                 | Description                    | Note                           | Image Size     |
| ----------------------- | ------------------------------ | ------------------------------ | -------------- |
| base-developer          | Build both specific and latest | Base image not intended to run |                |
| base-developer_specific | Build specific based on .env   | Base image not intended to run | 25.8MB         |
| base-developer_latest   | Build latest alpine            | Base image not intended to run | 25.8MB         |
| nvim-developer          | Build both specific and latest |                                |                |
| nvim-developer_specific | Build specific based on .env   |                                | 267MB (73.7MB) |
| nvim-developer_latest   | Build on latest base-developer |                                | 267MB (73.7MB) |
| tmux-developer          | Build both specific and latest |                                |                |
| tmux-developer_specific | Build specific based on .env   |                                | 31.5MB         |
| tmux-developer_latest   | Build on latest base-developer |                                | 31.5MB         |

> nvim-developer when installed treesitter it requred some build environment (gcc, g++, libstdc++) which maked it larger

## Build image

If you wish to build all images, just run

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build

If you wish to build a specific image, run one or more of the [options](#options)

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build [options]

### Environment

Is defined in .env file

#### Base build args

| Env        | Value    | Description                   |
| ---------- | -------- | ----------------------------- |
| ALPINE_TAG | 3.14     | Base image for base-developer |
| DEV_USER   | dev_user | Create $DEV_USER              |

#### Neovim build args

| Env                 | Value         | Description                 |
| ------------------- | ------------- | --------------------------- |
| NEOVIM_DOCKER_TAG   | master        | Tag nvim-developer specific |
| NEOVIM_GIT_BRANCH   | master        | Checkout git branch nvim    |
| STD_XDG_DATA_HOME   | /root/.data   | Used by both tmux and nvim  |
| STD_XDG_CONFIG_HOME | /root/.config | Used by both tmux and nvim  |

#### TMUX build args

| Env                      | Value         | Description                                   |
| ------------------------ | ------------- | --------------------------------------------- |
| TMUX_GIT_BRANCH          | 3.2a          | Checkout git branch tmux                      |
| TMUX_DOCKER_TAG          | 3.2a          | Tag tmux-developer specific                   |
| TMUX_RESURRECT_PROCESSES | ssh           | Process that will be restored on <prefix> + r |
| STD_XDG_DATA_HOME        | /root/.data   | Used by both tmux and nvim                    |
| STD_XDG_CONFIG_HOME      | /root/.config | Used by both tmux and nvim                    |

#### Runtime args for all images

| Env                             | Value      | Description                                                                                          |
| ------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------- |
| GENERIC_DOCKER_REGISTY_AND_PATH | docker.io/ | General prefix to docker registry and path                                                           |
| GENERIC_VOLUME_TYPE             | container  | If volume will be used from 'container' or 'localhost'                                               |
| GENERIC_PROJECTS_HOST_PATH      |            | Set path to where you have yout projects on the host (used only with GENERIC_VOLUME_TYPE=localhost)  |

### base-developer

Is an image based on alpine.

It includes these standard packages

| Packages                                              | Required by       |
| ----------------------------------------------------- | ----------------- |
| [git](https://git-scm.com/download/linux)             | Fetch code        |
| [openssh-client](https://www.openssh.com/manual.html) | Git               |
| [curl](https://curl.se/docs/)                         | Fetch code/config |
| [sed](https://www.gnu.org/software/sed/)              | Parse config      |
| [jq](https://stedolan.github.io/jq/manual/)           | Parse config      |
| [htop](https://htop.dev/)                             | What's running    |
| [neofetch](https://github.com/dylanaraps/neofetch)    | System info       |
| [cmatrix](https://github.com/abishekvashok/cmatrix)   | Nerd standard     |

> TODO
>
> - Generate/Pickup ssh keys for github

### nvim-developer

The image is based on `base-developer` and includes

1. [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins

2. Plugins [init.vim](./initvim):

   | Packages                                                                          | Description        | Required by         | Start Cmd                                            |
   | --------------------------------------------------------------------------------- | ------------------ | ------------------- | ---------------------------------------------------- |
   | [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder       |                     | :Telescope                                           |
   | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)             | Syntax highligting |                     |                                                      |
   | [ray-x/lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)           | Function signature |                     |                                                      |
   | [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                           | Completion engine  |                     |                                                      |
   | [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)             | Git decoration     |                     | [Active automatic by init script](/nvim/init.vim)    |
   | [akinsho/toggleterm](https://github.com/akinsho/toggleterm.nvim)                  | terminal           |                     | :ToggleTerm size=40 dir=/projects direction=vertical |
   | [kyazdani42/nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)               | project tree       |                     | :NvimTreeOpen                                        |
   | [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)   |                    | nvim-tree           |                                                      |
   | [nvim-lua/popup.nvim](https://github.com/nvim-lua/popup.nvim)                     |                    | telescope           |                                                      |
   | [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                 |                    | telescope, gitsigns |                                                      |
   | [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip)                         |                    | nvim-cmp            |                                                      |
   | [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                       |                    | nvim-cmp            |                                                      |


### tmux-developer

The image is based on `base-developer` and includes

| Packages                                                                                | Required by         | Using          |
| --------------------------------------------------------------------------------------- | ------------------- | -------------- |
| [tmux](https://github.com/tmux/tmux)                                                    |                     |                |
| [openssh-server](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/openssh-server) | tmux share sessions | /usr/sbin/sshd |
| [openrc](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/openrc)                 | start ssh server    | /bin/rc-status |
| [procps](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/procps)                 | tmux \_username     | /bin/ps        |

> TODO
>
> - SSH
>
>   - configure ssh server
>   - generate ssh keys
>   - start ssh server

#### Troubleshooting

When you notice that you bash prompt do not accept inputs, thats probably beacuase you have accedental turn off flow control by keyboard shortcuts `Ctrl + q`

You can turn on flow control by pressing `Ctrl + q`, which will allow you to see what you are typing again.

> I had to allow tty to disable flow control and that in this turn of the functionality to exit docker container with `Ctrl + q`
> You need to type exit in shell to terminate the docker container or just use `<tmux prefix> + d`

### vscode-developer

This image shold only work on linux so i have disabled it until futher notice, i have not tested it myself.

Read more here: https://daksh-jain00.medium.com/running-gui-app-vscode-in-a-docker-container-9162a8822c63

> I am running on MacOS but maybe it is possible to run there, but I need to do more investigation.

### rider-developer

> Have only done some investigation.

#### Linux: prerequisites

#### For regular .NET or Mono applications

Install the latest stable Mono release from http://www.mono-project.com/download/.

#### For .NET Core applications, install .NET Core for Linux

    apt-get update
    apt-get install -y
    apt-transport-https &
    apt-get update && apt-get > install -y dotnet-sdk-5.0

#### Install Raider for linux

    wget https://download.jetbrains.com/rider/JetBrains.Rider-2021.1.3.tar.gz
    tar -xzf JetBrains.Rider-2021.1.3.tar.gz -C /opt
    cd opt/JetBrains\ Rider-2021.1.3/bin/
    ./rider.sh
