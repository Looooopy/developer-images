-- Module
local M = {}

M.default_config = function()
  return {
    completion = require('tui.data.completion.completion-engine').default_config(),
  }
end

M.setup = function(config)
  config = vim.tbl_deep_extend("force", M.default_config(), config or {})

  require('tui.data.completion.completion-engine').setup(config.completion)
end

-- Return Module
return M
