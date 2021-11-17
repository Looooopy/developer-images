let s:write_to_clip = 'socat - tcp:host.docker.internal:8122'
let s:read_from_clip = 'socat -u tcp:host.docker.internal:8121 -'
let g:clipboard = {
      \  'name' : 'wsl',
      \  'copy' : {
      \    '+' : s:write_to_clip,
      \    '*' : s:write_to_clip,
      \  },
      \  'paste' : {
      \    '+' : s:read_from_clip,
      \    '*' : s:read_from_clip,
      \  },
      \}
unlet s:write_to_clip
unlet s:read_from_clip
