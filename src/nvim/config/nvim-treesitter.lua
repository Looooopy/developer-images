-- [[ Treesitter Setup ]]

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
}

-- [[ Available Commands ]]

-- Check if some commands has changed
-- :help nvim-treesitter-commands

-- TSInstall
-- TSInstallSync
-- TSInstallInfo
-- TSUpdate
-- TSUpdateSync
-- TSUninstall
-- TSBufEnable
-- TSBufDisable
-- TSBufToggle
-- TSEnableAll
-- TSDisableAll
-- TSToggleAll
-- TSModuleInfo
-- TSEditQuery
-- TSEditQueryUserAfter
