local shortcuts = require('shortcuts')
local m = require('constants.vim-mode')
local wk = require('which-key')

-- Leader commands
wk.register(
  {
    t = {
      name = 'Tui toggle',
      -- see terminal-user-interface/tui.lua
    },
    d = {
      name = 'Debug',
      -- see config/nvim-dap.lua
    },
    f = {
      name = 'Files',
      -- see config/telescope.lua
    },
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);
