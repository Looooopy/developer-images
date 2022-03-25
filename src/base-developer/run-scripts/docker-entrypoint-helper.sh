#!/usr/bin/env bash

# NOTE:
# All these scripts run in the context of user and not root

clone_multiple() {
  if (($# == 0)); then
    >&2 echo " - No project(s) was defined to be clone look into .env CLONE_PROJECT_{X} to set a valid path"
  fi

  local all_errors=1

  for url in "$@"
  do
    local project_name
    project_name="$(get_project_name "$url")"

    if [[ -d "$project_name" ]]; then
      >&2 echo " - Project '$url' already cloned"
      all_errors=0
    elif cloning "$url"; then
      echo " - Project '$url' cloned"
      all_errors=0
    else
      >&2 echo " - Project '$url' failed"
    fi
  done

  return ${all_errors}
}

cloning() {
  local url="${1:?}"
  local valid_ssh_clone_url='^git@github.com:(((:?)|(\/))([A-Za-z0-9.\-]+?))+(\.git){1}$'
  if [[ $url =~ $valid_ssh_clone_url ]]; then
    # TODO: redirect stderr so it is quiet then
    #       parse the stderr for "ERROR: Repository not found."
    git clone "$url" --quiet && return 0
    return $?
  else
    >&2 echo "'$url' is not a valid and will not be cloned" && return 1
  fi
}

get_project_name() {
    echo "${1}" | sed -r 's/.+\/([^.]+)(\.git)?/\1/'
}

get_project_name_if_only_one () {
  if (($# == 1)); then
    get_project_name "${1}"
  fi
}

main() {
  local mode="$1"

  if (($# >= 1)); then
    [[ "$1" == "clone" ]] && shift
    [[ "$1" == "standard" ]] && shift
  fi

  case "$mode" in
    standard)
      echo "Standard mode"
    ;;
    clone)
      local project_name
      echo "Clone mode"
      if clone_multiple "$@"; then
        project_name="$(get_project_name_if_only_one "$@")"
        [[ -n "$project_name" ]] && [[ -d "/projects/$project_name" ]] && cd "$project_name"
      fi
    ;;
    *)
      echo "Bypass mode"
      # bash
      bash -l

      return;
    ;;
  esac

  if [[ -n "${EXECUTE_PROCESS}" ]]; then
    local extra_args=()
    if [[ -n "${EXECUTE_PROCESS_EXTRA_ARGS}" ]]; then
      extra_args=(${EXECUTE_PROCESS_EXTRA_ARGS})
    fi

    if [[ -z "${EXECUTE_PROCESS_NO_ARGS}" ]]; then
      [[ -n "${VERBOSE}" ]] && echo "executing command: ${EXECUTE_PROCESS} ${extra_args[@]} $@"
      ${EXECUTE_PROCESS} "${extra_args[@]}" "$@"
    else
      [[ -n "${VERBOSE}" ]] && echo "executing command: ${EXECUTE_PROCESS} ${extra_args[@]}"
      ${EXECUTE_PROCESS} "${extra_args[@]}"
    fi
  fi
}
