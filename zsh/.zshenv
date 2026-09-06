# for more information check the link below
# https://gist.github.com/fredjoseph/e81be37b8605590ef7f4cfaef1f476d2

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# zsh base dir
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# bun
export BUN_INSTALL="$HOME/.local/share/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# I have to set this manually, for some reason, that environment
# variable was just screw up and I don't know why
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$XDG_DATA_DIRS"
