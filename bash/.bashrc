# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.docker_aliases ]] && source ~/.docker_aliases

# environment variables
[[ -f "$HOME/.xprofile" ]] && source "$HOME/.xprofile"

# Options

# set -o vi

# Keybindings
# The list of all available readline command are here
# https://web.archive.org/web/20150403162757/http://linux.about.com/library/cmd/blcmdl3_readline.htm

# check bash is built with readline before calling readline functions
# like bind and complete
if [[ $- == *i* ]] && complete &>/dev/null 2>&1; then
    # Only load if readline is available
    [[ -f "/usr/share/fzf/key-bindings.bash" ]] && source "/usr/share/fzf/key-bindings.bash"
fi

if [[ $- == *i* ]] && bind -V &>/dev/null 2>&1; then
    bind -m vi-command -r '\ec'
    bind -m vi-insert -r '\ec'
    bind -m vi-command 'Control-l: clear-screen'
    bind -m vi-insert 'Control-l: clear-screen'
    bind -m vi-insert 'Control-p: previous-history'
    bind -m vi-insert 'Control-n: next-history'
fi

PS1='[\u@\h \W]\$ '

# source starship prompt
command -v starship &> /dev/null && eval "$(starship init bash)"

# source the zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init bash)"

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi
