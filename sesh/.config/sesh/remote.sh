#!/usr/bin/env sh

REMOTE=$1
if [ -z $REMOTE ]; then
    exit 1
fi

ssh -t $REMOTE tmux new -A -s "aristide@$REMOTE" \; set-window-option -g mode-keys vi \; set-option -g status-keys vi
