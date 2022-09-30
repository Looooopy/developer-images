# Developer images

This project aims to setup docker containers with all essential binaries to do

- Code editing

- Code debugging

- Code linting and fixing

- Machine configuration through a terminal

- Set up the essential to get up on bare metal OS

## Pre req

- [Docker](https://docs.docker.com/engine/install/)

- Windows (bare metal)

  - [Install Chocolatey](/docs/howto/windows/chocolatey.md)

  - [Setup Git with SSH](/docs/howto/windows/git.md)

  - [Setup Windows Terminal](/docs/howto/windows/terminal.md)

  - [Setup SSH Agent](/docs/howto/windows/ssh-agent.md)

  - [Setup Clipboard](/docs/howto/windows/clipboard.md)

- MacOS (bare metal)

  - Nerdfonts

  - Use Nerd font in iTerm2

- Arch Linux (bare metal)

  - yay

  ```bash
  sudo pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  ```

  - Nerd fonts

  ```bash
  yay -S nerd-fonts-meslo
  ```

    - Investigate the name to be used in Alacritty it do only support mono fonts.
    ```bash
    fc-list | grep Meslo | grep Mono
    ```

    ```bash
    /usr/share/fonts/TTF/Meslo LG M DZ Italic Nerd Font Complete Mono.ttf: MesloLGMDZ Nerd Font Mono:style=Italic
    /usr/share/fonts/TTF/Meslo LG S Regular Nerd Font Complete Mono.ttf: MesloLGS Nerd Font Mono:style=Regular
    /usr/share/fonts/TTF/Meslo LG L DZ Italic Nerd Font Complete Mono.ttf: MesloLGLDZ Nerd Font Mono:style=Italic
    ...
    ```

    Use the name `MesloLGMDZ Nerd Font Mono` for the regular font in Alacritty.

- Nvim (bare metal)

  Run the script (Work in progress)

  ```bash
  ./scripts/nvim_build_deps_install.sh
  ./scripts/nvim_build_install.sh
  ./scripts/nvim_config_copy.sh
  ```

## Build images or run a container

[Command scripts](/docs/commands/README.md)

### docker-compose instead of script

[docker-compose commands](/docs/docker/docker-compose.md)

## Docker image binaries

Here i try list binaries that get installed in each images

[docker images](/docs/docker/docker-images.md)

## Troubleshooting

[Tmux](/docs/docker/tmux-torubles.md)
