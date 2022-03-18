-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local applyConfig
local bind_keys
local register_commands
local set_global_options

----------------------------
-- Public function interface
----------------------------
function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    if config.enabled then
        set_global_options(config.globals)

        if config.register.commands.enabled then
            config.register.commands.on_register()
        end

        if config.register.key_binds.enabled then
           config.register.key_binds.on_bind()
        end

        applyConfig(config.applyConfig)
    end
end

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
        globals = {
            respect_buf_cwd = 1,
            refresh_wait = 500,
            special_files = {
                run = 1,
                build = 1,
                prune = 1,
            },
            show_icons = {
                git = 1,
                folders = 1,
                files = 1,
                folder_arrows = 1,
            },
        },
        applyConfig = {
            view = {
                width = 30,
                height = 30,
                hide_root_folder = false,
                side = 'left',
                preserve_window_proportions = false,
                mappings = {
                  custom_only = false,
                  list = {}
                },
                number = false,
                relativenumber = false,
                signcolumn = "yes"
            },
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

applyConfig = function(applyConfig)
    require('nvim-tree').setup(applyConfig)
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
                t =  {'<cmd>TuiToggleFileTree<cr>', '🍃 Toggle File-tree'},
                s =  {'<cmd>TuiShowFileTree<cr>', '🍃 Show File-tree'},
                h =  {'<cmd>TuiHideFileTree<cr>', '🍃 Hide File-tree'},
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

register_commands = function()
    vim.api.nvim_add_user_command('TuiToggleFileTree', 'lua require("tui.ui.visibility.file-tree").toggle()', {})
    vim.api.nvim_add_user_command('TuiShowFileTree', 'lua require("tui.ui.visibility.file-tree").show()', {})
    vim.api.nvim_add_user_command('TuiHideFileTree', 'lua require("tui.ui.visibility.file-tree").hide()', {})
end

set_global_options = function(globals)
    for k, v in pairs(globals) do
        vim.g['nvim_tree_'..k] = v
    end
end

-- Return Module
return M
