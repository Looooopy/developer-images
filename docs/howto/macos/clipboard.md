# Clipboard

## How to setup MacOS clipboard

We would like to access the MacOS clipboard from a docker container running on the host.

### MacOS bash script

You need to manipulate bash startup and install some dependencies

``` bash
brew install socat

cat >> $HOME/.zshrc <<'EOF'
function kill_clipboard_socat() {
    kill "$(lsof -t -i:8123)"
    kill "$(lsof -t -i:8124)"
}

function reload_clipboard_socat() {
    kill_clipboard_socat
    start_clipboard_socat
}

function start_clipboard_socat() {
    if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
        # Start up the socat forwarder to pbcopy
        COPY_CLIP_ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8123"; echo $?)
        if [[ $COPY_CLIP_ALREADY_RUNNING != "0" ]]; then
             echo "Starting COPY clipboard relay..."
             (setsid socat tcp-listen:8123,fork,bind=0.0.0.0 EXEC:'pbcopy' &) > /dev/null 2>&1
        else
             #echo "Copy Clipboard relay already running"
        fi
        PASTE_CLIP_ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8124"; echo $?)
        if [[ $PASTE_CLIP_ALREADY_RUNNING != "0" ]]; then
            echo "Starting PASTE clipboard relay..."
            (setsid socat tcp-listen:8124,fork,bind=0.0.0.0 EXEC:'pbpaste' &) > /dev/null 2>&1
        else
            #echo "PASTE Clipboard relay already running"
        fi
    fi
}

start_clipboard_socat
```
