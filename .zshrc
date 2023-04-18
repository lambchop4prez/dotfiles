# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PYENV_ROOT=$HOME/.pyenv

ZSH_THEME="kolo"

plugins=(git dotnet macos helm kubectl)

source $ZSH/oh-my-zsh.sh

# Aliases
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'

# Autocompletion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
command -v flux >/dev/null && . <(flux completion zsh)

# Direnv allows for .envrc files to be loaded when you CD into them.
eval "$(direnv hook zsh)"

# Pyenv setup
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"