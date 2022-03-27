-- Module
local M = {}

M.default_config = function()
  return {
    wsl2 = require('tui.data.clipboard.host.wsl2').default_config(),
    macos = require('tui.data.clipboard.host.macos').default_config(),
    manager = require('tui.data.clipboard.manager').default_config(),
  }
end

M.setup = function(config)
  config = vim.tbl_deep_extend("force", M.default_config(), config or {})

  if (vim.env.HOST_OS == "wsl2") then
    require('tui.data.clipboard.host.wsl2').setup(wsl2)
  elseif (vim.env.HOST_OS == "macos") then
    require('tui.data.clipboard.host.macos').setup(macos)
  else
    print('May have to setup clipboard')
  end

  require('tui.data.clipboard.manager').setup(config.manager)
end

-- Return Module
return M
