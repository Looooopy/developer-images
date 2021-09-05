#!/usr/bin/env bash

echo_docker_compose_config() {
  local services=()
  services=( "$@" )

  DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose config > temp.yaml

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
  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose-volume-${volume_type}.yml $@
}


prune_volumes() {
  local volume_names
  volume_names=()
  if [ ! -z ${ALL_VOLUMES+x} ]; then
    unset ALL_VOLUMES
    docker_compose container down --volumes
    docker_compose localhost down --volumes
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
    echo 'Try exporting "GENERIC_VOLUME_TYPE" from .env file'
    export $(grep -v '^#' .env | grep ^GENERIC_VOLUME_TYPE | xargs -0)
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
