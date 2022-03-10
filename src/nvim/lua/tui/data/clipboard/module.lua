-- Module
local M = {}

M.default_config = function()
  return {
    wsl2 = require('tui.data.clipboard.host.wsl2').default_config(),
  }
end

M.setup = function(config)
  config = vim.tbl_deep_extend("force", M.default_config(), config or {})

  if (vim.env.HOST_OS == "wsl2") then
    require('tui.data.clipboard.host.wsl2').setup(wsl2)
  else
    print('May have to setup clipboard')
  end
end

-- Return Module
return M
