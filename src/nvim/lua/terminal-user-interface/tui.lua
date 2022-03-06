local M = {}


function M.toggleAll(excludeDapValue)
    if not excludeDapValue then
        toggleDebug()
    end

    toggleVirtualText()
    toggleFileTree()
    toggleTerminals()
    toggleMinimap()
end

function M.hideAll(excludeDapValue)
    if not excludeDapValue then
        hideDebug()
    end

    hideVirtualText()
    hideFileTree()
    hideTerminals()
    hideMinimap()
end

function M.showAll(excludeDapValue)
    if not excludeDapValue then
        showDebug()
    end
    showVirtualText()
    showFileTree()
    showTerminals()
    showMinimap()
end

function M.toggleTerminals()
    vim.api.cmd('<cmd>ToggleTermToggleAll<cr>')
end

function M.showTerminals()
    vim.cmd('ToggleTerm')
    vim.cmd('2ToggleTerm')
end

function M.hideTerminals()
    local ui = require("toggleterm.ui")
    local terms = require("toggleterm.terminal")
    local terminals = terms.get_all()

    if ui.find_open_windows() then
        for _, term in pairs(terminals) do
        term:close()
        end
    end
end

function M.toggleFileTree()
    require('nvim-tree').toggle(false,false)
end

function M.showFileTree()
    require('nvim-tree').open()
    vim.cmd('wincmd p') -- Update nvim tree so is get content
end

function M.hideFileTree()
    require('nvim-tree.view').close()
end

function M.toggleDebug()
    require('dapui').toggle()
end

function M.showDebug()
    require('dapui').open()
end

function M.hideDebug()
    require('dapui').close()
end

function M.toggleMinimap()
    vim.cmd('MinimapToggle')
end

function M.showMinimap()
    vim.cmd('Minimap')
end

function M.hideMinimap()
    vim.cmd('MinimapClose')
end

function M.toggleVirtualText()
    require('terminal-user-interface.list-chars').toggle()
end

function M.showVirtualText()
    require('terminal-user-interface.list-chars').show()
end

function M.hideVirtualText()
    require('terminal-user-interface.list-chars').hide()
end

local function register_keys()
    local wk = require('which-key')
    local m = require('constants.vim-mode')

    -- Register Names
    wk.register(
        {
            t = {
                --name = 'Tui toggle',
                t = {'<cmd>TuiToggleAllButDap<cr>', 'Toggle all'},
                h = {'<cmd>TuiHideAll<cr>', 'Hide all'},
                s = {'<cmd>TuiShowAllButDap<cr>', 'Show all'},
                g = {
                    name = 'Group / Specific',
                    m = {
                        name = 'Minimap',
                        t =  {'<cmd>TuiToggleMinimap<cr>', 'Toggle (Minimap)'},
                        s =  {'<cmd>TuiShowMinimap<cr>', 'Show (Minimap)'},
                        h =  {'<cmd>TuiHideMinimap<cr>', 'Hide (Minimap)'},
                    },
                    f = {
                        name = 'File Tree',
                        t =  {'<cmd>TuiToggleFileTree<cr>', 'Toggle (File Tree)'},
                        s =  {'<cmd>TuiShowFileTree<cr>', 'Show (File Tree)'},
                        h =  {'<cmd>TuiHideFileTree<cr>', 'Hide (File Tree)'},
                    },
                    t = {
                        name = 'Terminal',
                        t =  {'<cmd>TuiToggleTerminals<cr>', 'Toggle Terminals (Terminal) Short: <C-A>'},
                        s =  {'<cmd>TuiShowTerminals<cr>', 'Show Terminals (Terminal)'},
                        h =  {'<cmd>TuiHideTerminals<cr>', 'Hide Terminals (Terminal) Short: <C-Z>'},
                    },
                    g = {
                        name = 'Git',
                    },
                    d = {
                        name = 'Debug',
                        t =  {'<cmd>TuiToggleDebug<cr>', 'Toggle Debug Adapter UI (Debug)'},
                        s =  {'<cmd>TuiShowDebug<cr>', 'Show Debug Adapter UI (Debug)'},
                        h =  {'<cmd>TuiHideDebug<cr>', 'Hide Debug Adapter UI (Debug)'},
                    },
                    v = {
                        name = 'Virtual Text',
                        t =  {'<cmd>TuiToggleVirtualText<cr>', 'Toggle VirtualText (VirtualText)'},
                        s =  {'<cmd>TuiShowVirtualText<cr>', 'Show VirtualText (VirtualText)'},
                        h =  {'<cmd>TuiHideVirtualText<cr>', 'Hide VirtualText (VirtualText)'},
                    },
                },
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = nil,
        }
    );
end

local function setup_vim_commands()
    vim.cmd [[
      command! TuiHideAll lua require'terminal-user-interface.tui'.hideAll(false)
      command! TuiShowAll lua require'terminal-user-interface.tui'.showAll(false)
      command! TuiToggleAll lua require'terminal-user-interface.tui'.toggleAll(false)
      command! TuiHideAllButDap lua require'terminal-user-interface.tui'.hideAll(true)
      command! TuiShowAllButDap lua require'terminal-user-interface.tui'.showAll(true)
      command! TuiToggleAllButDap lua require'terminal-user-interface.tui'.toggleAll(true)
      command! TuiToggleMinimap lua require'terminal-user-interface.tui'.toggleMinimap()
      command! TuiShowMinimap lua require'terminal-user-interface.tui'.showMinimap()
      command! TuiHideMinimap lua require'terminal-user-interface.tui'.hideMinimap()
      command! TuiToggleFileTree lua require'terminal-user-interface.tui'.toggleFileTree()
      command! TuiShowFileTree lua require'terminal-user-interface.tui'.showFileTree()
      command! TuiHideFileTree lua require'terminal-user-interface.tui'.hideFileTree()
      command! TuiToggleTerminals lua require'terminal-user-interface.tui'.toggleTerminals()
      command! TuiShowTerminals lua require'terminal-user-interface.tui'.showTerminals()
      command! TuiHideTerminals lua require'terminal-user-interface.tui'.hideTerminals()
      command! TuiToggleDebug lua require'terminal-user-interface.tui'.toggleDebug()
      command! TuiShowDebug lua require'terminal-user-interface.tui'.showDebug()
      command! TuiHideDebug lua require'terminal-user-interface.tui'.hideDebug()
      command! TuiToggleVirtualText lua require'terminal-user-interface.tui'.toggleVirtualText()
      command! TuiShowVirtualText lua require'terminal-user-interface.tui'.showVirtualText()
      command! TuiHideVirtualText lua require'terminal-user-interface.tui'.hideVirtualText()
    ]]
end

function M.setup()
    setup_vim_commands()
    register_keys()
end

return M
