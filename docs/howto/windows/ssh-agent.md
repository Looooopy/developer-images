# SSH Agent Forwarding on Windows to WSL2

How to setup SSH Agent on Windows and use it from WSL2 Ubuntu.

## Prereq

- Chocolatey
- Installed Git on windows
- Generated SSH keys on windows machine default location
- Installed WSL2 and running ubuntu bash with zsh

## Setup Windows SSH agent and let WSL2 use that agent

Its a two step process

- Windows 10+
- WSL2 ubuntu

### Windows 10+
Run this script as administrator once

[npiperelay](https://github.com/jstarks/npiperelay) is used in Ubuntu in WSL2 to foward request to windows SSH Agent.

> Note: Must be run as adminstrator

``` powershell
    # Set the sshd service to be started automatically
    Get-Service -Name ssh-agent | Set-Service -StartupType Automatic

    # Now start the sshd service
    Start-Service sshd

    # Add ssh private keys to agent
    ssh-add
    choco install npiperelay -y
```

### WSL2 ubuntu

Run this script once to install dependencies and append .zshrc

Output shall result in:

[<span style="color:green">Success</span>] - WSL connected to SSH Agent in Windows

``` bash
sudo apt install socat

# Add script to ~/.zshrc that redirect ssh connection to ssh agent on windows
cat >> $HOME/.zshrc <<'EOF'
# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
# need ps -ww to get non-truncated command for matching
# use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    fi
    echo "Starting SSH-Agent relay..."
    # setsid to force new session to keep running
    # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

EOF

source $HOME/.zshrc
check_ssh() {
    local result
    local Red='\033[0;31m'          # Red
    local Green='\033[0;32m'        # Green
    local Color_End='\033[0m'

    result="$(ssh -T git@github.com 2>&1)"
    if [[ $? == 1 ]] && [[ "$result" == *"successfully authenticated"* ]]; then
        echo -e "[${Green}Success${Color_End}] - WSL connected to SSH Agent in Windows"
        return 0
    else
        echo -e "[${Red}Failed${Color_End}] - WSL did not succeed in connecting to SSH Agent in Windows"
        return 1
    fi
}

check_ssh
```

## SSH agent in Docker

How to configure and reuse SSH agent from windows in a Docker.

### docker

``` bash
docker run -v ${SSH_AUTH_SOCK}:/agent.sock --env SSH_AUTH_SOCK=/agent.sock
```

### docker-compose usage

``` yaml
version: "3.8"

services:
  my-service:
    image: hello-world:
    environment:
      - SSH_AUTH_SOCK=/agent.sock
    volumes:
      - ${SSH_AUTH_SOCK}:/agent.sock
```

``` bash
docker-compose run
```

## References

Description how to setup the agent and add the keys snippets here are based on these sources

- [Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
- [Hack SSH setting up forwarder](https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/)
- [Hack SSH using Git](https://stuartleeks.com/posts/git-for-windows-ssh-key-passphrases/)

If you need GPG i also found this

- [Hack SSH with GPG](https://blog.nimamoh.net/yubi-key-gpg-wsl2/)
