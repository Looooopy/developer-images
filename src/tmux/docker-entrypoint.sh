#!/usr/bin/env bash

set -e

clone_multiple() {
  if (($# == 0)); then
    >&2 echo " - No project was defined to clone"
  fi

  for url in "$@"
  do
    local project_name="$(get_project_name "$url")"
    if [[ -d "$project_name" ]]; then
      >&2 echo " - Project '$url' already cloned"
    elif cloning "$url"; then
      echo " - Project '$url' cloned"
    else
      >&2 echo " - Project '$url' failed"
    fi
  done
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
    local res_and_project_match='^.*\/([A-Za-z0-9.\-]+)\.git{1}$'
    if [[ $1 =~ $res_and_project_match ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
}

get_project_name_if_only_one () {
  if (($# == 1)); then
    get_project_name "$1"
  fi
}

main() {
  local mode="$1"

  if (($# >= 1)); then
  shift
  fi

  case "$mode" in
    tmux)
      echo "Standard mode"
      echo " - exec tmux in folder '$PWD'"
      exec tmux "$@"
      return;
      ;;

    clone)
      echo "Clone mode"
      clone_multiple "$@"
      local project_name="$(get_project_name_if_only_one "$@")"
      [[ -n "$project_name" ]] && cd "$project_name"
      echo " - exec tmux in folder '$PWD'"
      exec "tmux"
      return;
      ;;

    *)
      echo "Bypass mode"
      exec "$@"
      return;
      ;;
  esac
}

main "$@"
