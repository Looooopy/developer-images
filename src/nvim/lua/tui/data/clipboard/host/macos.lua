-- Module
local M = {}

-- Neovim use the system's (i.e Window's) clipboard by default.
M.default_config = function()
    return {
        name = 'macos',
        clipboard = 'unnamedplus',
        host = 'host.docker.internal',
        read_port = '8123',
        write_port = '8124',
        cache_enabled = true,
        register_1='+',
        register_2='*',
    }
end

-- Setup socat services for sending clipboard information from and to nvim
M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    local write_to_clip = 'socat - tcp:'..config.host..':'..config.write_port
    local read_from_clip = 'socat -u tcp:'..config.host..':'..config.read_port..' -'

    vim.o.clipboard = config.clipboard
    vim.g.clipboard = {
        name = config.name,
        copy = {
            [config.register_1] = write_to_clip,
            [config.register_2] = write_to_clip,
        },
        paste = {
            [config.register_1] = read_from_clip,
            [config.register_2] = read_from_clip,
        },
        cache_enabled = config.cache_enabled,
    }
end

-- Return Module
return M
