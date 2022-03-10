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
            },
            key_binds = {
                enabled =true,
                on_bind = bind_keys,
            },
        },
    };
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
    end
end


function M.toggle()
    vim.cmd('MinimapToggle')
end

function M.show()
    vim.cmd('Minimap')
end

function M.hide()
    vim.cmd('MinimapClose')
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.cmd [[
        command! TuiToggleMinimap lua require('tui.ui.visibility.minimap').toggle()
        command! TuiShowMinimap lua require('tui.ui.visibility.minimap').show()
        command! TuiHideMinimap lua require('tui.ui.visibility.minimap').hide()
    ]]
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.register(
        {
            ['tgm'] = {
                ['t'] = {'<cmd>TuiToggleMinimap<cr>',   '🍃 Toggle Minimap' },
                ['s'] = {'<cmd>TuiShowMinimap<cr>',     '🍃 Show Minimap' },
                ['h'] = {'<cmd>TuiHideMinimap<cr>',     '🍃 Hide Minimap' },
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
