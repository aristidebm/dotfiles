#!/usr/bin/env sh

REMOTE=$1
if [ -z $REMOTE ]; then
    exit 1
fi

ssh -t $REMOTE tmux new -A -s "aristide@$REMOTE"

# # Add three more windows
# tmux split-window -h
# tmux split-window
# tmux select-pane -t 1
#
# tmux setw synchronize-panes on
# tmux send-keys "ssh $REMOTE" Enter
#
# # Create a window in copy mode
# # so that synchronize-panes on won't
# # be applied on it.
# tmux split-window \; copy-mode
# tmux select-pane -t 1
