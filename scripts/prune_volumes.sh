#!/usr/bin/env bash

# Declared in common.sh
# docker_compose

prune_volumes() {
  local all_volumes
  all_volumes=${1:-${ALL_VOLUMES:-no}}
  if [ "$all_volumes" != "no"  ]; then
    unset ALL_VOLUMES
    export GENERIC_VOLUME_TYPE
    GENERIC_VOLUME_TYPE=container
    prune_volumes
    GENERIC_VOLUME_TYPE=localhost
    prune_volumes
    return 0
  elif [[ "${GENERIC_VOLUME_TYPE:?}" == container ]] ||  [[ "${GENERIC_VOLUME_TYPE:?}" == localhost ]]; then
    docker_compose down "${version}" "${GENERIC_VOLUME_TYPE:?}" --volumes
  fi
}
