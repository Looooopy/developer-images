local shortcuts = require('shortcuts')
local m = require('constants.vim-mode')

-- Leader commands
shortcuts.map(m.normal, '<leader>r', '<CMD>NvimTreeToggle<CR>')
shortcuts.map(m.normal, '<leader>n', '<CMD>NvimTreeFindFile<CR>')
shortcuts.map(m.normal, '<leader>m', '<CMD>MinimapToggle<CR>')

-- Ctrl commands
shortcuts.map(m.normal,'<C-e>', '<CMD>NvimTreeToggle<CR>')
