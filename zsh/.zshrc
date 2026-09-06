[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# plugins.
# plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"

# # Load and initialise completion system
autoload -Uz compinit
compinit

# zsh highlighting settings
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'

# options
# https://github.com/jeffreytse/zsh-vi-mode
ZVM_VI_HIGHLIGHT_FOREGROUND=#C6D0F5
ZVM_VI_HIGHLIGHT_BACKGROUND=#414559
ZVM_CURSOR_STYLE_ENABLED=false

# set emacs keybinding
bindkey -e

# [[ -f "/usr/share/fzf/key-bindings.zsh" ]] && source "/usr/share/fzf/key-bindings.zsh"

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5C' forward-word
bindkey '^[[5D' backward-word

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.docker_aliases ]] && source ~/.docker_aliases

# source direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# source starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# source the zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

command -v bob >/dev/null 2>&1 && eval "$(bob complete zsh)"

# Load db-cli completion
command -v db-cli >/dev/null 2>&1 && eval "$(db-cli completion zsh)"

# Load safe-rm completion
command -v safe-rm >/dev/null 2>&1 && eval "$(safe-rm completion zsh)"

# atuin
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
    # undo what atuin does
    bindkey '^[[A' up-line-or-history
fi

# kilo
export PATH=/home/aristide/.kilo/bin:$PATH

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi
