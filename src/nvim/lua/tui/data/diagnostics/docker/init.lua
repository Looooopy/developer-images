local M = {}

M.default_config = function()
  return {
    bash_adapter = require('tui.data.diagnostics.docker.bash-adapter').default_config(),
    omnisharp_adapter = require('tui.data.diagnostics.docker.omnisharp-adapter').default_config(),
    lua_adapter = require('tui.data.diagnostics.docker.lua-adapter').default_config(),
  }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data.diagnostics.docker.bash-adapter').setup(config.bash_adapter)
    require('tui.data.diagnostics.docker.omnisharp-adapter').setup(config.omnisharp_adapter)
    require('tui.data.diagnostics.docker.lua-adapter').setup(config.lua_adapter)
end

return M
