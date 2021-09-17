#!/usr/bin/env bash

export SRC_ROOT=./src

echo_docker_compose_config() {
  local services=()
  services=( "$@" )

  docker_compose "${GENERIC_VOLUME_TYPE:?}" config > temp.yaml

  if [ ${#services[@]} -eq 0 ]; then
    echo
    echo "All services"
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services"  temp.yaml
  fi

  for service in "${services[@]}"
  do
    echo
    echo "$service service"
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services.$service"  temp.yaml
  done
  rm temp.yaml
}

docker_compose() {
  local volume_type
  volume_type="${1:?}"
  shift
  if [[ "$(uname)" == 'Darwin' ]]; then
    DEV_UID=1000 DEV_GID=1000 docker-compose  -f "$SRC_ROOT"/docker-compose.yml -f "$SRC_ROOT"/docker-compose-volume-${volume_type}.yml --env-file "$SRC_ROOT"/.env  $@
  else
  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose  -f "$SRC_ROOT"/docker-compose.yml -f "$SRC_ROOT"/docker-compose-volume-${volume_type}.yml --env-file "$SRC_ROOT"/.env  $@
  fi
}

export_dot_env() {
  local specfic_value
  local env_file

  specfic_value="$1"
  env_file="$SRC_ROOT"/.env

  if [ -z ${specfic_value+x} ]; then
    echo "Exporting all from "
    export $(grep -v '^#' "$env_file" | xargs -0)
  else
    echo "Exporting spcific '$specfic_value'"
    export $(grep -v '^#' "$env_file" | grep ^"$specfic_value" | xargs -0)
  fi
}


prune_volumes() {
  local all_volumes
  all_volumes=${1:-${ALL_VOLUMES:-no}}
  echo "$all_volumes"
  if [ "$all_volumes" != "no"  ]; then
    echo "ALl"
    unset ALL_VOLUMES
    export GENERIC_VOLUME_TYPE
    GENERIC_VOLUME_TYPE=container
    prune_volumes
    GENERIC_VOLUME_TYPE=localhost
    prune_volumes
    return 0
  elif [[ "${GENERIC_VOLUME_TYPE:?}" == container ]] ||  [[ "${GENERIC_VOLUME_TYPE:?}" == localhost ]]; then
    docker_compose "${GENERIC_VOLUME_TYPE:?}" down --volumes
  fi
}

build() {
  local version
  local services_short=()
  local services=()
  local failed=0
  version="${1:-latest}"
  [[ -n "$1" ]] && shift
  [[ -n "$*" ]] && services_short=( "$@" )

  for service in "${services_short[@]}"
  do
    case $service in
      tmux | nvim | base )
        services+=("$service-developer_$version")
        ;;
      *)
        >&2 echo "service='$1' not an allowed service, allowed 'tmux', 'nvim'"
        failed=1
        ;;
    esac
  done

  [[ "$failed" == 1 ]] && return 1

  echo_docker_compose_config "${services[@]}"
  docker_compose "${GENERIC_VOLUME_TYPE:?}" build "${services[@]}"
}

run() {
  : [[ "${1:?'Missing service argument'}" ]]

  local start_arg
  local version
  local service_short

  service_short="$1"
  version="${2:-latest}"
  start_arg="${3:-}"
  local service

  case $service_short in
    tmux | nvim)
      service="$service_short-developer_$version"
      ;;
    *)
      >&2 echo "service='$1' not an allowed service, use 'tmux', 'nvim'" && return 1
      ;;
  esac

  if [ -z ${GENERIC_VOLUME_TYPE+x} ]; then
    export_dot_env GENERIC_VOLUME_TYPE
  else
    echo 'Exporting already defined "GENERIC_VOLUME_TYPE" from shell'
    export GENERIC_VOLUME_TYPE
  fi

  [[ "${GENERIC_VOLUME_TYPE:?'GENERIC_VOLUME_TYPE must be either "container" or "localhost"'}" ]]

  case "${GENERIC_VOLUME_TYPE:?}" in
    container | localhost)
      if [[ -z "$start_arg" ]]; then
        docker_compose "${GENERIC_VOLUME_TYPE:?}" run --rm "$service"
      else
        docker_compose "${GENERIC_VOLUME_TYPE:?}" run --rm "$service" "$start_arg"
      fi
      ;;
    *)
      >&2 echo 'Unknow Volume type must be either "container" or "localhost"'
      return 1
      ;;
  esac
}
