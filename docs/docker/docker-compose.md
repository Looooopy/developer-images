# Docker-compose

> Note
>
> This is not updated because I use my own command scripts that do this in the background
>
> I will probably update this documentation later and remove this note.

How to run and build using docker-compose

docker-compose incorperate the [.env file](/src/.env) so update it accoring your needs [More info env](/docs/commands/environment.md)

## Run docker-compose

If you just want to run a specific container with [options](#image-options)

    developer-images>
    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm [options]

If you jsut want the shell

    developer-images>
    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm [options] sh

## Build docker-compose

If you wish to build all images, just run

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build

If you wish to build a specific image, run one or more of the [options](#image-options)

    DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build [options]

## Image Options

Build and run options

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
