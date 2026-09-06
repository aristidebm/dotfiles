#!/usr/bin/env sh

agent_cmd=$1

if test -z $agent_cmd; then
  agent_cmd="opencode"
fi

# run neovim in the first window pane
tmux send-keys "nvim ." Enter
tmux rename-window "editor"

# create two consecutive windows
tmux new-window
tmux rename-window "terminal"

tmux new-window
tmux send-keys "$agent_cmd" Enter
tmux rename-window "agent"

# create a window that contains a shell to interact with the database
tmux new-window
tmux send-keys "make dbshell" Enter

# Go back to the editor
tmux select-window -t 1
