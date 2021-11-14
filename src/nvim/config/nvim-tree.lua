require'nvim-tree'.setup {
    diagnostics = {
        enable = true,
        -- -- default
        -- icons = {
        --   hint = "",
        --   info = "",
        --   warning = "",
        --   error = "",
        -- },
    },
    open_on_setup = true,
    update_to_buf_dir   = {
        enable    = true,
        -- false by default, opens the tree when typing `nvim $DIR` or `nvim`
        auto_open = true,
    },
    update_focused_file = {
        enable      = false,
        -- false by default, will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
        update_cwd = true,
        ignore_list = {
            'startify', 'dashboard'
        }
    },
    fileters = {
        dotfiles = false,
        custom = {
            ".git",
            "node_modules",
            ".cache"
        }
    }
}