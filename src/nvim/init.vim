call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'                                        " used by telescope and gitsigns
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}         " Highlighting for diffrent coding languages
Plug 'nvim-treesitter/playground'                                   " Show Abstract syntax tree (AST) from treesitter
Plug 'neovim/nvim-lspconfig'                                        " Setup for Server side to given code language suggestion and refactoring
Plug 'lspcontainers/lspcontainers.nvim'                             " Dockerized Server side to given code language suggestion and refactoring
Plug 'onsails/lspkind-nvim'                                         " Adds LSP Kind as VSCode (e.g. Class Interface and so on)
Plug 'ray-x/lsp_signature.nvim'                                     " Handles code languages suggestion and refactoring
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'                                            " used by nvim-cmp (Snippet engine)
Plug 'hrsh7th/cmp-buffer'                                           " used by nvim-cmp (Buffer completion source)
Plug 'wfxr/minimap.vim'                                             " Minmap
Plug 'lewis6991/gitsigns.nvim'
Plug 'kyazdani42/nvim-web-devicons'                                 " used by nvim-tree for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/toggleterm.nvim'
Plug 'folke/which-key.nvim'                                         " Display next shortcut key after a while
Plug 'jeffkreeftmeijer/vim-numbertoggle'                            " Toggle line numbers
Plug 'marko-cerovac/material.nvim'
Plug 'hoob3rt/lualine.nvim'                                         " Display status line at bottom in nvim
Plug 'ryanoasis/vim-devicons'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}                 " Ctrl-N like vscode Ctrl+D command
Plug 'ntpeters/vim-better-whitespace'                               " Mark invalid whitespace that can be removed
Plug 'norcalli/nvim-colorizer.lua'                                  " Display colors on RGB codes (#FFFFFF)

call plug#end()

" standard vim settings
set number
set listchars=eol:↵,nbsp:␣,tab:<->,trail:·,extends:▶,precedes:◀,space:·
set list
set termguicolors " this variable must be enabled for colors to be applied properly

" set fillchars+=vert:\ " Change verical split symbol (default: │ )
highlight VertSplit guibg=white guifg=black

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
  luafile $XDG_CONFIG_HOME/nvim/config/nvim-colorizer.lua
  luafile $XDG_CONFIG_HOME/nvim/config/cmp.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lsp_signature.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspconfig.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspcontainers.lua
  luafile $XDG_CONFIG_HOME/nvim/config/lspkind.lua
endif

nnoremap <C-e> NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose and NvimTreeFocus are also available if you need them
" highlight NvimTreeFolderIcon guifg=red
" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeFolderIcon guibg=blue
highlight DevIconDockerfile guifg=#0077B3
