#!/usr/bin/env bash

echo_error() {
  RED='\033[0;31m'
  NC='\033[0m'
  >&2 echo -e "$RED$1$NC"
}

install-tree-sitter-langs() {
  local treesitter_languages=($(cat $XDG_CONFIG_HOME/temp/treesitter/active-langs))
  local errors=()
  for language in "${treesitter_languages[@]}"; do
      nvim --headless +"TSInstallSync ${language}" +q
      if [ $? -ne 0 ]; then
          errors+=(" - Lang: '$language' Error: '$?'")
      fi
  done

  if [ ${#errors[@]} -ne 0 ]; then
    echo_error
    for e in "${errors[@]}"; do
      echo_error "$e"
    done
    exit 1
  fi
}

install-tree-sitter-langs
