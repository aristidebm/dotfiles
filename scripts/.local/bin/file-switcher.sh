#!/usr/bin/env sh

function switch () {
    local BIN="$HOME/.local/bin/"
    source "$BIN/opener.sh"
    source "$BIN/fuzzy-picker.sh"

    # Find a way to fix so that it works
    # Currently since the script is called
    # using bass source ./local/bin/fz (because
    # this script use cd, the problem is explained here https://www.baeldung.com/linux/cd-command-bash-script), the number of programs
    # is 2 bass and source, but we don't want the
    # script to know how it is called ()
    # local file=$(pick ${@:1})
    local file=$(pick $HOME)

    if [[ -d "$file" ]]; then
        zoxide_running=$(pgrep zoxide)
        if [[ -z $zoxide_running ]]; then
            zoxide add $file
        fi
        cd "$file"
    elif [[ -f "$file" ]]; then
        open "$file"
    fi
}

switch $@
