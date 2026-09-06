#!/usr/bin/env sh

agent_cmd=$1

if test -z $agent_cmd; then
  agent_cmd="opencode"
fi

# run neovim in the first pane
tmux send-keys "nvim ." Enter

# create two consecutive windows
tmux new-window
tmux rename-window "terminal"

tmux new-window
tmux send-keys "$agent_cmd" Enter
tmux rename-window "agent"

# select the first window
tmux select-window -t 1
