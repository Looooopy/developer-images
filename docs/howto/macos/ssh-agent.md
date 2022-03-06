# SSH Agent Forwarding on MacOS to docker

How to setup SSH Agent on MacOS and use it from docker container.

## Root user

When using root user it quite easy just follow [this guide](https://docs.docker.com/desktop/mac/networking/#ssh-agent-forwarding)

```docker-compose
services:
  web:
    image: nginx:alpine
    environment:
      - SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
    volumes:
      - type: bind
        source: /run/host-services/ssh-auth.sock
        target: /run/host-services/ssh-auth.sock
```

## None root user

Now it get a bit more trickier.

1. Prepare you Dockerfile and install `socat` and `su-exec` and postpone user switching from root to non-root to docker-entrypoint.sh.
   So do not call `USER XXX` in your dockerfile without switching back to `USER root` at end.

    ```Dockerfile
    # Not required if you have NOT switched user
    USER root 

    # ...
    # Create user and set permissions
    # ARG USER={default_user_name}
    # ARG UID=1000
    # ARG GID=1000
    # ENV USER=$USER UID=$UID GID=$GID
    # ...

    ENV SSH_AUTH_SOCK=/home/${USER}/.ssh/socket
    RUN apk add --no-cache \
            # Socat used to access SSH Agent forwarding
            socat \
            # su-exec is used to switch to none root in docker-entrypoint.sh
            su-exec && \
        mkdir -p /home/${USER}/.ssh && \
        chown ${UID}:${GID} /home/${USER}/.ssh/
    ```

2. Create or update your docker-entrypoint.sh script

    ```bash
    #!/bin/bash

    run_as_root_user() {
        # Using same magic string that are used in Root user '/run/host-services/ssh-auth.sock' 
        socat UNIX-LISTEN:/home/${USER}/.ssh/socket,fork,user=${UID},group=${GID},mode=777 \
        UNIX-CONNECT:/run/host-services/ssh-auth.sock \
        &

        # switch user and run you script
        su-exec ${USER} bash -c "run_as_none_root $@"
    }

    run_as_none_root() {
        # This script will run and terminate after everything has run
        # If you wish to start a terminal you should do it here.
        # bash -l # start bash and login to shell.
    }

    export -f run_as_none_root
    run_as_root_user "$@"
    ```

3. Prepare your docker-compose as you did in [Root user](#root-user)
4. Setup forwarding rules in your ` ~/.ssh/config` on your MacOS host machine.

    ```config
    Host github.com
    User git
    AddKeysToAgent yes
    IdentityFile {path/to/your/PRIVATE/ssh/key}/id_ed25519
    ForwardAgent yes
    ```

5. Check that you have a running ssh-agent or run `eval "$(ssh-agent -s)"`
6. Check that it works on MacOS host machine `ssh-add -l`
7. Run you container and test with `ssh-add -l` to check if it works in container.

## References

Description how to setup the agent and add the keys snippets here are based on these source

- [Docker SSH forwarding](https://docs.docker.com/desktop/mac/networking/#ssh-agent-forwarding)
- [Gist None root SSH forwarding](https://gist.github.com/d11wtq/8699521?permalink_comment_id=3878388#gistcomment-3878388)
