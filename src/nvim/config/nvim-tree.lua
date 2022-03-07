require'nvim-tree'.setup {
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
}

local wk = require('which-key')
local m = require('constants.vim-mode')

-- Leader commands
wk.register(
  {
    f = {
        -- name = 'Files',
        h = { '<cmd>NvimTreeFocus<cr>', '🍃 Focus (NvimTree)' },
        j = { '<cmd>NvimTreeFindFile<cr>', '🍃 Find (NvimTree)' },
    },
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);
