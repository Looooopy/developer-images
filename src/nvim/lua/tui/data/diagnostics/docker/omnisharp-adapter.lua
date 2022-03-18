-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local _new_config

--------------------------------
-- Forward variable declarations
--------------------------------
local _setup_config
local _dependency = require('common.dependency')

----------------------------
-- Public function interface
----------------------------
M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    _setup_config = config
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
    local containers = depencencies[2]
    local lspconfig = depencencies[3]
    local util = depencencies[4]

    -- let omnisharp handle *.csx file in the same manner as *.cs
    vim.api.nvim_command('autocmd BufRead,BufNewFile *.csx set filetype=cs')

    lspconfig.omnisharp.setup {
        cmd = containers.command(
            'omnisharp',
            {
                docker_volume = config.docker_volume,
            }
        ),
        on_attach = language_server.attach,
        before_init = language_server.process_id_nil,
        capabilities = language_server.capabilities,
        on_new_config = _new_config,
        --root_dir = util.root_pattern("*.sln", vim.fn.getcwd()),
        root_dir = function(file, _)
            if file:sub(-#".csx") == ".csx" then
              return util.path.dirname(file)
            end
            return util.root_pattern("*.sln")(file) or util.root_pattern("*.csproj")(file)
        end
    }
end

M.default_config = function()
    return {
        host_system = vim.env.HOST_OS,
        docker_volume = 'src_nvim-projects-container',
    }
end

--------------------
-- Private functions
--------------------
_new_config = function(new_config, new_root_dir)
    if new_root_dir then
        if _setup_config.host_system == 'wsl2' then
            table.insert(new_config.cmd, '//usr/run')
        else
            table.insert(new_config.cmd, '/usr/run')
        end

        table.insert(new_config.cmd, '--languageserver')
        table.insert(new_config.cmd, '-s')
        table.insert(new_config.cmd, new_root_dir)
    end
end

-- Return Module
return M
