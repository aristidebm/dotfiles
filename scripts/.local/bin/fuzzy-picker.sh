function clip {
    if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        wl-copy $@
    else
        xclip -sel clip $@
    fi
}

function pick() {
    local cwd=${@:1}

    if [[ $# -eq 0 ]] ; then
        cwd="."
    fi

    local select=$(fd . --exclude '.git' --type d $cwd | fzf --exact --scroll-off=8 --multi \
        --reverse \
        --preview="tree -C {} | head -n 60" \
        --preview-window="45%,border-sharp" \
        --bind="ctrl-j:toggle-preview" \
        --prompt="Dirs > "\
        --bind="ctrl-d:change-prompt(Dirs > )" \
        --bind="ctrl-d:+reload(fd . --exclude '.git' --type d $cwd)" \
        --bind="ctrl-d:+change-preview(tree -C {} | head -n 60)" \
        --bind="ctrl-d:+refresh-preview" \
        --bind="ctrl-f:change-prompt(Files > )" \
        --bind="ctrl-f:+reload(fd . --exclude '.git' --type f $cwd)" \
        --bind="ctrl-f:+change-preview(bat --color=always --style=numbers --line-range=:500 {})" \
        --bind="ctrl-f:+refresh-preview" \
        --bind="ctrl-y:execute-silent(echo \"{}\" | xclip -selection clipboard)" \
        --bind "ctrl-/:change-preview-window(down|hidden|)" \
        --bind '?:toggle-header' \
        --header "^d: dirs ^f: files ^y: yank path ^/: toggle preview ?: toggle help" \
        2>/dev/tty
        )
    echo $select
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    pick $HOME
fi
