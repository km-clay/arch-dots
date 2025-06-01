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

unalias ls
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
