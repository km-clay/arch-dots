#!/bin/zsh

export WORK_IP="$(cat ~/.env/WORK_IP)"
export PROD_IP="$(cat ~/.env/PROD_IP)"
export PROD_USER="$(cat ~/.env/PROD_USER)"

srvcmd() {
	ssh "$USER"@"$WORK_IP" "$*"
}

prodcmd() {
	local cmd=$(printf '%q ' "$@")
	srvcmd "ssh $PROD_USER@$PROD_IP $cmd"
}
