-- Module
local M = {}

-- [[ Available Commands ]]
-- :h minimap-commands

-- Minimap                   Show minimap window [We are using it]
-- MinimapClose              Close minimap window [We are using it]
-- MinimapToggle             Toggle minimap window [We are using it]
-- MinimapRefresh            Force refresh minimap window
-- MinimapUpdateHighlight    Force update minimap highlight
-- MinimapRescan             Force recalculation of minimap scaling ratio

--------------------------------
-- Forward function declarations
--------------------------------
local register_commands
local bind_keys
local set_global_options

----------------------------
-- Public function interface
----------------------------
function M.default_config()
    return {
        enabled = true,
        register = {
            commands = {
                enabled = true,
                on_register = register_commands,
                autocmd = {
                    enabled = true,
                    rules = {
                        show = { when_lines_exceed = 100 }
                    },
                }
            },
            key_binds = {
                enabled = true,
                on_bind = bind_keys,
            },
        },
        minimap = {
            auto_start = 0,
            auto_start_win_enter = 0,
            base_highlight = 'Normal',
            block_buftypes = {'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt', 'toggleterm'},
            block_filetypes = {'fugitive', 'NvimTree', 'tagbar'},
            close_buftypes = {},
            close_filetypes = {'startify', 'netrw', 'vim-plug'},
            git_colors = 1,
            highlight_range = 0,
            highlight_search = 1,
            left = 0,
            width = 10,
            window_width_override_for_scaling = 2147483647,
        }
    };
end

function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    if config.enabled then
        local commands = config.register.commands
        local key_binds = config.register.key_binds

        if commands.enabled then
            commands.on_register(commands.autocmd)
        end

        if key_binds.enabled then
           key_binds.on_bind()
        end

        set_global_options(config.minimap)
    end
end

function M.toggle()
    print('toggle')
    vim.cmd('MinimapToggle')
    vim.cmd('MinimapRefresh')
end

function M.show()
    vim.cmd('Minimap')
    vim.cmd('MinimapRefresh')
end

function M.hide()
    vim.cmd('MinimapClose')
end

set_global_options = function(config)
    for k, v in pairs(config) do
        vim.g['minimap_'..k] = v
    end
end


--------------------
-- Private functions
--------------------
register_commands = function(autocmd)
    if autocmd.enabled then
        vim.api.nvim_create_augroup('TuiShowMinimapOnLongFiles', {})
        vim.api.nvim_create_autocmd('BufEnter', {
            group = 'TuiShowMinimapOnLongFiles',
            callback = function()
                local b = require('constants.buffer')
                local minimap = require('tui.ui.visibility.minimap')
                if vim.bo.filetype ~= 'minimap' then
                    return
                end

                if vim.api.nvim_buf_line_count(b.active_buffer) > autocmd.rules.show.when_lines_exceed then
                    minimap.show()
                else
                    minimap.hide()
                end
            end
        })
    end

    vim.api.nvim_create_user_command('TuiToggleMinimap', 'lua require("tui.ui.visibility.minimap").toggle()', {})
    vim.api.nvim_create_user_command('TuiShowMinimap', 'lua require("tui.ui.visibility.minimap").show()', {})
    vim.api.nvim_create_user_command('TuiHideMinimap', 'lua require("tui.ui.visibility.minimap").hide()', {})
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.add(
        {
                {'tgmt' , '<cmd>TuiToggleMinimap<cr>',   desc = '🍃 Toggle Minimap' },
                {'tgms' , '<cmd>TuiShowMinimap<cr>',     desc = '🍃 Show Minimap' },
                {'tgmh' , '<cmd>TuiHideMinimap<cr>',     desc = '🍃 Hide Minimap' },
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
