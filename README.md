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

### nvim-developer

The image is based on `base-developer` and includes

1. vim-plug to manage plugins

2. Plugins [init.vim](./initvim):

   - nvim-telescope/telescope.nvim
   - nvim-lua/popup.nvim
   - nvim-lua/plenary.nvim

### tmux-developer

The image is based on `base-developer` and includes

    - tmux
    - openssh-server

### vscode-developer

This image is only working on linux so i have disabled it until futher notice, beacuse i am running things in MacOS.

> Mabe it is possible to run in MacOS, but need more investigation.

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
