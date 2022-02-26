local wk = require('which-key')
local b = require('constants.buffer')
local m = require('constants.vim-mode')

wk.register(
  {
    f = {
        -- name = 'Files', -- Checkout keymaps.lua
        f = { '<cmd>lua require("telescope.builtin").find_files()<cr>', 'Find files (Telescope)' },
        g = { '<cmd>lua require("telescope.builtin").live_grep()<cr>', 'Live grep (Telescope)' },
        b = { '<cmd>lua require("telescope.builtin").buffers()<cr>', 'Find buffer (Telescope)' },
        b = { '<cmd>lua require("telescope.builtin").help_tags()<cr>', 'Find helptags (Telescope)' },
    }
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);
