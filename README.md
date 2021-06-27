# Developer images

Setup a docker container with all essential binaries to do some code editing.

## Build image

If you wish to build all images, just run

    docker-compose build

If you wish to build a specific image, run one or more of the options

    docker-compose build [options]

### Options

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

    git
    openssh-client
    curl

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
> * TMUX
>
>   * Add common plugins
>   * configure it to be able to store sessions on a volume

### vscode-developer

This image is only working on linux so i have disabled it until futher notice, beacuse i am running things in MacOS.

Read more here: https://daksh-jain00.medium.com/running-gui-app-vscode-in-a-docker-container-9162a8822c63

> Mabe it is possible to run in MacOS, but need more investigation.

### rider-developer

> Not done anything on this yet more than some investigation.

#### Linux: prerequisites

#### For regular .NET or Mono applications

install the latest stable Mono release from http://www.mono-project.com/download/.

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

## Run containers

### neovim

Run specific version

    docker-compose run nvim-developer_specific

Run latest version

    docker-compose run nvim-developer_latest

### tmux

Run specific version

    docker-compose run tmux-developer_specific

Run latest version

    docker-compose run tmux-developer_latest
