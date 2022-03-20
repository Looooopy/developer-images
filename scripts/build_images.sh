#!/usr/bin/env bash

# Declared in common.sh
# AVAILABLE_SERVICES
# echo_docker_compose_config
# docker_compose

function _build_usage() {
  echo 'Usage: ./build [-hnvsa]'
  echo '╔══════════════════════╤══════════╤═══════════╤═════════════════════════════════════════════════════════════╗'
  echo '║ Switch               │ Args     │ Default   │ Description                                                 ║'
  echo '║ -h --help            │          │           │ Prints this usage screen                                    ║'
  echo '║ -n --no-cache        │          │           │ Build without docker cache                                  ║'
  echo '║ -f --force-plugins   │          │           │ Rebuild part of image "plugins"                             ║'
  echo '║ -v --version         │ [arg1]   │ latest    │ Build version arg1=latest or specific                       ║'
  echo "║ -s --service         │ [arg1]   │           │ Build services ${AVAILABLE_SERVICES:?}                       ║"
  echo '║                      │          │           │   - Option can be specified multiple times                  ║'
  echo '║                      │          │           │   - Deplicates are removed from tail                        ║'
  echo '║                      │          │           │   - Order of options is the build order                     ║'
  echo "║ -a --all-services    │          │           │ Build all service in following order ${AVAILABLE_SERVICES:?} ║"
  echo '╚══════════════════════╧══════════╧═══════════╧═════════════════════════════════════════════════════════════╝'
}

function _parse_build_options() {
  local valid_args
  local short_opts='hnv:fs:a'
  local long_opts='help,no-cache,version:,force-plugins,service:,all-services'

  if ! valid_args="$(_getopt "${short_opts}" "${long_opts}" "$@" 2>/dev/null)"; then
    local error
    error=$(_getopt "${short_opts}" "${long_opts}" "$@"  2>&1 > /dev/null)

    _build_usage
    >&2 echo
    >&2 echo "Error: $error"
    >&2 echo

    return 1;
  fi

  eval  set -- "$valid_args"
  while true; do
    case "$1" in
      -a | --all-services)
        [[ -n "${VERBOSE}" ]] && echo "  --all-services (-a)"
        all_services='true'
        shift
      ;;
      -h | --helper)
        [[ -n "${VERBOSE}" ]] && echo "  --help (-v)"
        _build_usage
        return 1
        break;
      ;;
      -n | --no-cache)
        [[ -n "${VERBOSE}" ]] && echo "  --no-cache (-n)"
        no_cache="--no-cache"
        shift
      ;;
      -v | --version)
        [[ -n "${VERBOSE}" ]] && echo "  --version (-v) (arg: $2)"
        version="$2"
        shift 2
      ;;
      -f | --force-plugins)
        [[ -n "${VERBOSE}" ]] && echo "  --force-plugins (-f)"
        forece_plugins=yes
        shift
      ;;
      -s | --service)
        [[ -n "${VERBOSE}" ]] && echo "  --service (-s) (arg: $2)"
        # No duplicates allowed
        case "${services_short[@]}" in
          *"$2"*)
            [[ -n "${VERBOSE}" ]] && echo "    - '$2' service is a duplicate, use only the one from head"
            shift 2
          ;;
          *)
            [[ -n "${VERBOSE}" ]] && echo "    - '$2' service is not present, adding"
            services_short+=("$2")
            shift 2
          ;;
        esac
      ;;
      --)
        [[ -n "${VERBOSE}" ]] && echo "  >> Last option detected <<"
        shift;
        break
      ;;
    esac
  done
}

_validate_build_parse_result() {
  if [[ "$version" != 'latest' ]] && [[ "$version" != 'specific' ]]; then
    _build_usage

    >&2 echo
    >&2 echo "Error: --version (-v) can only be 'latest' or 'specific' was: $version"
    >&2 echo
    return 1
  fi

  if (("${#services_short[@]}" == 0)) && [[ -z "$all_services" ]]; then
    _build_usage
    >&2 echo
    >&2 echo "Error: Required option --service or --all-services"
    >&2 echo
    return 1
  fi
}

build() {
  local version='latest'
  local no_cache=''
  local all_services
  local services_short=()
  local services=()
  local build_args=()
  local forece_plugins=''
  local valid_args

  if ! _parse_build_options "$@"; then
    return 1
  fi

  if ! _validate_build_parse_result; then
    return 1
  fi

  if [[ -n "$all_services" ]]; then
    services_short=(all)
  else
    [[ -n "${VERBOSE}" ]] && echo "Remove all other services if contains 'all'"
    case "${services_short[@]}" in  *"all"*) services_short=(all);; esac
  fi

  if [[ -n $forece_plugins ]]; then
    [[ -n "${VERBOSE}" ]] && echo "Adding --build-arg FORCE_UPDATE_PLUGINS=yes'"
    build_args+=('--build-arg' 'FORCE_UPDATE_PLUGINS=yes' )
  fi

  for service in "${services_short[@]}"
  do
    case $service in
      tmux | nvim | base )
        services+=("$service-developer_$version")
      ;;
      all )
        services=("base-developer_$version" "tmux-developer_$version" "nvim-developer_$version")
      ;;
      *)
        _build_usage
        >&2 echo
        >&2 echo "service='$1' not an allowed service, use one of these ${AVAILABLE_SERVICES:?}"
        >&2 echo
        return 1
      ;;
    esac
  done

  [[ -n "${VERBOSE}" ]] && echo_docker_compose_config "${version}" "${GENERIC_VOLUME_TYPE:?}" "${services[@]}"
  for service in "${services[@]}"; do
    if ! docker_compose build "${version}" "${GENERIC_VOLUME_TYPE:?}" "${no_cache}" "${build_args[@]}" "${service}"; then
      return 1;
    fi
  done
}
