local wk = require('which-key')
local b = require('constants.buffer')
local m = require('constants.vim-mode')

wk.register(
  {
    t = {
      m = { '<cmd>MinimapToggle<cr>', 'minimap (toggle)' },
    },
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);