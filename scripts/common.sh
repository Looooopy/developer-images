#!/usr/bin/env bash

export SRC_ROOT=./src

__services='"base", "tmux", "nvim"'

# Remove comment below if you wish to se more verbose logging
# VERBOSE=yes

echo_docker_compose_config() {
  local services=()
  services=( "$@" )

  docker_compose "${GENERIC_VOLUME_TYPE:?}" config > temp.yaml
  if [ ${#services[@]} -eq 0 ]; then
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services" temp.yaml
  fi

  for service in "${services[@]}"
  do
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services.$service" temp.yaml
  done

  rm temp.yaml
}

docker_compose() {
  local volume_type
  volume_type="${1:?}"
  shift
  #if [[ "$(uname)" == 'Darwin' ]]; then
    DEV_UID=1000 DEV_GID=1000 docker-compose -f "$SRC_ROOT"/docker-compose.yml -f "$SRC_ROOT"/docker-compose-volume-${volume_type}.yml --env-file "$SRC_ROOT"/.env  $@
  #else
  # Docker dont threat UID and GID as envirnment variables so we have to do it externaly
  #DEV_UID=$(id -u) DEV_GID=$(id -g) docker-compose  -f "$SRC_ROOT"/docker-compose.yml -f "$SRC_ROOT"/docker-compose-volume-${volume_type}.yml --env-file "$SRC_ROOT"/.env  $@
  #fi
}

export_host_os() {
  export HOST_OS
  if [[ "$(uname -r)" == *microsoft* ]]; then
    HOST_OS="wsl2"
    [[ -n "${VERBOSE}" ]] && echo_os_specific "Detected"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    HOST_OS="macos"
    [[ -n "${VERBOSE}" ]] && echo_os_specific "Detected"
  else
    HOST_OS="linux"
    [[ -n "${VERBOSE}" ]] && echo_os_specific "Detected"
  fi

  if export_dot_env HOST_OS; then
    [[ -n "${VERBOSE}" ]] && echo_os_specific "Override"
  fi
}

echo_os_specific() {
  local prefix="${1:-}"
  case "${HOST_OS:?}" in
    wsl2)
      echo "${prefix:-} HOST_OS to \"WSL2\""
    ;;
    macos)
      echo "${prefix:-} HOST_OS to \"MacOS\""
    ;;
    linux)
      echo "${prefix:-} HOST_OS to \"Linux\""
    ;;
    *)
      echo "${prefix:-} HOST_OS to NOT SET"
    ;;
  esac
}

export_dot_env() {
  local specfic_value
  local env_file

  specfic_value="$1"
  env_file="$SRC_ROOT"/.env

  if [ -z ${specfic_value+x} ]; then
    [[ -n "${VERBOSE}" ]] && echo "Exporting all from $env_file"
    export $(grep -v '^#' "$env_file" | xargs -0)
  else
    if [[ -n "$(grep -v '^#' "$env_file" | grep ^"$specfic_value")" ]]; then
      [[ -n "${VERBOSE}" ]] && echo "Exporting spcific '$specfic_value'"
      export $(grep -v '^#' "$env_file" | grep ^"$specfic_value" | xargs -0)
    else
      [[ -n "${VERBOSE}" ]] && echo "'$specfic_value' in '$env_file' do not exist"
      return 1
    fi
  fi

  return 0
}
