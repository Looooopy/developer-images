local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local on_error
local on_format

----------------------------
-- Public function interface
----------------------------
M.default_config = function()
    return {
        logger = {
            enabled = true,
            error = on_error,
            formatter = on_format,
        }
    }
end

M.require = function(lib_str,config)
    local _config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    lib_str = lib_str or {}

    local ok, lib = pcall(require, lib_str)
    if not ok and _config.logger.enabled then
        _config.logger.error('Missing dependency:'..lib_str)
    end

    return ok, lib
end

M.require_all = function(string_libs, config)
    local _config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    string_libs = string_libs or {}

    local all_ok = true
    local errors = {}
    local loaded_libs = {}

    for _,lib_str in ipairs(string_libs) do
        local ok, lib = pcall(require, lib_str)
        if not ok then
            table.insert(errors, lib_str)
            all_ok = false
        else
            table.insert(loaded_libs, lib)
        end
    end

    if not all_ok and _config.logger.enabled then
        _config.logger.error(errors, _config.logger.formatter)
    end

    return all_ok, loaded_libs
end

--------------------
-- Private functions
--------------------
on_error = function(errors, formatter)
    print('Missing dependencies:')
    print(formatter(errors))
    print('---------------------')
end

on_format = function(errors)
    return table.concat(errors, '\n')
end

-- Return Module
return M
