local fn = vim.fn

-- Automatically install packer
-- local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
-- if fn.empty(fn.glob(install_path)) > 0 then
--   PACKER_BOOTSTRAP = fn.system {
--     "git",
--     "clone",
--     "--depth",
--     "1",
--     "https://github.com/wbthomason/packer.nvim",
--     install_path,
--   }
--   print "Installing packer close and reopen Neovim..."
--   vim.cmd [[packadd packer.nvim]]
-- end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
-- local status_ok, packer = pcall(require, "packer")
-- if not status_ok then
--   return
-- end

-- Have packer use a popup window
-- packer.init {
--   display = {
--     open_fn = function()
--       return require("packer.util").float { border = "rounded" }
--     end,
--   },
-- }


return require('packer').startup(
    function(use)
        use 'wbthomason/packer.nvim'

        use {
            'nvim-telescope/telescope.nvim',                                             -- Fuzzy Finder
            requires = {
                { 'nvim-lua/popup.nvim' },                                              -- Handling popup windows in neovim
                { 'nvim-lua/plenary.nvim' }
            },
        }

        use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }                    -- Highlighting for diffrent coding languages
        use { 'nvim-treesitter/playground' }                                            -- Show Abstract syntax tree (AST) from treesitter

        -- Language Server Protocol (LSP) plugins
        use { 'neovim/nvim-lspconfig' }                                                 -- Setup for Server side to given code language suggestion and refactoring
        use { 'lspcontainers/lspcontainers.nvim' }                                      -- Dockerized Server side to given code language suggestion and refactoring
        use { 'onsails/lspkind-nvim'}                                                   -- Adds LSP Kind as VSCode (e.g. Class Interface and so on)
        use { 'ray-x/lsp_signature.nvim' }                                              -- Handles function arguments for cerrtain programrinng languages
        use { 'folke/trouble.nvim' }                                                    -- Display a list from LSP when you got issue in your code.
        use { 'hrsh7th/nvim-cmp' }                                                      -- Autocomplete engine
        use { 'hrsh7th/vim-vsnip' }                                                     -- used by nvim-cmp (Snippet engine)
        use { 'hrsh7th/cmp-buffer' }                                                    -- used by nvim-cmp (Buffer completion source)
        use { 'hrsh7th/cmp-nvim-lsp' }                                                  -- Autocomplete integrates with LSP
        use { 'hrsh7th/cmp-path' }                                                      -- Get workingdir for a buffer use
        use { 'jose-elias-alvarez/null-ls.nvim' }                                       -- Hook into LSP to support things like formatting where it is missing
        use { 'L3MON4D3/LuaSnip' }                                                      -- used by nvim-cmp (Snippet engine)

        -- Debugger Adapter Protocol (DAP) plugins
        use { 'mfussenegger/nvim-dap' }                                                 -- Debugger: Handles debugging of program languages
        use { 'rcarriga/nvim-dap-ui' }                                                  -- Debugger: Handles ui for stack and so on.
        use { 'theHamsta/nvim-dap-virtual-text' }                                       -- Debugger Extension: Inlines the values for variables as virtual text using treesitter.
        use { 'nvim-telescope/telescope-dap.nvim' }                                     -- Debugger Extension: Overriding dap internal ui and use telescope instead.
        use { 'jbyuki/one-small-step-for-vimkind' }                                     -- Debugger Language: lua
        --use { 'Pocco81/DAPInstall.nvim' }                                             -- [NOT IN_USE] Debugger Installer

        -- Eye candy (GUI Enhancment)
        --   Color scheme
        use { 'kyoz/purify', rtp = 'vim',                                               -- Vim (vivid colors)                                  - :colorschema purify
            config = function()
                -- Had to move this to packer bacause the plugins are loaded after init.lua
                -- https://github.com/wbthomason/packer.nvim/issues/554
                -- https://github.com/wbthomason/packer.nvim/pull/402 (Fix in progress)
                require('tui.ui.colourscheme').random()
            end,
          event = 'VimEnter', }
        use { 'marko-cerovac/material.nvim' }                                           -- Nvim port from Material (more colors for keywords)  - :colorschema material
        use { 'folke/tokyonight.nvim', branch = 'main' }                                -- Nvim color scheme                                   - :colorschema tokyonight

        --   Misc
        use { 'norcalli/nvim-colorizer.lua' }                                           -- Display colors on RGB codes (#FFFFFF)
        use { 'akinsho/bufferline.nvim' }                                               -- Show a line at top with open buffers
        use { 'wfxr/minimap.vim' }                                                      -- Minmap, display a minmap of the buffer
        use { 'Xuyuanp/scrollbar.nvim' }                                                -- Scrollbar, display a scrollbar
        use { 'lewis6991/gitsigns.nvim' }                                               -- Add git decorations to the buffer
        --use { 'lukas-reineke/indent-blankline.nvim' }                                 -- Show indentation and and whitespaces line feed (LF)
        use { 'folke/which-key.nvim' }                                                  -- Display next shortcut key after a while
         use { 'hoob3rt/lualine.nvim' }                                                  -- Display status line at bottom in nvim

        -- Editor support extended
        use { 'windwp/nvim-autopairs' }                                                 -- Should add pairs automagically, you type '{' and you get the end '}'
        use { 'mg979/vim-visual-multi', branch = 'master' }                             -- Ctrl-N like vscode Ctrl+D command
        use { 'winston0410/range-highlight.nvim' }                                      -- Select multiple lines with commands like :10 (select line 10) :10,15 (select line 10-15)
        use { 'winston0410/cmd-parser.nvim' }                                           -- Requried by range-highlight.nvim
        use { 'editorconfig/editorconfig-vim' }                                         -- Add editorconfig support
        use { 'folke/todo-comments.nvim' }                                              -- Show icons and color highlights on comments: TODO, HACK, PERF, NOTE, FIX, WARNING
        use { 'tversteeg/registers.nvim' }                                              -- Show content of registers
        use { 'ntpeters/vim-better-whitespace' }                                        -- Mark invalid whitespace that can be removed
        use { 'AckslD/nvim-neoclip.lua' }                                               -- Handles a clipboard history (use :Telescope neoclip to see it)

        -- Tools incorporation
        use { 'kyazdani42/nvim-web-devicons' }                                          -- used by nvim-tree for file icons
        use { 'kyazdani42/nvim-tree.lua' }                                              -- File tree explorer
        use { 'akinsho/toggleterm.nvim' }                                               -- Handles terminal in neovim
        use { 'jeffkreeftmeijer/vim-numbertoggle' }                                     -- Toggle line numbers
        --use { 'glacambre/firenvim' }                                                    -- Cool plugin that takes over text areas in brower with a Neovim instance

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    --   if PACKER_BOOTSTRAP then
    --     require('packer').sync()
    --   end
    end
)
