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
function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default(), config or {})

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

function M.default()
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
            diagnostics = {
                enable = true,
                -- -- default
                -- icons = {
                --   hint = "",
                --   info = "",
                --   warning = "",
                --   error = "",
                -- },
            },
            open_on_setup = true,
            update_to_buf_dir   = {
                enable    = true,
                -- false by default, opens the tree when typing `nvim $DIR` or `nvim`
                auto_open = true,
            },
            update_focused_file = {
                enable      = false,
                -- false by default, will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
                update_cwd = true,
                ignore_list = {
                    'startify', 'dashboard'
                }
            },
            fileters = {
                dotfiles = false,
                custom = {
                    ".git",
                    "node_modules",
                    ".cache"
                }
            },
            actions = {
                open_file = {
                    window_picker = {
                        exclude = {
                            filetype = {
                                "notify",
                                "packer",
                                "qf",
                                "minimap"
                            }
                        }
                    }
                }
            }
        },
    }
end

function M.toggle()
    require('nvim-tree').toggle(false,false)
end

function M.show()
    require('nvim-tree').open()
    vim.cmd('wincmd p') -- Update nvim tree so is get content
end

function M.hide()
    require('nvim-tree.view').close()
end

--------------------
-- Private functions
--------------------
register_commands = function()
    vim.cmd [[
      command! TuiToggleFileTree lua require'tui.ui.file-tree'.toggle()
      command! TuiShowFileTree lua require'tui.ui.file-tree'.show()
      command! TuiHideFileTree lua require'tui.ui.file-tree'.hide()
    ]]
end

bind_keys = function()
    local wk = require('which-key')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')

    -- toggle group minimap (toggle, show, hide)
    wk.register(
        {
            -- Toggle Group FileTree
            ['tgf'] = {
                        t =  {'<cmd>TuiToggleDebug<cr>', '🍃 Toggle File-tree'},
                        s =  {'<cmd>TuiShowDebug<cr>', '🍃 Show File-tree'},
                        h =  {'<cmd>TuiHideDebug<cr>', '🍃 Hide File-tree'},
            },
            -- name = 'Files',
            ['fh'] = { '<cmd>NvimTreeFocus<cr>', '🍃 Focus (NvimTree)' },
            ['fj'] = { '<cmd>NvimTreeFindFile<cr>', '🍃 Find (NvimTree)' },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = b.all_buffers,
        }
    );
end

applyConfig = function(config)
    require('nvim-tree').setup(config)
end

-- Return Module
return M
