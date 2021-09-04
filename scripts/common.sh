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

  export $(grep -v '^#' .env | grep ^ALL_VOLUME_TYPE | xargs -0)

  [[ "${ALL_VOLUME_TYPE:?'ALL_VOLUME_TYPE must be either "container" or "localhost"'}" ]]

  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  if [[ "${ALL_VOLUME_TYPE:?}" == container ]]; then
    [[ -z "$start_arg" ]] \
      && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose-volume-container.yml run --rm "$service"

    [[ -n "$start_arg" ]] \
      && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose-volume-container.yml run --rm "$service" "$start_arg"
  elif [[ "${ALL_VOLUME_TYPE:?}" == localhost ]]; then
    [[ -z "$start_arg" ]] \
      && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose-volume-localhost.yml run --rm "$service"

    [[ -n "$start_arg" ]] \
      && DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose-volume-localhost.yml run --rm "$service" "$start_arg"
  fi

}
