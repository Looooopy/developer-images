# Developer images

This project aims to setup docker containers with all essential binaries to do

  * Code editing

  * Machine configuration through a terminal

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

| Options                 | Description                    | Note                           | Image Size |
| ----------------------- | ------------------------------ | ------------------------------ | ---------- |
| base-developer          | Build both specific and latest | Base image not intended to run |            |
| base-developer_specific | Build specific based on .env   | Base image not intended to run | 25.8MB     |
| base-developer_latest   | Build latest alpine            | Base image not intended to run | 25.8MB     |
| nvim-developer          | Build both specific and latest |                                |            |
| nvim-developer_specific | Build specific based on .env   |                                | 73.7MB     |
| nvim-developer_latest   | Build on latest base-developer |                                | 73.7MB     |
| tmux-developer          | Build both specific and latest |                                |            |
| tmux-developer_specific | Build specific based on .env   |                                | 31.5MB     |
| tmux-developer_latest   | Build on latest base-developer |                                | 31.5MB     |


## Build image

If you wish to build all images, just run

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build

If you wish to build a specific image, run one or more of the [options](#options)

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build [options]

### Environment

Is defined in .env file

| Env                     | Value         | Description                                |
| ----------------------- | ------------- | ------------------------------------------ |
| ALPINE_TAG              | 3.9           | Base image for base-developer              |
| NEOVIM_DOCKER_TAG       | nightly       | Tag nvim-developer specific                |
| NEOVIM_GIT_TAG          | nightly       | Checkout git branch nvim                   |
| TMUX_GIT_TAG            | 3.2a          | Checkout git branch tmux                   |
| TMUX_DOCKER_TAG         | 3.2a          | Tag tmux-developer specific                |
| STD_XDG_DATA_HOME       | /root/.data   | Used by both tmux and nvim                 |
| STD_XDG_CONFIG_HOME     | /root/.config | Used by both tmux and nvim                 |
| DOCKER_REGISTY_AND_PATH | docker.io/    | General prefix to docker registry and path |

### base-developer

Is an image based on alpine.

It includes standard things as;

    [git](https://git-scm.com/download/linux)
    [openssh-client](https://www.openssh.com/manual.html)
    [curl](https://curl.se/docs/)
    [sed](https://www.gnu.org/software/sed/)
    [jq](https://stedolan.github.io/jq/manual/)
    [htop](https://htop.dev/)
    [neofetch](https://github.com/dylanaraps/neofetch)
    [cmatrix](https://github.com/abishekvashok/cmatrix) --> Standard beacuse you are a NERD

> TODO
>
> * Generate/Pickup ssh keys for github

### nvim-developer

The image is based on `base-developer` and includes

1. [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins

2. Plugins [init.vim](./initvim):

   * [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
   * [nvim-lua/popup.nvim](https://github.com/nvim-lua/popup.nvim) - required by telescope
   * [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - required by telescope

### tmux-developer

The image is based on `base-developer` and includes

    - tmux
    - openssh-server

> TODO
>
> * SSH
>
>   * configure ssh server
>   * generate ssh keys
>   * start ssh server
>

#### Troubleshooting

When you notice that you bash prompt do not accept inputs, thats probably beacuase you have accedental turn off flow control by keyboard shortcuts ```Ctrl + q```


You can turn on flow control by pressing ```Ctrl + q```, which will allow you to see what you are typing again.


> I had to allow tty to disable flow control and that in this turn of the functionality to exit docker container with ```Ctrl + q```
> You need to type exit in shell to terminate the docker container or just use ```<tmux prefix> + d```


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
