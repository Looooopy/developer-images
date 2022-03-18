call plug#begin('~/.vim/plugged')

" Mandatory to get telescope working
Plug 'nvim-lua/popup.nvim'                                                  " Handling popup windows in neovim
Plug 'nvim-lua/plenary.nvim'                                                " Used by telescope and gitsigns
Plug 'nvim-telescope/telescope.nvim'                                        " Fuzzy Finder

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}                 " Highlighting for diffrent coding languages
Plug 'nvim-treesitter/playground'                                           " Show Abstract syntax tree (AST) from treesitter

" Language Server Protocol (LSP) plugins
Plug 'neovim/nvim-lspconfig'                                                " Setup for Server side to given code language suggestion and refactoring
Plug 'Looooopy/lspcontainers.nvim', {'branch':'feature/use-docker-volumes'} " Dockerized Server side to given code language suggestion and refactoring
Plug 'onsails/lspkind-nvim'                                                 " Adds LSP Kind as VSCode (e.g. Class Interface and so on)
Plug 'ray-x/lsp_signature.nvim'                                             " Handles code languages suggestion and refactoring
Plug 'folke/trouble.nvim'                                                   " Display a list from LSP when you got issue in your code.
Plug 'hrsh7th/nvim-cmp'                                                     " Autocomplete engine
Plug 'hrsh7th/vim-vsnip'                                                    " used by nvim-cmp (Snippet engine)
Plug 'hrsh7th/cmp-buffer'                                                   " used by nvim-cmp (Buffer completion source)
Plug 'hrsh7th/cmp-nvim-lsp'                                                 " Autocomplete integrates with LSP
Plug 'hrsh7th/cmp-path'                                                     " Get workingdir for a buffer use
Plug 'jose-elias-alvarez/null-ls.nvim'                                      " Hook into LSP to support things like formatting where it is missing
Plug 'L3MON4D3/LuaSnip'                                                     " used by nvim-cmp (Snippet engine)

" Debugger Adapter Protocol (DAP) plugins
Plug 'mfussenegger/nvim-dap'                                                " Debugger: Handles debugging of program languages
Plug 'rcarriga/nvim-dap-ui'                                                 " Debugger: Handles ui for stack and so on.
Plug 'theHamsta/nvim-dap-virtual-text'                                      " Debugger Extension: Inlines the values for variables as virtual text using treesitter.
Plug 'nvim-telescope/telescope-dap.nvim'                                    " Debugger Extension: Overriding dap internal ui and use telescope instead.
Plug 'jbyuki/one-small-step-for-vimkind'                                    " Debugger Language: lua
"Plug 'Pocco81/DAPInstall.nvim'                                              " [NOT IN_USE] Debugger Installer

" Eye candy (GUI Enhancment)
"   Color scheme
Plug 'kyoz/purify', { 'rtp': 'vim' }                                        " Vim (vivid colors)                                  - :colorschema purify
Plug 'marko-cerovac/material.nvim'                                          " Nvim port from Material (more colors for keywords)  - :colorschema material
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }                          " Nvim color scheme                                   - :colorschema tokyonight

"   Misc
Plug 'norcalli/nvim-colorizer.lua'                                          " Display colors on RGB codes (#FFFFFF)
Plug 'akinsho/bufferline.nvim'                                              " Show a line at top with open buffers
Plug 'wfxr/minimap.vim'                                                     " Minmap, display a minmap of the buffer
Plug 'Xuyuanp/scrollbar.nvim'                                               " Scrollbar, display a scrollbar
Plug 'lewis6991/gitsigns.nvim'                                              " Add git decorations to the buffer
"Plug 'lukas-reineke/indent-blankline.nvim'                                  " Show indentation and and whitespaces line feed (LF)
Plug 'folke/which-key.nvim'                                                 " Display next shortcut key after a while
"Plug 'lazytanuki/nvim-mapper'                                              " Show keybord shortcuts (should one of the first plugin to register to get the keymaps from other plugins)
Plug 'hoob3rt/lualine.nvim'                                                 " Display status line at bottom in nvim
"Plug 'ryanoasis/vim-devicons'

" Editor support extended
Plug 'windwp/nvim-autopairs'                                                " Should add pairs automagically, you type '{' and you get the end '}'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}                         " Ctrl-N like vscode Ctrl+D command
Plug 'winston0410/range-highlight.nvim'                                     " Select multiple lines with commands like :10 (select line 10) :10,15 (select line 10-15)
Plug 'winston0410/cmd-parser.nvim'                                          " Requried by range-highlight.nvim
Plug 'editorconfig/editorconfig-vim'                                        " Add editorconfig support
Plug 'folke/todo-comments.nvim'                                             " Show icons and color highlights on comments: TODO, HACK, PERF, NOTE, FIX, WARNING
Plug 'tversteeg/registers.nvim'                                             " Show content of registers
Plug 'ntpeters/vim-better-whitespace'                                       " Mark invalid whitespace that can be removed
Plug 'AckslD/nvim-neoclip.lua'                                              " Handles a clipboard history (use :Telescope neoclip to see it)

" Tools incorporation
Plug 'kyazdani42/nvim-web-devicons'                                         " used by nvim-tree for file icons
Plug 'kyazdani42/nvim-tree.lua'                                             " File tree explorer
Plug 'akinsho/toggleterm.nvim'                                              " Handles terminal in neovim
Plug 'jeffkreeftmeijer/vim-numbertoggle'                                    " Toggle line numbers
"Plug 'glacambre/firenvim'                                                  " Cool plugin that takes over text areas in brower with a Neovim instance
call plug#end()
