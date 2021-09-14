local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
-- Bash
nvim_lsp.bashls.setup {
    before_init = function(params)
        params.processId = vim.NIL
    end,
    cmd = require'lspcontainers'.command('bashls'),
    root_dir = util.root_pattern(".git", vim.fn.getcwd()),
}

-- Lua
nvim_lsp.sumneko_lua.setup {
    cmd = require'lspcontainers'.command('sumneko_lua'),
    on_attach = on_attach,
    -- Add 'vim' to globals to prevent message 'Undefined global `vim`.'
    -- https://www.reddit.com/r/neovim/comments/khk335/lua_configuration_global_vim_is_undefined/gglrg7k?utm_source=share&utm_medium=web2x&context=3
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}