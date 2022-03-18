-- Constants vim modes
M = {
    normal = 'n',           -- Normal
    visual = 'v',           -- Visual and Select
    select = 's',           -- Select
    select = 'x',           -- Visual
    operator = 'o',         -- Operator-pending
    insert_cmd = '!',       -- Insert and Command-line
    insert = 'i',           -- Insert and Replace mode
    insert_cmd_lang = 'l',  -- Insert, Command-line, Lang-Arg
    cmd = 'c',              -- Command-line
    terminal = 't',         -- Terminal
    global = '',            -- Normal, Visual, Select, Operator-pending
}

return M
