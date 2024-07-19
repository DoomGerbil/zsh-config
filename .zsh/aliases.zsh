#!/usr/bin/env zsh

# Capture all of the manually defined aliases used in my ZSH configuration
# Where needed, call compdef to wire through completion configuration to the alias as well

# ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -G'

# git
alias gca='git commit --amend -a --no-edit'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gl='git log'
alias gll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
alias gls='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
alias gci='git branch | grep -v "^\*" | fzf --height=20% --reverse --info=inline | xargs git checkout'
alias gundo='git reset --soft HEAD~1'

# Kube* tools
alias k='kubectl'
compdef k=kubectl

alias kx='kubectx'
compdef kubectx
compdef kctx=kubectx

alias ks='kubens'
compdef ks=kubens

# Other stuff
alias bazel='bazelisk'
compdef bazelisk=bazel

# Configuration required for granted/assume to work correctly
alias assume="source assume"

# This absolutely, ridiculously stupid alias makes the 'watch' command work with aliases
# https://unix.stackexchange.com/a/25329
alias watch='watch '
