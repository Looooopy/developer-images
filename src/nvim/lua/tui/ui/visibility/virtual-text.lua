-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local applyConfig
local bind_keys
local register_commands

----------------------------
-- Public function interface
----------------------------
-- http://www.unicode.org/charts/
function M.default_config()
    return  {
        enabled = true,
        register = {
            commands = {
                enabled = true,
                on_register = register_commands,
            },
            key_binds = {
                enabled =true,
                on_bind = bind_keys,
            },
        },
        applyConfig = {
            list = true,
            listchars = {
                eol = '↵',
                nbsp = '␣',
                tab = '⎯⎯⮞',
                trail = '·',
                extends = '▶',
                precedes = '◀',
                space = '·',
            },
            fillchars = 'eob: ',
        },
    }
end

function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    if config.enabled then
        if config.register.commands.enabled then
            config.register.commands.on_register()
        end

        if config.register.key_binds.enabled then
           config.register.key_binds.on_bind()
        end

        applyConfig(config.applyConfig)
    end
end

function M.toggle()
    vim.opt.list = not vim.opt.list:get()
end

function M.show()
    vim.opt.list = true
end

function M.hide()
    vim.opt.list = false
end

--------------------
-- Private functions
--------------------
applyConfig = function(config)
    vim.opt.list = config.list
    vim.opt.listchars = config.listchars
    vim.wo.fillchars= config.fillchars
end

register_commands = function()
    vim.cmd [[
        command! TuiToggleVirtualText lua require'tui.ui.visibility.virtual-text'.toggle()
        command! TuiShowVirtualText lua require'tui.ui.visibility.virtual-text'.show()
        command! TuiHideVirtualText lua require'tui.ui.visibility.virtual-text'.hide()
    ]]
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.register(
        {
            ['tgv'] = {
                t =  {'<cmd>TuiToggleVirtualText<cr>', '🍃 Toggle Virtual Text'},
                s =  {'<cmd>TuiShowVirtualText<cr>', '🍃 Show Virtual Text'},
                h =  {'<cmd>TuiHideVirtualText<cr>', '🍃 Hide Virtual Text'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = nil,
        }
    );
end

-- Return Module
return M
