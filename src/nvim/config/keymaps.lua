local shortcuts = require("shortcuts")

-- Constants
---- nvim modes
local normal = 'n'
local insert = 'i'
local visual = 'v'

-- Leader commands
shortcuts.map(normal, '<leader>r', ':NvimTreeToggle<CR>')
shortcuts.map(normal, '<leader>n', ':NvimTreeFindFile<CR>')
shortcuts.map(normal, '<leader>m', ':MinimapToggle<CR>')

-- Ctrl commands
shortcuts.map(normal,'<C-e>', ':NvimTreeToggle<CR>')