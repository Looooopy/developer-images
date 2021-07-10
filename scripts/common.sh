#!/usr/bin/env bash

build() {
  local version
  local services_short=()
  local services=()
  local failed=0
  version="${1:-latest}"
  [[ -n "$1" ]] && shift
  [[ -z "$*" ]] && services_short=( "$@" )

  for service in "${services_short[@]}"
  do
    case $service in
      tmux | nvim | base )
        services+=("$1-developer_$version")
        ;;
      *)
        >&2 echo "service='$1' not an allowed service, allowed 'tmux', 'nvim'"
        failed=1
        ;;
    esac
  done

  [[ "$failed" == 1 ]] && return 1

  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose build "${services[@]}"
}

run() {
  : [[ "${1:?'Missing service argument'}" ]]

  local start_arg
  local version

  version="${2:-latest}"
  start_arg="${3:-}"
  local service

  case $1 in
    tmux | nvim)
      service="$1-developer_$version"
      ;;
    *)
      >&2 echo "service='$1' not an allowed service, use 'tmux', 'nvim'" && return 1
      ;;
  esac

  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  [[ -z "$start_arg" ]] \
    && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm "$service"

  [[ -n "$start_arg" ]] \
    && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose run --rm "$service" "$start_arg"
}
