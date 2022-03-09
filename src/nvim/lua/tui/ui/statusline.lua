-- Module
local M = {}

-- [[ Lualine Setup - https://github.com/hoob3rt/lualine.nvim ]]

-- Lualine has sections as shown below.
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
-- Each sections holds it's components e.g. current vim's mode.
-- Custom Lualine https://gist.github.com/hoob3rt/b200435a765ca18f09f83580a606b878

-- [[ Available Commands ]]

-- NONE
-- Read more about it
-- :help lualine

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
function M.default()
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
                config = {
                    options = {
                        theme = 'gruvbox-material',
                        icons_enabled = true,
                        component_separators = {'', ''},
                        section_separators = {'', ''},
                        disabled_filetypes = {}
                    },
                    sections = {
                        lualine_a = {'mode'},
                        lualine_b = {'branch'},
                        lualine_c = {'filename'},
                        lualine_x = {'encoding', 'fileformat', 'filetype'},
                        lualine_y = {'progress'},
                        lualine_z = {'location'}
                    },
                    inactive_sections = {
                        lualine_a = {},
                        lualine_b = {},
                        lualine_c = {'filename'},
                        lualine_x = {'location'},
                        lualine_y = {},
                        lualine_z = {}
                    },
                    tabline = {},
                    extensions = {}
                }
            },
        },
    };
end

function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default(), config or {})

    if config.enabled then
        -- if config.register.commands.enabled then
        --     config.register.commands.on_register()
        -- end

        -- if config.register.key_binds.enabled then
        --    config.register.key_binds.on_bind()
        -- end

        applyConfig(config.applyConfig)
    end
end

function M.toggle()
    -- require("dapui").toggle()
end

function M.show()
    -- require('dapui').open()
end

function M.hide()
    -- require('dapui').close()
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.cmd [[
      command! TuiToggleStatusline lua require('tui.ui.statusline').toggle()
      command! TuiShowStatusline lua require('tui.ui.statusline').show()
      command! TuiHideStatusline lua require('tui.ui.statusline').hide()
    ]]
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    wk.register(
        {
            -- (T)oggle (G)roup (S)statusline
            ['tgs'] = {
                t =  {'<cmd>TuiToggleStatusline<cr>',    '🍃 Toggle Statusline'},
                s =  {'<cmd>TuiShowStatusline<cr>',      '🍃 Show Statusline'},
                h =  {'<cmd>TuiHideStatusline<cr>',      '🍃 Hide Statusline'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = nil,
        }
    );
end

applyConfig = function(config)
    -- Prereq: require("dap").setup(...)
    if config.ui.enabled then
        require("lualine").setup(config.ui.config)
    end
end

-- Return Module
return M
