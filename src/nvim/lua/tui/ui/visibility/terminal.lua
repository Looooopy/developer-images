-- Module
local M = {}

-- [[ Available Commands ]]
-- Plugin: https://github.com/akinsho/toggleterm.nvim

-- ToggleTermToggleAll       Show terminal if precreated otherwise hide [We are using it]
-- TermExec                  Send to command prompt for excution, eg) 2TermExec cmd="git status" dir=~/<my-repo-path>
-- ToggleTerm                Open or Close a terminal eg) 2ToggleTerm would open a second terminal if ToggleTerm has run before [We are using it]

--------------------------------
-- Forward function declarations
--------------------------------
local applyConfig
local bind_keys
local register_commands

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
        applyConfig = {
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

        applyConfig(config.applyConfig)
    end
end

function M.toggle()
    vim.cmd('ToggleTermToggleAll')
end

function M.show()
    vim.cmd('ToggleTerm')
    vim.cmd('2ToggleTerm')
end

function M.hide()
    local ui = require("toggleterm.ui")
    local terms = require("toggleterm.terminal")
    local terminals = terms.get_all()

    if ui.find_open_windows() then
        for _, term in pairs(terminals) do
        term:close()
        end
    end
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.api.nvim_add_user_command('TuiToggleTerminals', 'lua require("tui.ui.visibility.terminal").toggle()', {})
    vim.api.nvim_add_user_command('TuiShowTerminals', 'lua require("tui.ui.visibility.terminal").show()', {})
    vim.api.nvim_add_user_command('TuiHideTerminals', 'lua require("tui.ui.visibility.terminal").hide()', {})

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.register(
        {
            ['tgt'] = {
                t =  {'<cmd>TuiToggleTerminals<cr>', '🍃 Toggle Terminals (Short: <C-A>)'},
                s =  {'<cmd>TuiShowTerminals<cr>', '🍃 Show Terminals'},
                h =  {'<cmd>TuiHideTerminals<cr>', '🍃 Hide Terminals (Short: <C-Z>)'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = b.all_buffers,
        }
    );

    wk.register(
        {
            ['<C-A>'] = { '<cmd>TuiShowTerminals<cr>',    '🍃 Show terminals' },
            ['<C-Z>'] = { '<cmd>TuiToggleTerminals<cr>',  '🍃 Toggle terminals' },
        },
        {
            mode = m.normal,
            noremap = true,
            silent = true,
            buffer = b.all_buffers
        }
    );
end

applyConfig = function(config)
    require('toggleterm').setup(config)
end

function _G.set_terminal_keymaps()
    local m = require('constants.vim-mode')
    local b = require('constants.buffer')
    local wk = require('which-key')

    local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    -- Leader commands
    wk.register(
        {
            ["<C-h>"]   = { t('<C-\\><C-n><C-W>h'), 'Move: Left (terminal)' },
            ["<C-j>"]   = { t('<C-\\><C-n><C-W>j'), 'Move: Down (terminal)' },
            ["<C-k>"]   = { t('<C-\\><C-n><C-W>k'), 'Move: Up (terminal)' },
            ["<C-l>"]   = { t('<C-\\><C-n><C-W>l'), 'Move: Right (terminal)' },
            ["<Esc>"]   = { t('<C-\\><C-n>'),       'Escape (terminal)'},
            ["<C-Z>"]   = { t('<C-\\><C-n>')..'<cmd>TuiToggleTerminals<cr>',  'Toggle (terminal)'},
        },
        {
            mode = m.terminal,
            noremap = true,
            silent = true,
            buffer = b.active_buffer,
        }
    );
end

-- Return Module
return M
