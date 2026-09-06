#!/usr/bin/env sh

# run neovim in the first pane
tmux send-keys "nvim ." Enter

# create two consecutive windows
tmux new-window
tmux new-window

# connect to backend database
tmux new-window
container_name="tmp-postgres-1"
if [ $( docker container inspect -f '{{.State.Running}}' $container_name ) = "false" ]
then
    tmux send-keys "docker start $container_name" Enter
fi
tmux send-keys 'pgcli --dsn daemon' Enter

# select the first window
tmux select-window -t 1
