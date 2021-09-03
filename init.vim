call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'lewis6991/gitsigns.nvim'

:TSInstall bash
:TSInstall c
:TSInstall c_sharp
:TSInstall cmake
:TSInstall cpp
:TSInstall css
:TSInstall dockerfile
:TSInstall go
:TSInstall graphql
:TSInstall html
:TSInstall json
:TSInstall jsonc
:TSInstall lua
:TSInstall python
:TSInstall scss
:TSInstall tsx
:TSInstall typescript
:TSInstall vim
:TSInstall yaml

require "lsp_signature".setup()
require('gitsigns').setup()

call plug#end()

