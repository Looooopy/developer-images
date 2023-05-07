-- Module
local M = {}
local _dependency = require('common.dependency')

--------------------------------
-- Forward function declarations
--------------------------------

----------------------------
-- Public function interface
----------------------------
M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    local required =
    {
        'tui.data.diagnostics.language-server',
        'lspcontainers',
        'lspconfig',
        'lspconfig/util',
    }

    local all_ok, depencencies = _dependency.require_all(required, config)
    if not all_ok then
        return false
    end

    local language_server = depencencies[1]
    local container = depencencies[2]
    local lspconfig = depencencies[3]
    local util = depencencies[3]

    -- local runtime_path = vim.split(package.path, ';')
    -- table.insert(runtime_path, "lua/?.lua")
    -- table.insert(runtime_path, "lua/?/init.lua")

    lspconfig.lua_ls.setup {
        cmd = require'lspcontainers'.command('sumneko_lua'),
        on_attach = language_server.attach,
        capabilities = language_server.capabilities,
        settings = {
            Lua = {
                -- runtime = {
                --     -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                --     version = 'LuaJIT',
                --     -- Setup your lua path
                --     path = runtime_path,
                -- },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                },
                -- workspace = {
                --     -- Make the server aware of Neovim runtime files
                --     library = vim.api.nvim_get_runtime_file("", true),
                -- },
                -- -- Do not send telemetry data containing a randomized but unique identifier
                -- telemetry = {
                --     enable = false,
                -- },
            }
        }
    }
end

M.default_config = function()
    return {}
end

-- Return Module
return M
