-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local ui_hide_show_or_toggle_single
local ui_hide_show_or_toggle_all
local register_keys
local register_commands
local default_config

-- Update this list when you add a new lib that support
-- hide() show() and toggle() functions
local ToggleLibs = {
    'tui.ui.debug-adapter',
    'tui.ui.virtual-text',
    'tui.ui.file-tree',
    'tui.ui.terminal',
    'tui.ui.minimap',
    'tui.ui.statusline',
}

----------------------------
-- Public function interface
----------------------------
M.default_config = function()
    return {
        virtual_text = require('tui.ui.virtual-text').default(),
        minimapt = require('tui.ui.minimap').default(),
        terminal = require('tui.ui.terminal').default(),
        file_tree = require('tui.ui.file-tree').default(),
        debug_adapter = require('tui.ui.debug-adapter').default(),
        statusline = require('tui.ui.statusline').default(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.ui.virtual-text').setup(config.virtual_text)
    require('tui.ui.minimap').setup(config.minimapt)
    require('tui.ui.terminal').setup(config.terminal)
    require('tui.ui.file-tree').setup(config.file_tree)
    require('tui.ui.debug-adapter').setup(config.debug_adapter)
    require('tui.ui.statusline').setup(config.statusline)
    register_commands()
    register_keys()
end


M.toggleAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'toggle',
            requiredLibs = ToggleLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

M.hideAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'hide',
            requiredLibs = ToggleLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

M.showAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'show',
            requiredLibs = ToggleLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.cmd [[
      command! TuiHideAll lua require'tui.main'.hideAll(false)
      command! TuiShowAll lua require'tui.main'.showAll(false)
      command! TuiToggleAll lua require'tui.main'.toggleAll(false)
      command! TuiHideAllButDap lua require'tui.main'.hideAll(true)
      command! TuiShowAllButDap lua require'tui.main'.showAll(true)
      command! TuiToggleAllButDap lua require'tui.main'.toggleAll(true)
    ]]
end

register_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- Register Names
    wk.register(
        {
            d = {
                name = 'Debug',
                 -- see lua/tui/ui/debug-adapter.lua
            },
            f = {
                name = 'Files',
                -- see config/telescope.lua
            },
            t = {
                name = 'Tui toggle',
                t = {'<cmd>TuiToggleAllButDap<cr>', '🍃 Toggle all'},
                h = {'<cmd>TuiHideAll<cr>',         '🍃 Hide all'},
                s = {'<cmd>TuiShowAllButDap<cr>',   '🍃 Show all'},
                g = {
                    name = 'Group / Specific',
                    m = {
                         name = 'Minimap',
                    },
                    f = {
                        name = 'File Tree',
                    },
                    t = {
                        name = 'Terminal',
                    },
                    -- g = {
                    --     name = 'Git',
                    -- },
                    d = {
                        name = 'Debug',
                    },
                    v = {
                        name = 'Virtual Text',
                    },
                },
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = b.all_buffers,
        }
    );
end

ui_hide_show_or_toggle_single = function(config)
    local executionString='return require("'..config.requiredLib..'").'..config.funcName..'()'

    if 'tui.ui.debug-adapter' == config.requiredLib then
        if not config.excludeDapValue then
            local executeFunc = loadstring(executionString)
            executeFunc()
        end
    else
        local executeFunc = loadstring(executionString)
        executeFunc()
    end
end

ui_hide_show_or_toggle_all = function(config)
    local single_config = {
        funcName = config.funcName,
        excludeDapValue = config.excludeDapValue,
    }

    for _, requiredLib in ipairs(config.requiredLibs) do
        single_config.requiredLib = requiredLib
        ui_hide_show_or_toggle_single(single_config)
    end
end

-- Return Module
return M
