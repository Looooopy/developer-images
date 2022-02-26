local shortcuts = require('shortcuts')
local m = require('constants.vim-mode')
local wk = require('which-key')

-- Leader commands
wk.register(
  {
    t = {
      name = 'Gui toggle',
      h = {'<cmd>NvimTreeToggle<cr>', 'Hide all'},
      s = {'<cmd>NvimTreeClose<cr>', 'Show all'},
    },
    d = {
      name = 'Debug',
    },
    f = {
      name = 'Files',
    },
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);
