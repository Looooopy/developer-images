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

call plug#end()

" Initialise Plugins
lua <<EOF
    -- [[ LSP Initialise ]]
    require "lsp_signature".setup()
    -- [[ Git Signs Initialise ]]
    require('gitsigns').setup()
EOF

