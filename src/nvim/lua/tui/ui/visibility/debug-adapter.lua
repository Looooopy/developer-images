-- Module
local M = {}

-- https://github.com/theHamsta/nvim-dap-virtual-text

--------------------------------
-- Forward function declarations
--------------------------------
local applyConfig
local bind_keys
local create_highlight_dap_ui
local register_commands
local set_highlighs_icons_chars_dap_ui

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
            ui = {
                enabled = true,
                config = {}
            },
            virtual_text = {
                enabled = true,
                config = {}
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

        applyConfig(config.applyConfig)
    end
end

function M.toggle()
    require("dapui").toggle()
end

function M.show()
    require('dapui').open()
end

function M.hide()
    require('dapui').close()
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.cmd [[
      command! TuiToggleDebug lua require('tui.ui.visibility.debug-adapter').toggle()
      command! TuiShowDebug lua require('tui.ui.visibility.debug-adapter').show()
      command! TuiHideDebug lua require('tui.ui.visibility.debug-adapter').hide()
    ]]
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    wk.register(
        {
            -- (T)oggle (G)roup (D)ebug Adapter Protocol
            ['tgd'] = {
                t =  {'<cmd>TuiToggleDebug<cr>',    '🍃 Toggle Debug Adapter UI (Debug)'},
                s =  {'<cmd>TuiShowDebug<cr>',      '🍃 Show Debug Adapter UI (Debug)'},
                h =  {'<cmd>TuiHideDebug<cr>',      '🍃 Hide Debug Adapter UI (Debug)'},
            },
            -- (D)ebug
            ['d'] = {
                d = { '<cmd>lua require("dap").continue()<cr>',             '🍃 launch/resume' },
                b = { '<cmd>lua require("dap").toggle_breakpoint()<cr>',    '🍃 Toggle breakpoint' },
                h = { '<cmd>lua require("dap").step_over()<cr>',            '🍃 Step over' },
                l = { '<cmd>lua require("dap").step_into()<cr>',            '🍃 Step into' },
                g = { '<cmd>lua require("dap").repl.open()<cr>',            '🍃 Open Repl (type exit to close)' },
                t = { '<cmd>TuiToggleDebug<cr>',                            '🍃 Toggle Debug Adapter UI' },
            }
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = nil,
        }
    );
end

create_highlight_dap_ui = function()
    vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
    vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
    vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)
end

set_highlighs_icons_chars_dap_ui = function ()
    vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })
end

applyConfig = function(config)
    -- Prereq: require("dap").setup(...)
    if config.ui.enabled then
        require("dapui").setup(config.ui.config)
        create_highlight_dap_ui()
        set_highlighs_icons_chars_dap_ui()
    end
    if config.virtual_text.enabled then
        require("nvim-dap-virtual-text").setup(config.virtual_text.config)
    end
end

-- Return Module
return M
