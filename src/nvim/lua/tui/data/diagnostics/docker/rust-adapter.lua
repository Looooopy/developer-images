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

    require'lspconfig'.rust_analyzer.setup{
        cmd = require'lspcontainers'.command('rust_analyzer', { network='docker_default' }),
        settings = {
            ['rust-analyzer'] = {
                diagnostics = {
                    enable = true;
                }
            }
        }
    }
end

M.default_config = function()
    return {}
end

-- Return Module
return M

