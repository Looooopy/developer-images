call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'                                        " used by telescope and gitsigns
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'                                            " used by nvim-cmp
Plug 'hrsh7th/cmp-buffer'                                           " used by nvim-cmp
Plug 'lewis6991/gitsigns.nvim'
Plug 'kyazdani42/nvim-web-devicons'                                 " used by nvim-tree for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/toggleterm.nvim'

call plug#end()

" Initialise Plugins
lua <<EOF
    -- [[ LSP Initialise ]]
    require "lsp_signature".setup()
    -- [[ Git Signs Initialise ]]
    require('gitsigns').setup()

    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
            disable = {},
        },
        indent = {
            enable = false,
            disable = {},
        },
    }

EOF

