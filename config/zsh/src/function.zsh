#!/bin/zsh

typeset -gA LOADED_MODULES

mkcd() {
	mkdir -p "$1" && cd "$1"
}

cd() {
	local prev_sounds_enabled="$SOUNDS_ENABLED"
	export SOUNDS_ENABLED=0
	eza -1 --group-directories-first --icons "$@"
	export SOUNDS_ENABLED=$prev_sounds_enabled
	builtin cd "$@"
	playshellsound "$HOME"/dotfiles/assets/sound/cd.wav
	return 0
}

unalias ls &> /dev/null
ls() {
	eza -1 --group-directories-first --icons "$@"
	playshellsound "$HOME"/dotfiles/assets/sound/ls.wav
	return 0
}

gitcommit_sfx() {
	output=$(git commit "$@")
	if [ -n "$output" ]; then
		playshellsound "$HOME"/dotfiles/assets/sound/gitcommit.wav
		echo "$output" | color-commit
		return 0
	else
		playshellsound "$HOME"/dotfiles/assets/sound/error.wav
		echo "$output"
		return 1
	fi
}
gitpush_sfx() {
	if git push "$@"; then
		playshellsound "$HOME"/dotfiles/assets/sound/gitpush.wav
		return 0
	else
		playshellsound "$HOME"/dotfiles/assets/sound/error.wav
		return 1
	fi
}

sourcemod() {
	if [[ -z "$ZSH_SOURCE" ]]; then
		echo "ZSH_SOURCE env var is unset"
		return 1
	fi
	if [[ $# -eq 0 ]]; then
		echo "Usage: sourcemod <module_name>"
		return 0
	fi
  local mod="$ZSH_SOURCE/modules/$1.zsh"
  if [[ -f "$mod" ]]; then
    if [[ -z "${LOADED_MODULES[$1]}" ]]; then
      source "$mod"
      LOADED_MODULES[$1]=1
    else
      echo "Module '$1' already loaded."
    fi
  else
    echo "Module '$1' not found in $ZSH_SOURCE/modules/"
  fi
}
