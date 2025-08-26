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

-- Visbility Libs (Support show(), hide() and toggle() functions)
local VisibilityLibs = {
    'tui.ui.visibility.debug-adapter',
    'tui.ui.visibility.virtual-text',
    'tui.ui.visibility.file-tree',
    'tui.ui.visibility.terminal',
    'tui.ui.visibility.minimap',
}

----------------------------
-- Public function interface
----------------------------
M.default_config = function()
    return {
        -- Visbility Libs (Support show(), hide() and toggle() functions)
        virtual_text = require('tui.ui.visibility.virtual-text').default_config(),
        minimapt = require('tui.ui.visibility.minimap').default_config(),
        terminal = require('tui.ui.visibility.terminal').default_config(),
        file_tree = require('tui.ui.visibility.file-tree').default_config(),
        debug_adapter = require('tui.ui.visibility.debug-adapter').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    -- Visbility (Support show(), hide() and toggle() functions)
    require('tui.ui.visibility.virtual-text').setup(config.virtual_text)
    require('tui.ui.visibility.minimap').setup(config.minimapt)
    require('tui.ui.visibility.terminal').setup(config.terminal)
    require('tui.ui.visibility.file-tree').setup(config.file_tree)
    require('tui.ui.visibility.debug-adapter').setup(config.debug_adapter)

    -- Register new vim commands
    register_commands()

    -- register new key bindings
    register_keys()
end


M.toggleAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'toggle',
            requiredLibs = VisibilityLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

M.hideAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'hide',
            requiredLibs = VisibilityLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

M.showAll = function(excludeDapValue)
    ui_hide_show_or_toggle_all(
        {
            funcName = 'show',
            requiredLibs = VisibilityLibs,
            excludeDapValue = excludeDapValue,
        }
    )
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.api.nvim_create_user_command('TuiHideAll', 'lua require("tui.ui.visibility").hideAll(false)', {})
    vim.api.nvim_create_user_command('TuiShowAll', 'lua require("tui.ui.visibility").showAll(false)', {})
    vim.api.nvim_create_user_command('TuiToggleAll', 'lua require("tui.ui.visibility").toggleAll(false)', {})
    vim.api.nvim_create_user_command('TuiHideAllButDap', 'lua require("tui.ui.visibility").hideAll(true)', {})
    vim.api.nvim_create_user_command('TuiShowAllButDap', 'lua require("tui.ui.visibility").showAll(true)', {})
    vim.api.nvim_create_user_command('TuiToggleAllButDap', 'lua require("tui.ui.visibility").toggleAll(true)', {})
end

register_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- Register Names
    wk.add(
        {
            --c = {
                -- name = 'Clipboard',
            --},
            -- see lua/tui/ui/debug-adapter.lua
            { '<leader>d', name = 'Debug' },
            -- Files
            { '<leader>f', name = 'Files' },
            { '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', desc = '🍃 Find files (Telescope)' },
            { '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>',  desc = '🍃 Live grep (Telescope)' },
            { '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>',  desc = '🍃 Find buffer (Telescope)' },
            { '<leader>fb', '<cmd>lua require("telescope.builtin").help_tags()<cr>',  desc = '🍃 Find helptags (Telescope)' },
            { '<leader>t', name = 'Tui toggle' },
            { '<leader>tt', '<cmd>TuiToggleAllButDap<cr>',  desc = '🍃 Toggle all'},
            { '<leader>th', '<cmd>TuiHideAll<cr>',          desc = '🍃 Hide all'},
            { '<leader>ts', '<cmd>TuiShowAllButDap<cr>',    desc = '🍃 Show all'},
            { '<leader>tg', name = 'Group / Specific'},
            { '<leader>tgm', name = 'Minimap' },
            { '<leader>tgmf', name = 'File Tree' },
            { '<leader>tgms', name = 'Statusline' },
            { '<leader>tgmh', name = 'Syntax Highlighting'},
            { '<leader>tgmt', name = 'Terminal' },
            -- { '<leader>tgmg', name = 'Git' },
            { '<leader>tgmd', name = 'Debug' },
            { '<leader>tgmv', name = 'Virtual Text'},
        },
        {
            mode = m.normal,
            buffer = b.all_buffers,
        }
    );
end

ui_hide_show_or_toggle_single = function(config)
    local executionString='return require("'..config.requiredLib..'").'..config.funcName..'()'

    if 'tui.ui.visibility.debug-adapter' == config.requiredLib then
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
