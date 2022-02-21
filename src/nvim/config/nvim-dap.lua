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

local dap = require('dap')

local wk = require('which-key')
local b = require('constants.buffer')
local m = require('constants.vim-mode')

wk.register(
  {
    d = {
      name = 'Debug',
      d = { '<cmd>lua require("dap").continue()<cr>', 'launch/resume' },
      b = { '<cmd>lua require("dap").toggle_breakpoint()<cr>', 'Toggle breakpoint' },
      h = { '<cmd>lua require("dap").step_over()<cr>', 'Step over' },
      l = { '<cmd>lua require("dap").step_into()<cr>', 'Step into' },
      g = { '<cmd>lua require("dap").repl.open()<cr>', 'Open Repl (type exit to close)' },
      t = { '<cmd>lua require("dapui").toggle()<cr>', 'Toggle Debug console' },
    },
  },
  {
      prefix = '<leader>',
      mode = m.normal,
      buffer = nil,
  }
);

vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

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
--  Had to build it from source beacuse they dont distribute it with musl build for alpine linux.

-- # Add Adapter
dap.adapters.netcoredbg = {
    type = 'executable',
    command = '/tmp/dotnet/netcoredbg/netcoredbg',
    args = {'--interpreter=vscode', '--engineLogging=/tmp/netcoredbg.log'},
    options = {
      env = {
        ASPNETCORE_ENVIRONMENT = 'Development',
      },
    },
}

-- # Add Config
dap.configurations.cs = {
  {
    type = 'netcoredbg',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      -- TODO: fix better function how to find dll's
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net6.0', 'file')
    end,
  },
  {
    type = 'netcoredbg',
    name = 'attach - netcoredbg',
    request = 'attach',
    processId = require("dap.utils").pick_process,
  },
}

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