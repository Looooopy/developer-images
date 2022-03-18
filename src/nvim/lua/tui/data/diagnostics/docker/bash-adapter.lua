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
    local util = depencencies[4]

    -- Treat 'build', 'run' and 'prune' files as shell files ('sh')
    -- vim.api.nvim_command('autocmd BufRead,BufNewFile build set filetype=sh')
    -- vim.api.nvim_command('autocmd BufRead,BufNewFile run set filetype=sh')
    -- vim.api.nvim_command('autocmd BufRead,BufNewFile prune set filetype=sh')

    lspconfig.bashls.setup {
        cmd = container.command('bashls'),
        on_attach = language_server.attach,
        before_init = language_server.process_id_nil,
        capabilities = language_server.capabilities,
        root_dir = util.root_pattern('.git', vim.fn.getcwd()),
    }
end

M.default_config = function()
    return {}
end

-- Return Module
return M
