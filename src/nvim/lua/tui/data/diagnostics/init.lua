local M = {}

M.default_config = function()
  return {
    language_server = require('tui.data.diagnostics.language-server').default_config(),
    docker = require('tui.data.diagnostics.docker').default_config(),
  }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data.diagnostics.language-server').setup(config.language_server)
    require('tui.data.diagnostics.docker').setup(config.docker)
end

return M
