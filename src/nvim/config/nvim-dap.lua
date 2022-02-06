-- # nvim-dap Neovim Debugging Adapter
-- # https://github.com/mfussenegger/nvim-dap
-- # Available debug Adapters https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/

-- # Maybe use https://github.com/Pocco81/DAPInstall.nvim to install all debuggers?
-- # Currently it looks like it fit my needs, Scala is just a small amount for now., Tested = Fully supported, Supported= Fully supported, but needs testing, Unsupported=No implementation whatsoever.
-- LUA                                  Tested
-- dotnet                               Tested
-- chrome javascript/typescript         Tested
-- jsnode                               Supported
-- Go (using delve directly)            Tested
-- Python                               Tested
-- Scala                                Unsupported

-- # Lua
------------------------------------------------------------------------------------------------
-- # https://github.com/jbyuki/one-small-step-for-vimkind

-- # Install:
--    Plug 'jbyuki/one-small-step-for-vimkind'

local dap = require"dap"

vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='ﱴ', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='', linehl='', numhl=''})

-- # Add Adapter
dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

-- # Add Configuration

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= "" then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end,
  }
}

-- # dotnet
------------------------------------------------------------------------------------------------
-- # https://github.com/Samsung/netcoredbg
-- Install:
--  Your package manager
--  Downloading it from the release page and extracting it to a folder

-- # Add Adapter
-- dap.adapters.netcoredbg = {
--     type = 'executable',
--     command = '/path/to/dotnet/netcoredbg/netcoredbg',
--     args = {'--interpreter=vscode'}
-- }

-- # Add Config
-- dap.configurations.cs = {
--     {
--       type = "netcoredbg",
--       name = "launch - netcoredbg",
--       request = "launch",
--       program = function()
--           return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--       end,
--     },
-- }

-- # chrome javascript/typescript
------------------------------------------------------------------------------------------------
-- Install:
--  build vscode-chrome-debug

--  git clone https://github.com/Microsoft/vscode-chrome-debug
--  cd ./vscode-chrome-debug
--  npm install
--  npm run build

-- # Add Adapter
-- dap.adapters.chrome = {
--     type = "executable",
--     command = "node",
--     args = {os.getenv("HOME") .. "/path/to/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
-- }

-- # Add Config javascript
-- dap.configurations.javascriptreact = { -- change this to javascript if needed
--     {
--         type = "chrome",
--         request = "attach",
--         program = "${file}",
--         cwd = vim.fn.getcwd(),
--         sourceMaps = true,
--         protocol = "inspector",
--         port = 9222,
--         webRoot = "${workspaceFolder}"
--     }
-- }

-- # Add Config typescript
-- dap.configurations.typescriptreact = { -- change to typescript if needed
--     {
--         type = "chrome",
--         request = "attach",
--         program = "${file}",
--         cwd = vim.fn.getcwd(),
--         sourceMaps = true,
--         protocol = "inspector",
--         port = 9222,
--         webRoot = "${workspaceFolder}"
--     }
-- }

-- # Note: chrome has to be started with a remote debugging port google-chrome-stable --remote-debugging-port=9222

-- # Go (using delve directly)
------------------------------------------------------------------------------------------------
-- # Install:
--  go get -u github.com/go-delve/delve/cmd/dlv
--  or via package manager. For example pacman -S delve
--  https://github.com/leoluz/nvim-dap-go
--  Plug 'leoluz/nvim-dap-go'


-- # Add Config
-- require('dap-go').setup()

-- # Scala
------------------------------------------------------------------------------------------------
-- # https://github.com/scalameta/nvim-metals
-- # Install:
--    Plug 'scalameta/nvim-metals'

-- # Config: (Read when needed)

-- # Python
------------------------------------------------------------------------------------------------