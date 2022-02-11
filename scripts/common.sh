#!/usr/bin/env bash

export SRC_ROOT=./src

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
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    HOST_OS="macos"
  else
    HOST_OS="linux"
  fi
  export_dot_env HOST_OS
}

export_os_specific() {
  case "${HOST_OS:?}" in
    wsl2)
    ;;
    macos)
    ;;
    linux)
    ;;
    default)
    ;;
  esac
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
    if [[ -n "$(grep -v '^#' "$env_file" | grep ^"$specfic_value")" ]]; then
      echo "Exporting spcific '$specfic_value'"
      export $(grep -v '^#' "$env_file" | grep ^"$specfic_value" | xargs -0)
    else
      echo "'$specfic_value' in '$env_file' do not exist"
    fi
  fi
}


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
    docker_compose "${GENERIC_VOLUME_TYPE:?}" down --volumes
  fi
}

function _build_usage() {
    echo 'Usage: ./build [-hnvsa]'
    echo '--------------------------------------------------------------------------------------------------------------'
    echo '   Switch             Args            Default   Description'
    echo '   -h --help                                    Prints this usage screen'
    echo '   -n --no-cache                                Build without docker cache'
    echo '   -f --force-plugins                           Rebuild part of image "plugins"'
    echo '   -v --version       [arg1]          latest    Build version arg1=latest or specific'
    echo '   -s --service       [arg1]                    Build services "nvim", "tmux", "base"'
    echo '                                                 - Option can be specified multiple times'
    echo '                                                 - Deplicates are removed from tail'
    echo '                                                 - Order of options is the build order'
    echo '   -a --all-services                            Build all service in following order "base", "nvim", "tmux"'
    echo '--------------------------------------------------------------------------------------------------------------'
}

function _parse_build_options() {
  local valid_args
  local short_opts='hnv:fs:a'
  local long_opts='help,no-cache,version:,force-plugins,service:,all-services'
  local opts_args=(-o "${short_opts}" --long "${long_opts}" -- "$@")

  valid_args=$(getopt "${opts_args[@]}" 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    local error=$(getopt "${opts_args[@]}" 2>&1 > /dev/null)
    echo
    echo "Error: $error"
    echo
    _build_usage
    return 1;
  fi

  eval set -- "$valid_args"
  while [ : ]; do
      case "$1" in
          -a | --all-services)
              #echo "--all-services"
              all_services='true'
              shift
            ;;
          -h | --helper)
              #echo "--help"
              _build_usage
              return 1
              break;
            ;;
          -n | --no-cache)
              #echo "--no-cache option"
              no_cache="--no-cache"
              shift
              ;;
          -v | --version)
              #echo "--version option (arg: $2)"
              version="$2"
              shift 2
              ;;
          -f | --force-plugins)
              #echo "--force-plugins option"
              forece_plugins=yes
              shift
              ;;
          -s | --service)
              #echo "--service option (args: $2)"
              # No duplicates allowed
              case "${services_short[@]}" in
                *"$2"*)
                    #echo " ' - $2' service is a duplicate, use only the one from head"
                    shift 2
                    ;;
                *)
                  services_short+=("$2")
                  shift 2
                  ;;
              esac
              ;;
          --) shift;
              break
              ;;
      esac
  done
}

build() {
  local version='latest'
  local no_cache=''
  local all_services
  local services_short=()
  local services=()
  local forece_plugins=''
  local valid_args
  local force=all

  if ! _parse_build_options "$@"; then
    return 1
  fi

  if [[ "$version" != 'latest' ]] && [[ "$version" != 'specific' ]]; then
     >&2 echo "--version (-v) can only be 'latest' or 'specific' was: $version"

     _build_usage
     return 1
  fi

  local build_args=()
  if [[ -n $forece_plugins ]]; then
      build_args+=('--build-arg' 'FORCE_UPDATE_PLUGINS=yes' )
  fi

  if (("${#services_short[@]}" == 0)) && [[ -z "$all_services" ]]; then
    # Default
    >&2 echo "You must specify either option --service or --all-services"
    >&2 echo
    _build_usage
  elif [[ -n "$all_services" ]]; then
    services_short=(all)
  else
    # Remove all other services if contains 'all'
    case "${services_short[@]}" in  *"all"*) services_short=(all);; esac
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
        >&2 echo "service='$1' not an allowed service, allowed 'tmux', 'nvim' and 'base'"
        _build_usage
        return 1
        ;;
    esac
  done

  echo_docker_compose_config "${services[@]}"
  docker_compose "${GENERIC_VOLUME_TYPE:?}" build "${no_cache} ${build_args[@]} ${services[@]}"
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
    tmux | nvim | base )
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
      echo_docker_compose_config "${service}"
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
