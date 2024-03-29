#!/usr/bin/env bash

export SRC_ROOT=./src

export AVAILABLE_SERVICES='"base", "tmux", "nvim"'

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

  docker_compose config "${version}" "${GENERIC_VOLUME_TYPE:?}" > temp.yaml
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

  [[ -f temp.yaml ]] && rm temp.yaml
}

docker_compose() {
  local volume_type
  local version
  local compose_cmd
  local compose_cmd_args
  local runtime_compose=''

  compose_cmd="${1:?'Missing docker-compose command'}"
  version="${2:?'Missing version (latest or specific)'}"
  volume_type="${3:?'Missing volume type'}"
  shift 3
  compose_cmd_args=( "$@" )

  if [[ "${compose_cmd}" != 'build' ]]; then
    runtime_compose=(-f "$SRC_ROOT/docker-compose-volume-${volume_type}-${HOST_OS}.yml")
  fi

  if [[ "$version" == "latest" ]]; then
    # Remove ALPINE_TAG= line in .env
    grep -v '^ALPINE_TAG=' "$SRC_ROOT/.env" > "$SRC_ROOT/.env-temp"
    echo 'ALPINE_TAG=latest' >> "$SRC_ROOT/.env-temp"

    # shellcheck disable=SC2068
    if ! docker-compose \
      -f "$SRC_ROOT/docker-compose.yml" \
      ${runtime_compose[@]} \
      --env-file "$SRC_ROOT/.env-temp" "${compose_cmd}" ${compose_cmd_args[@]};
    then
      [[ -f "$SRC_ROOT/.env-temp" ]] && rm "$SRC_ROOT/.env-temp"
      return 1;
    fi
    [[ -f "$SRC_ROOT/.env-temp" ]] && rm "$SRC_ROOT/.env-temp"
    return 0
  else
    # shellcheck disable=SC2068
    if ! docker-compose \
      -f "$SRC_ROOT/docker-compose.yml" \
      ${runtime_compose[@]} \
      --env-file "$SRC_ROOT/.env" "${compose_cmd}" ${compose_cmd_args[@]};
    then
      return 1;
    fi
    return 0
  fi
}

function _getopt_docker() {
  local short_opts="${1:?}"
  local long_opts="${2:?}"
  shift 2

  local opt_command='getopt $@'
  # shellcheck disable=SC2124
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
  local specific_value
  local env_file

  specific_value=$1
  env_file="$SRC_ROOT"/.env

  if [ -z ${specific_value} ]; then
    [[ -n "${VERBOSE}" ]] && >&2 echo "Exporting all from $env_file"
    # double dash params do not work in busybox like: --invert-match --quiet, dont use it
    # shellcheck disable=SC2046
    export $(grep -v '^#' "$env_file" | xargs -0)
  else
    if grep -v '^#' "$env_file" | grep -q ^"$specific_value"; then
      [[ -n "${VERBOSE}" ]] && >&2 echo "Exporting specific '$specific_value'"
      # shellcheck disable=SC2046
      export "$(grep -v '^#' "$env_file" | grep ^"$specific_value" | xargs -0)"
    else
      [[ -n "${VERBOSE}" ]] && >&2 echo "'$specific_value' in '$env_file' do not exist"
      return 1
    fi
  fi

  return 0
}
