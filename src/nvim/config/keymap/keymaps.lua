local shortcuts = require("shortcuts")
local m = require("constants.vim-mode")

-- Leader commands
shortcuts.map(m.normal, '<leader>r', '<CMD>NvimTreeToggle<CR>')
shortcuts.map(m.normal, '<leader>n', '<CMD>NvimTreeFindFile<CR>')
shortcuts.map(m.normal, '<leader>m', '<CMD>MinimapToggle<CR>')

-- Ctrl commands
shortcuts.map(m.normal,'<C-e>', '<CMD>NvimTreeToggle<CR>')

-- All buffers
-- Should probably not be this but for now it will do.
-- shortcuts.map(m.global,'<F5>', "require'osv'.launch()<CR>")
shortcuts.map(m.global,'<F9>', "<CMD>lua require'dap'.toggle_breakpoint()<CR>")
shortcuts.map(m.global,'<F10>', "<CMD>lua require'dap'.step_over()<CR>")
shortcuts.map(m.global,'<F11>', "<CMD>lua require'dap'.step_into()<CR>")
shortcuts.map(m.global,'<F12>', "<CMD>lua require'dap'.repl.open()<CR>")
