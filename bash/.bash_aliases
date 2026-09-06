alias grep='grep --color=auto'
alias cal='cal -m'
alias fcd='source $HOME/.local/bin/file-switcher.sh'
alias notes='nvim /tmp/notes.md'
# alias ls='lsd'
alias pass='gopass'

# cava custom color does not work
# in tmux (https://github.com/karlstav/cava/issues/339)
alias cava="TERM=st-256color cava"
function mkcd() {
    mkdir -p $1; cd $1
}

function rm {
    command -v safe-rm &> /dev/null && safe-rm $@ || command rm $@
}
