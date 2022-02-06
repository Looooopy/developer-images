local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local wk = require('which-key')


-- Enable vebose logging 
-- vim.lsp.set_log_level("debug")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


local lsp_shortcuts = function()
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')
    wk.register(
        {
            g = {
                name = 'Goto',
                d = { vim.lsp.buf.definition, 'Definition (Goto)' },
                T = { vim.lsp.buf.type_definition, 'Type definition (Goto)' },
                i = { vim.lsp.buf.implementation, 'Implementation (Goto)' },
                r = { vim.lsp.buf.references, 'References (Goto)' },
                l = { '<cmd>Telescope lsp_references<cr>', 'List References (Goto)' },
            },
            d = {
                name = 'Diagnostics',
                j = { vim.diagnostic.goto_next, 'Next (Diagnostics)' },
                k = { vim.diagnostic.goto_pre, 'Prev (Diagnostics)' },
                l = { '<cmd>Telescope diagnostics<cr>', 'List (Diagnostics)' },
            },
            r = {
                name = 'Refactor',
                r = { vim.lsp.buf.rename, 'Rename (Refactor)' },
                f = { vim.lsp.buf.code_action, 'Code Action (Refactor)' },
            }
        },
        {
            mode = m.normal,
            buffer = b.active_buffer,
        }
    )
end

local process_id_nil = function(params)
    params.processId = vim.NIL
end

-- Bash
nvim_lsp.bashls.setup {
    cmd = require'lspcontainers'.command('bashls'),
    on_attach = lsp_shortcuts,
    before_init = process_id_nil,
    capabilities = capabilities, -- get capabilities from cmp.lua
    root_dir = util.root_pattern('.git', vim.fn.getcwd()),
}

-- Lua
nvim_lsp.sumneko_lua.setup {
    cmd = require'lspcontainers'.command('sumneko_lua'),
    on_attach = lsp_shortcuts,
    capabilities = capabilities, -- get capabilities from cmp.lua
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

-- Omnisharp
-- let omnisharp handle *.csx file
vim.api.nvim_command('au BufRead,BufNewFile *.csx set filetype=cs')
require'lspconfig'.omnisharp.setup {
    cmd = require'lspcontainers'.command(
        'omnisharp',
        {
            docker_volume = 'src_nvim-projects-container',
        }
    ),
    on_attach = lsp_shortcuts,
    before_init = process_id_nil,
    capabilities = capabilities, -- get capabilities from cmp.lua
    on_new_config = function(new_config, new_root_dir)
        if new_root_dir then
          print('on_new_config'..new_root_dir)
          table.insert(new_config.cmd, '//usr/run')
          table.insert(new_config.cmd, '--languageserver')
          table.insert(new_config.cmd, '-s')
          table.insert(new_config.cmd, new_root_dir)
        end
    end,
    --root_dir = util.root_pattern("*.sln", vim.fn.getcwd()),
    root_dir = function(file, _)
        if file:sub(-#".csx") == ".csx" then
          return util.path.dirname(file)
        end
        return util.root_pattern("*.sln")(file) or util.root_pattern("*.csproj")(file)
    end
}
