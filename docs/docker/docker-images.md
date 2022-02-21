# Docker images

Try to update what each image containing in the way of binaries and plugins.

## base-developer

Is an image based on alpine.

It includes these standard packages

| Packages                                              | Required by       |
| ----------------------------------------------------- | ----------------- |
| [git](https://git-scm.com/download/linux)             | Fetch code        |
| [openssh-client](https://www.openssh.com/manual.html) | Git               |
| [iputils](https://github.com/iputils/iputils/)        | Ping none root    |
| [curl](https://curl.se/docs/)                         | Fetch code/config |
| [sed](https://www.gnu.org/software/sed/)              | Parse config      |
| [jq](https://stedolan.github.io/jq/manual/)           | Parse config      |
| [htop](https://htop.dev/)                             | What's running    |
| [neofetch](https://github.com/dylanaraps/neofetch)    | System info       |
| [cmatrix](https://github.com/abishekvashok/cmatrix)   | Nerd standard     |

## nvim-developer

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
   | [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)                 | Enable debugging   |                     |                                                      |
   | [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)   |                    | nvim-tree           |                                                      |
   | [nvim-lua/popup.nvim](https://github.com/nvim-lua/popup.nvim)                     |                    | telescope           |                                                      |
   | [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                 |                    | telescope, gitsigns |                                                      |
   | [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip)                         |                    | nvim-cmp            |                                                      |
   | [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                       |                    | nvim-cmp            |                                                      |

## tmux-developer

The image is based on `base-developer` and includes

| Packages                                                                                | Required by         | Using          |
| --------------------------------------------------------------------------------------- | ------------------- | -------------- |
| [tmux](https://github.com/tmux/tmux)                                                    |                     |                |
| [openssh-server](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/openssh-server) | tmux share sessions | /usr/sbin/sshd |
| [openrc](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/openrc)                 | start ssh server    | /bin/rc-status |
| [procps](https://pkgs.alpinelinux.org/package/v3.14/main/x86_64/procps)                 | tmux \_username     | /bin/ps        |
