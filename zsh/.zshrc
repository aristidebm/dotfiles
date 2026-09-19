# # Load and initialise completion system
autoload -Uz compinit
compinit

# set emacs keybinding
bindkey -e

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

# Load db-cli completion
command -v db-cli >/dev/null 2>&1 && eval "$(db-cli completion zsh)"

# atuin
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
    # undo what atuin does
    bindkey '^[[A' up-line-or-history
fi

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi
