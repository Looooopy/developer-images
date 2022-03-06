-- https://github.com/akinsho/toggleterm.nvim
-- TODO: 
--      * Add Lazyguit https://github.com/akinsho/toggleterm.nvim#custom-terminals

require("toggleterm").setup{
    -- open_mapping = [[<c-a>]],
}

function _G.set_terminal_keymaps()
    local m = require('constants.vim-mode')
    local b = require('constants.buffer')
    local wk = require('which-key')

    local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    -- Leader commands
    wk.register(
        {
            ["<C-h>"]   = { t('<C-\\><C-n><C-W>h'), 'Move: Left (terminal)' },
            ["<C-j>"]   = { t('<C-\\><C-n><C-W>j'), 'Move: Down (terminal)' },
            ["<C-k>"]   = { t('<C-\\><C-n><C-W>k'), 'Move: Up (terminal)' },
            ["<C-l>"]   = { t('<C-\\><C-n><C-W>l'), 'Move: Right (terminal)' },
            ["<Esc>"]   = { t('<C-\\><C-n>'),       'Escape (terminal)'},
            ["<C-Z>"]   = { t('<C-\\><C-n>')..'<cmd>TuiToggleTerminals<cr>',  'Toggle (terminal)'},
        },
        {
            mode = m.terminal,
            noremap = true,
            silent = true,
            buffer = b.active_buffer,
        }
    );

end
  
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local register_global_keymaps = function()
    local m = require('constants.vim-mode')
    local b = require('constants.buffer')
    local wk = require('which-key')

    wk.register(
        {
            ["<C-A>"] = { '<cmd>TuiShowTerminals<cr>',    'Show terminals' },
            ["<C-Z>"] = { '<cmd>TuiToggleTerminals<cr>',  'Toggle terminals' },
        },
        {
            mode = m.normal,
            noremap = true,
            silent = true,
            buffer = b.all_buffers
        }
    );
end

register_global_keymaps()