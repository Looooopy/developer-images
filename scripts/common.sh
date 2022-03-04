#!/usr/bin/env bash

export SRC_ROOT=./src

__services='"base", "tmux", "nvim"'

# Remove comment below if you wish to se more verbose logging
# VERBOSE=yes

echo_docker_compose_config() {
  local volume_type
  local version
  local services=()

  version="${1:?}"
  volume_type="${2:?}"
  shift 2
  services=( "$@" )

  docker_compose "${version}" "${GENERIC_VOLUME_TYPE:?}" config > temp.yaml
  if [ ${#services[@]} -eq 0 ]; then
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services" temp.yaml
  fi

  for service in "${services[@]}"
  do
    echo "------ '$service'  --------"
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq e ".services.$service" temp.yaml
    echo "---------------------------"
    echo
  done

  rm temp.yaml
}

docker_compose() {
  local volume_type
  local version
  local services=()
  version="${1}"
  volume_type="${2:?}"
  shift 2
  services=( "$@" )

  if [[ "$version" == "latest" ]]; then
    # Remove ALPINE_TAG= line in .env
    grep -v '^ALPINE_TAG=' "$SRC_ROOT/.env" > "$SRC_ROOT/.env-temp"
    echo 'ALPINE_TAG=latest' >> "$SRC_ROOT/.env-temp"
    DEV_UID=1000 DEV_GID=1000 docker-compose \
      -f "$SRC_ROOT/docker-compose.yml" \
      -f "$SRC_ROOT/docker-compose-volume-${volume_type}-${HOST_OS}.yml" \
      --env-file "$SRC_ROOT/.env-temp" ${services[@]}
    rm "$SRC_ROOT/.env-temp"
  else
    DEV_UID=1000 DEV_GID=1000 docker-compose \
      -f "$SRC_ROOT/docker-compose.yml" \
      -f "$SRC_ROOT/docker-compose-volume-${volume_type}-${HOST_OS}.yml" \
      --env-file "$SRC_ROOT/.env" ${services[@]}
  fi

}

function _getopt_docker() {
  local short_opts="${1:?}"
  local long_opts="${2:?}"
  shift 2

  local opt_command='getopt $@'
  local command_string="set -- -o '${short_opts}' --long '${long_opts}' -- ${@} && ${opt_command}"

  docker run --rm -it alpine:latest sh -c "$command_string"
}

function _getopt_host() {
  local short_opts="${1:?}"
  local long_opts="${2:?}"
  shift 2

  local opts_args=(-o "${short_opts}" --long "${long_opts}" -- "${@}")

  getopt "${opts_args[@]}"
  return $?
}

function _getopt() {
  if [[ $HOST_OS == "macos" ]]; then
    if [[ "$(getopt -V)" == " --" ]]; then
      _getopt_docker "${@}"
      return $?
    fi
  fi

  _getopt_host "${@}"
  return $?
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
