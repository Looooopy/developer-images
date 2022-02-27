#!/usr/bin/env bash

# Declared in common.sh
# __services
# export_dot_env
# echo_docker_compose_config
# docker_compose

function _run_usage() {
  echo 'Usage: ./run [-hrvs]'
  echo '------------------------------------------------------------------------------------------------------------'
  echo '   Switch             Args            Default   Description'
  echo '   -h --help                                    Prints this usage screen'
  echo '   -r --run-arg       [arg1]                    Argument should be passed to docker run'
  echo '                                                  - Option can be specified multiple times'
  echo '   -v --version       [arg1]          latest    Run version arg1=latest or specific'
  echo "   -s --service       [arg1]                    Run service ( ${__services} )"
  echo '------------------------------------------------------------------------------------------------------------'
}

function _parse_run_options() {
  local valid_args
  local short_opts='hr:v:s:'
  local long_opts='help,run-arg:,version:,service:'

  valid_args=$(_getopt "${short_opts}" "${long_opts}" "$@" 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    local error=$(_getopt "${short_opts}" "${long_opts}" "$@" 2>&1 > /dev/null)

    _run_usage

    >&2 echo
    >&2 echo "Error: $error"
    >&2 echo

    return 1;
  fi

  [[ -n "${VERBOSE}" ]] && echo "Parsing options"
  eval set -- "$valid_args"
  while [ : ]; do
    case "$1" in
      -h | --helper)
        [[ -n "${VERBOSE}" ]] && echo "  --help"
        _run_usage
        return 1
        break;
      ;;
      -r | --run-arg)
        [[ -n "${VERBOSE}" ]] && echo "  --version option (arg: $2)"
        run_args+=("$2")
        shift 2
      ;;
      -v | --version)
        [[ -n "${VERBOSE}" ]] && echo "  --version option (arg: $2)"
        version="$2"
        shift 2
      ;;
      -s | --service)
        [[ -n "${VERBOSE}" ]] && echo "  --service option (args: $2)"
        services_short+=("$2")
        shift 2
      ;;
      --)
        [[ -n "${VERBOSE}" ]] && echo "  >> Last option detected <<"
        shift;
        break
      ;;
    esac
  done
}

_validate_run_parse_result() {
  if (("${#services_short[@]}" != 1)); then
    _run_usage

    if (("${#services_short[@]}" > 1)); then
      >&2 echo
      >&2 echo "Error: You should only define a single service (${services_short[@]})"
      >&2 echo
    fi

    if (("${#services_short[@]}" == 0)); then
      >&2 echo
      >&2 echo "Error: Required option --service"
      >&2 echo
    fi

    return 1
  fi

  case "${services_short[0]}" in
    tmux | nvim | base )
      service="${services_short[0]}-developer_$version"
    ;;
    *)
      >&2 echo "Error: Not an allowed service (${services_short[0]}), use 'tmux', 'nvim' or 'base'"
      return 1
    ;;
  esac
}

run() {
  local run_args
  local version
  local services_short
  local service

  services_short=()
  run_args=()
  version="latest"

  if ! _parse_run_options "$@"; then
    return 1
  fi

  if ! _validate_run_parse_result; then
    return 1
  fi

  if [ -z ${GENERIC_VOLUME_TYPE+x} ]; then
    export_dot_env GENERIC_VOLUME_TYPE
  else
    [[ -n "${VERBOSE}" ]] && echo 'Exporting already defined "GENERIC_VOLUME_TYPE" from shell'
    export GENERIC_VOLUME_TYPE
  fi

  [[ "${GENERIC_VOLUME_TYPE:?'GENERIC_VOLUME_TYPE must be either "container" or "localhost"'}" ]]

  case "${GENERIC_VOLUME_TYPE:?}" in
    container | localhost)
      [[ -n "${VERBOSE}" ]] && echo_docker_compose_config "${version}" "${GENERIC_VOLUME_TYPE:?}" "${service}"
      docker_compose "${version}" "${GENERIC_VOLUME_TYPE:?}" run --rm "$service" "${run_args[@]}"
    ;;
    *)
      >&2 echo 'Unknown Volume type must be either "container" or "localhost"'
      return 1
    ;;
  esac
}
