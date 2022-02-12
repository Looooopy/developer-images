# Environment

We are using a [.env](/src/.env) to setup how to build and run our environment

## Base build args

| Env        | Value    | Description                   |
| ---------- | -------- | ----------------------------- |
| ALPINE_TAG | 3.15     | Base image for base-developer |
| DEV_USER   | dev_user | Create $DEV_USER              |

## Neovim build args

| Env                 | Value         | Description                 |
| ------------------- | ------------- | --------------------------- |
| NEOVIM_DOCKER_TAG   | master        | Tag nvim-developer specific |
| NEOVIM_GIT_BRANCH   | master        | Checkout git branch nvim    |
| STD_XDG_DATA_HOME   | /root/.data   | Used by both tmux and nvim  |
| STD_XDG_CONFIG_HOME | /root/.config | Used by both tmux and nvim  |

## TMUX build args

| Env                      | Value         | Description                                   |
| ------------------------ | ------------- | --------------------------------------------- |
| TMUX_GIT_BRANCH          | 3.2a          | Checkout git branch tmux                      |
| TMUX_DOCKER_TAG          | 3.2a          | Tag tmux-developer specific                   |
| TMUX_RESURRECT_PROCESSES | ssh           | Process that will be restored on {prefix} + r |
| STD_XDG_DATA_HOME        | /root/.data   | Used by both tmux and nvim                    |
| STD_XDG_CONFIG_HOME      | /root/.config | Used by both tmux and nvim                    |

## Runtime args for all images

| Env                             | Value      | Description                                                                                          |
| ------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------- |
| GENERIC_DOCKER_REGISTY_AND_PATH | docker.io/ | General prefix to docker registry and path                                                           |
| GENERIC_VOLUME_TYPE             | container  | If volume will be used from 'container' or 'localhost'                                               |
| GENERIC_PROJECTS_HOST_PATH      |            | Set path to where you have yout projects on the host (used only with GENERIC_VOLUME_TYPE=localhost)  |
