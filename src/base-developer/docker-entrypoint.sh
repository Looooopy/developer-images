#!/usr/bin/env bash

set -e

clone_multiple() {
  if (($# == 0)); then
    >&2 echo " - No project(s) was defined to be clone look into .env CLONE_PROJECT_{X} to set a valid path"
  fi

  for url in "$@"
  do
    local project_name="$(get_project_name "$url")"
    if [[ -d "$project_name" ]]; then
      >&2 echo " - Project '$url' already cloned"
    elif cloning "$url"; then
      echo " - Project '$url' cloned"
    else
      >&2 echo " - Project '$url' failed"
    fi
  done
}

cloning() {
  local url="${1:?}"
  local valid_ssh_clone_url='^git@github.com:(((:?)|(\/))([A-Za-z0-9.\-]+?))+(\.git){1}$'
  if [[ $url =~ $valid_ssh_clone_url ]]; then
    # TODO: redirect stderr so it is quiet then
    #       parse the stderr for "ERROR: Repository not found."
    git clone "$url" --quiet && return 0
    return $?
  else
    >&2 echo "'$url' is not a valid and will not be cloned" && return 1
  fi
}

get_project_name() {
    local res_and_project_match='^.*\/([A-Za-z0-9.\-]+)\.git{1}$'
    if [[ $1 =~ $res_and_project_match ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
}

get_project_name_if_only_one () {
  if (($# == 1)); then
    get_project_name "$1"
  fi
}

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

  export -f main
}

run_as_none_root() {
  su-exec "${DEV_USER}:${DEV_USER}" bash -c "main $@"
}

main() {
  local mode="$1"

  unset -f main

  if (($# >= 1)); then
    [[ "$1" == "clone" ]] && shift
  fi

  case "$mode" in
    clone)
      local project_name
      echo "Clone mode"
      clone_multiple "$@"
      project_name="$(get_project_name_if_only_one "$@")"
      [[ -n "$project_name" ]] && [[ -d "/projects/$project_name" ]] && cd "$project_name"
      bash -l
      ;;

    *)
      echo "Bypass mode"
      # bash
      bash -l

      return;
      ;;
  esac
}

run_setup_as_root
run_as_none_root "$@"
