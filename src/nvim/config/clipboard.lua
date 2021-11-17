if (vim.env.HOST_OS == "wsl2") then
  -- Neovim use the system's (i.e Window's) clipboard by default.
  vim.o.clipboard = "unnamedplus"
  local write_to_clip = 'socat - tcp:host.docker.internal:8122'
  local read_from_clip = 'socat -u tcp:host.docker.internal:8121 -'
  vim.g.clipboard = {
    name = "wsl2 (windows)",
    copy = {
      ["+"] = write_to_clip,
      ["*"] = write_to_clip
    },
    paste = {
      ["+"] = read_from_clip,
      ["*"] = read_from_clip
    },
    cache_enabled = true
  }
end

