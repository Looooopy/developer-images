#!/usr/bin/env bash

set -e

source /docker-entrypoint-helper.sh

run_setup_as_root() {
  if [[ -n ${RUN_AS_ROOT} ]]; then
    echo
    echo 'Warning: Running all processes as ROOT user'
    echo
    return 0
  fi

  # wsl2 using a solution there we need to do things on the host instead of docker
  # https://github.com/Looooopy/developer-images/blob/master/docs/howto/windows/ssh-agent.md
  if [[ ${HOST_OS} == 'macos' ]]; then
    # Note:
    #   Setup a socket through socat to communicate through ssh agent forwarding
    #   via the magic /run/host-services/ssh-auth.sock that is used in MacOS
    echo "Setting up relay for Agent Forwarding"
    socat UNIX-LISTEN:/home/"${DEV_USER}"/.ssh/socket,fork,user="${DEV_UID}",group="${DEV_GID}",mode=777 \
      UNIX-CONNECT:/run/host-services/ssh-auth.sock \
      &

    export SSH_AUTH_SOCK=/home/${DEV_USER}/.ssh/socket
  fi

  if [[ ${HOST_OS} == 'macos' ]] || [[ ${HOST_OS} == 'wsl2' ]]; then
    # Note:
    #   Setup a socket through socat to communicate with docker
    echo "Setting up relay for Docker"
    socat UNIX-LISTEN:/home/"${DEV_USER}"/.docker/docker_socket,fork,user="${DEV_UID}",group="${DEV_GID}",mode=777 \
      UNIX-CONNECT:/var/run/docker.sock \
      &

    export DOCKER_HOST=unix:///home/${DEV_USER}/.docker/docker_socket
  fi
}

main_as_none_root() {
  cmd_string="source /docker-entrypoint-helper.sh; main $@"
  if ! su-exec "${DEV_UID}:${DEV_GID}" bash -c "$cmd_string"; then
    su-exec "${DEV_UID}:${DEV_GID}" bash -l
  fi
}

run_setup_as_root

if [[ -z "${RUN_AS_ROOT}" ]]; then
  main_as_none_root "$@"
else
  main $@
fi
