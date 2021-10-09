# Clipboard

## How to setup Windows clipboard

We would like to access the windows clipboard from a docker container running in WSL.

### Windows powershell

Start a powershell terminal and run command below.

It will install [win32yank](https://github.com/equalsraf/win32yank) which will allow us to access the windows clipboard through a command.

> Note: Must be run as adminstrator

``` powershell
    choco install win32yank
```

### Windows WSL bash

Start your windows wsl bash session and run the following command

It will install socat and append your zsh shell with two new TCP services

- port 8121 => will echo the content from windows clipboard
- port 8122 => you can write things to this socket that will be placed in windows clipboard.

``` bash
sudo apt install socat

cat >> $HOME/.zshrc <<'EOF'
if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
    # Start up the socat forwarder to win32yank.exe
    COPY_CLIP_ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
    if [[ $COPY_CLIP_ALREADY_RUNNING != "0" ]]; then
        echo "Starting COPY clipboard relay..."
        (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'win32yank.exe -o' &) > /dev/null 2>&1
    else
        echo "Copy Clipboard (read data from windows clipboard) relay already running"
    fi
    PASTE_CLIP_ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8122"; echo $?)
    if [[ $PASTE_CLIP_ALREADY_RUNNING != "0" ]]; then
        echo "Starting PASTE clipboard relay..."
        (setsid socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:'win32yank.exe -i' &) > /dev/null 2>&1
    else
        echo "PASTE Clipboard (write data to windows clipboard) relay already running"
    fi
fi
```

## WSL

Run it in bash shell in WSL.

> Note: Remember that you need to reload ```source $HOME/.zshrc``` bash prompt config
>       or start a new one if you havent already to start the code from [above section](Windows-wsl-bash).

This write data to windows clipboard:

``` bash
    echo 'test from WSL' | socat - tcp:localhost:8122
```

This read data from windows clipboard:

``` bash
    socat tcp:localhost:8121 -
```


Result (If you did not copy the above command):
``` bash
    test from docker
```

Result (If you copy the above command):
``` bash
    socat tcp:localhost:8121 -
```

## Docker container

In a container you need to do something like this

This write data to windows clipboard:

``` bash
    echo 'test from docker' | socat - tcp:host.docker.internal:8122
```

This command read data from windows clipboard:

``` bash
    socat tcp:host.docker.internal:8121 -
```

Result (If you did not copy the above command):
``` bash
    test from docker
```

Result (If you copy the above command):
``` bash
    socat tcp:host.docker.internal:8121 -
```

## Neovim in docker

If you wish to utilize it in Neovim (or some other app that has its own clipboard that needs to rediect to windows)

Neovim you need to do it like this:

``` vim
    let s:write_to_clip = 'socat - tcp:host.docker.internal:8122'
    let s:read_from_clip = 'socat -u tcp:host.docker.internal:8121 -'
    let g:clipboard = {
        \  'name' : 'wsl',
        \  'copy' : {
        \    '+' : s:read_from_clip..' --crlf',
        \    '*' : s:read_from_clip..' --crlf',
        \  },
        \  'paste' : {
        \    '+' : s:write_to_clip..' --lf',
        \    '*' : s:write_to_clip..' --lf',
        \  },
        \}
    unlet s:write_to_clip
    unlet s:read_from_clip
```

### Use Neovim to copy

* Open a file ```neovim [filepath]```
* in normal mode press 'v' for visual mode
* select something to copy
* press 'y*' to yank into windows clipboard
* press esc to escape visual mode
* go to a line there you would like to paste it
* press 'p*' to paste from windows clipboard

## References

[Forward windows clipboard](https://stuartleeks.com/posts/vscode-devcontainer-clipboard-forwarding/)

[Use socat](https://copyconstruct.medium.com/socat-29453e9fc8a6)

[socat samples](http://www.dest-unreach.org/socat/doc/socat.html)