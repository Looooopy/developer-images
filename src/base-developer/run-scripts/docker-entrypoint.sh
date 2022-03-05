#!/usr/bin/env bash

set -e

source /docker-entrypoint-helper.sh

run_setup_as_root() {
  if [[ ${HOST_OS} == 'macos' ]]; then
    # Note:
    #   Setup a socket through socat to communicate through ssh agent forwarding
    #   via the magic /run/host-services/ssh-auth.sock that is used in MacOS
    socat UNIX-LISTEN:/home/"${DEV_USER}"/.ssh/socket,fork,user="${DEV_UID}",group="${DEV_GID}",mode=777 \
      UNIX-CONNECT:/run/host-services/ssh-auth.sock \
      &

    export SSH_AUTH_SOCK=/home/${DEV_USER}/.ssh/socket
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