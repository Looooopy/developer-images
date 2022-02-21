-- https://github.com/akinsho/toggleterm.nvim
-- TODO: 
--      * Add Lazyguit https://github.com/akinsho/toggleterm.nvim#custom-terminals
--      * Fix opening_mapping to use to :ToggleTermToggleAll after opening the first one.


require("toggleterm").setup{
    open_mapping = [[<c-a>]],
}

function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)          -- escape out from terminal (good for scrolling the window or just issues vim commands)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)    -- Left (Switch buffer)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)    -- Up (Switch buffer)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)    -- Down (Switch buffer)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)    -- Right (Switch buffer)
  end
  
  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')