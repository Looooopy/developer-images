call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'                                                  " Handling popup windows in neovim
Plug 'nvim-lua/plenary.nvim'                                                " Used by telescope and gitsigns
Plug 'nvim-telescope/telescope.nvim'                                        " Fuzzy Finder
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}                 " Highlighting for diffrent coding languages
Plug 'nvim-treesitter/playground'                                           " Show Abstract syntax tree (AST) from treesitter
Plug 'neovim/nvim-lspconfig'                                                " Setup for Server side to given code language suggestion and refactoring
Plug 'Looooopy/lspcontainers.nvim', {'branch':'feature/use-docker-volumes'} " Dockerized Server side to given code language suggestion and refactoring
Plug 'onsails/lspkind-nvim'                                                 " Adds LSP Kind as VSCode (e.g. Class Interface and so on)
Plug 'ray-x/lsp_signature.nvim'                                             " Handles code languages suggestion and refactoring
"Plug 'folke/trouble.nvim'                                                  " Display a list from LSP when you got issue in your code.
Plug 'hrsh7th/nvim-cmp'                                                     " Autocomplete engine
Plug 'hrsh7th/vim-vsnip'                                                    " used by nvim-cmp (Snippet engine)
Plug 'hrsh7th/cmp-buffer'                                                   " used by nvim-cmp (Buffer completion source)
Plug 'hrsh7th/nvim-lsp'                                                     " Autocomplete integrates with LSP
Plug 'hrsh7th/cmp-nvim-lsp'                                                 " Handle LPS capabilities
Plug 'hrsh7th/cmp-path'                                                     " Get workingdir for a buffer use
Plug 'mfussenegger/nvim-dap'                                                " Debugger: Handles debugging of program languages
Plug 'theHamsta/nvim-dap-virtual-text'                                      " Debugger Extension: Inlines the values for variables as virtual text using treesitter.
Plug 'nvim-telescope/telescope-dap.nvim'                                    " Debugger Extension: Overriding dap internal ui and use telescope instead.
Plug 'jbyuki/one-small-step-for-vimkind'                                    " Debugger Language: lua
Plug 'Pocco81/DAPInstall.nvim'                                              " Debugger Installer
Plug 'windwp/nvim-autopairs'                                                " Should add pairs automagically, you type '{' and you get the end '}'
Plug 'lukas-reineke/indent-blankline.nvim'                                  " Show indentation and and whitespaces line feed (LF)
Plug 'editorconfig/editorconfig-vim'                                        " Add editorconfig support
Plug 'winston0410/range-highlight.nvim'                                     " Select multiple lines with commands like :10 (select line 10) :10,15 (select line 10-15)
Plug 'winston0410/cmd-parser.nvim'                                          " Requried by range-highlight.nvim
Plug 'wfxr/minimap.vim'                                                     " Minmap
"Plug 'glacambre/firenvim'                                                  " Cool plugin that takes over text areas in brower with a Neovim instance
Plug 'tversteeg/registers.nvim'                                             " Show content of registers
"Plug 'lazytanuki/nvim-mapper'                                              " Show keybord shortcuts (should one of the first plugin to register to get the keymaps from other plugins)
Plug 'folke/todo-comments.nvim'                                             " Show icons and color highlights on comments: TODO, HACK, PERF, NOTE, FIX, WARNING
Plug 'lewis6991/gitsigns.nvim'                                              " Add git decorations to the buffer
Plug 'kyazdani42/nvim-web-devicons'                                         " used by nvim-tree for file icons
Plug 'kyazdani42/nvim-tree.lua'                                             " File tree explorer
Plug 'akinsho/toggleterm.nvim'                                              " Handles terminal in neovim
Plug 'folke/which-key.nvim'                                                 " Display next shortcut key after a while
Plug 'jeffkreeftmeijer/vim-numbertoggle'                                    " Toggle line numbers
Plug 'marko-cerovac/material.nvim'                                          " Colorscheme for nvim (port from Material)
Plug 'hoob3rt/lualine.nvim'                                                 " Display status line at bottom in nvim
"Plug 'ryanoasis/vim-devicons'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}                         " Ctrl-N like vscode Ctrl+D command
Plug 'ntpeters/vim-better-whitespace'                                       " Mark invalid whitespace that can be removed
Plug 'norcalli/nvim-colorizer.lua'                                          " Display colors on RGB codes (#FFFFFF)
Plug 'AckslD/nvim-neoclip.lua'                                              " Handles a clipboard history (use :Telescope neoclip to see it)

call plug#end()

" standard vim settings
set number
set listchars=eol:↵,nbsp:␣,tab:<->,trail:·,extends:▶,precedes:◀,space:·
set list
set termguicolors " this variable must be enabled for colors to be applied properly

" set fillchars+=vert:\ " Change verical split symbol (default: │ )
highlight VertSplit guibg=white guifg=black

let mapleader =" "

" Configurate and initialize our plugins
" check if docker build has copied the files to config folder
if isdirectory(expand("$XDG_CONFIG_HOME/nvim/config"))
  luafile $XDG_CONFIG_HOME/nvim/config/lsp_signature.lua
  luafile $XDG_CONFIG_HOME/nvim/config/gitsigns.lua
  luafile $XDG_CONFIG_HOME/nvim/config/nvim-treesitter.lua
  luafile $XDG_CONFIG_HOME/nvim/config/which-key.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lualine.lua
  source $XDG_CONFIG_HOME/nvim/config/nvim.tree.vim
  source $XDG_CONFIG_HOME/nvim/config/vim-better-whitespace.vim
  source $XDG_CONFIG_HOME/nvim/config/minimap.vim
  luafile $XDG_CONFIG_HOME/nvim/config/clipboard.lua
  luafile $XDG_CONFIG_HOME/nvim/config/nvim-tree.lua
  luafile $XDG_CONFIG_HOME/nvim/config/nvim-colorizer.lua
  luafile $XDG_CONFIG_HOME/nvim/config/cmp.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lsp_signature.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspconfig.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspcontainers.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspkind.lua
  luafile $XDG_CONFIG_HOME/nvim/config/nvim-dap.lua
  luafile $XDG_CONFIG_HOME/nvim/config/keymap/keymaps.lua
  luafile $XDG_CONFIG_HOME/nvim/config/neoclip.lua
endif

" highlight NvimTreeFolderIcon guifg=red
" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeFolderIcon guibg=blue
highlight DevIconDockerfile guifg=#0077B3
