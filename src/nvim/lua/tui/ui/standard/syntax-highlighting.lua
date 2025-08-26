-- Module
local M = {}

local register_commands

local _config

function M.setup(config)
    _config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('nvim-treesitter.configs').setup(_config)
end

function M.toggle()
    _config.highlight.enable = not _config.highlight.enable
    require('nvim-treesitter.configs').setup(_config)
    -- Todo some logic to refresh all open buffers without changes
end

function M.show()
    _config.highlight.enable = true
    require('nvim-treesitter.configs').setup(_config)
    -- Todo some logic to refresh all open buffers without changes
end

function M.hide()
    _config.highlight.enable = false
    require('nvim-treesitter.configs').setup(_config)
    -- Todo some logic to refresh all open buffers without changes
end

function M.default_config()
    return {
        highlight = {
            enable = true,
            disable = {},
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = false,
            disable = {'yaml'},
        },
    }
end

register_commands = function()
    vim.api.nvim_create_user_command('TuiToggleSyntaxHighlighting', 'lua require("tui.ui.standard.syntax-highlighting").toggle()', {})
    vim.api.nvim_create_user_command('TuiShowSyntaxHighlighting', 'lua require("tui.ui.standard.syntax-highlighting").show()', {})
    vim.api.nvim_create_user_command('TuiHideSyntaxHighlighting', 'lua require("tui.ui.standard.syntax-highlighting").hide()', {})
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.add(
        {
            -- (T)oggle (G)roup Syntax (H)ighlighting
            ['tgh'] = {
                t =  {'<cmd>TuiToggleSyntaxHighlighting<cr>', '🍃 Toggle Syntax Highlighting'},
                s =  {'<cmd>TuiShowSyntaxHighlighting<cr>', '🍃 Show Syntax Highlighting'},
                h =  {'<cmd>TuiHideSyntaxHighlighting<cr>', '🍃 Hide Syntax Highlighting'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = b.all_buffers,
        }
    );
end

return M
