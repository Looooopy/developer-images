# SSH Agent

Describe how to setup SSH Agent.

# Prereq

- Chocolatey
- Installed Git on windows
- Generated SSH keys on windows machine default location
- Installed WLS and running ubuntu bash with zsh

## Windows 10

Description how to setup the agent and add the keys snippets here are based on these sources

- [Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
- [Hack SSH setting up forwarder](https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/)
- [Hack SSH using Git](https://stuartleeks.com/posts/git-for-windows-ssh-key-passphrases/)

If you need GPG i also found this

- [Hack SSH with GPG](https://blog.nimamoh.net/yubi-key-gpg-wsl2/)

### Start SSH Service

``` powershell
# Set the sshd service to be started automatically
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic

# Now start the sshd service
Start-Service sshd
```

### Add current SSH keys

If you have generated them before you could simple run this.

``` powershell
# Add ssh keys
ssh-add
```

## Let WSL2 SSH use agent on Windows

Run this script as administrator once to download and install the SSH agent forwarder

This utility [npiperelay](https://github.com/jstarks/npiperelay) will be called from Ubuntu in WSL2

``` powershell
    choco install npiperelay -y
```
In WSL2 run this script once as admin to append it to your .zshrc

Output shall result in:

[<span style="color:green">Success</span>] - WSL connected to SSH Agent in Windows

``` bash
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
}
EOF

source $HOME/.zshrc
check_ssh() {
    local result
    local Red='\033[0;31m'          # Red
    local Green='\033[0;32m'        # Green
    local Color_End='\033[0m'

    result="$(ssh -T git@github.com 2>&1)"
    if [[ $? == 1 ]] && [[ "$result" == *"successfully authenticated"* ]]; then
        echo -e "\[${Green}Success${Color_End}\] - WSL connected to SSH Agent in Windows"
        return 0
    else
        echo -e "\[${Red}Failed${Color_End}\] - WSL did not succeed in connecting to SSH Agent in Windows"
        return 1
    fi
}

check_ssh
```
