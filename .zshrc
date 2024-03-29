# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PYENV_ROOT=$HOME/.pyenv

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# Aliases
alias gs='git status'
alias gc='git commit'
alias gp='git pull'

# Autocompletion
autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform
command -v flux >/dev/null && . <(flux completion zsh)

# Direnv allows for .envrc files to be loaded when you CD into them.
# eval "$(direnv hook zsh)"

# Pyenv setup
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(rbenv init - zsh)"

# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
# source <(ng completion script)

autoload -Uz promptinit && promptinit && prompt pure
