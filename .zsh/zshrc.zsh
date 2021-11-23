#! /usr/bin/env zsh

# Base helpers for PATH mangling

pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

pathprepend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

# Sets up FZF fuzzy finder if it's installed (brew install fzf)
# If ripgrep is installed (brew install ripgrep) configures fzf to use it
command -v "fzf" >"/dev/null" && \
  export FZF_BASE="/usr/local/opt/fzf" && \
  export DISABLE_FZF_AUTO_COMPLETION="false" && \
  export DISABLE_FZF_KEY_BINDINGS="false" && \
  export FZF_DEFAULT_OPTS='--height 40% --border' && \
  command -v "rg" >"/dev/null" && \
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Enable Python for the platform repo
export SCRIPT_FEATURE_FLAG_PYTHON=1

# Enable Powerlevel10k instant prompt. Should stay close to the top of the zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Assumes that Powerlevel 10K is installed already
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Install some omzsh plugins if they're not already there
[[ -r "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
[[ -r "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

# Powerlevel 10K
# To customize, run `p10k configure` or edit ${ZSHRC}/p10k.zsh.
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -r "${ZSHRC}/p10k.zsh" ]] && \
  source "${ZSHRC}/p10k.zsh"

# Configure and activate omzsh
COMPLETION_WAITING_DOTS="true"
HYPHEN_INSENSITIVE="true"

# This is my set of OMZSH plugins, but others might want a different set
# Comment out any you don't want, or add new ones from https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=()
plugins+=(aliases)
plugins+=(aws)
plugins+=(bazel)
plugins+=(direnv)
plugins+=(docker)
plugins+=(fzf)
plugins+=(gcloud)
plugins+=(gh)
plugins+=(git)
plugins+=(helm)
plugins+=(history)
plugins+=(iterm2)
plugins+=(pyenv)
plugins+=(kubectl)
plugins+=(terraform)
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)

source "${ZSH}/oh-my-zsh.sh"

# Make zsh shortcuts break on "/", like in Bash
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Configure some legacy Golang stuff
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Do some arbitrary PATH mangling
pathprepend "${GOBIN}"
pathprepend "/usr/local/sbin"
pathprepend "${HOME}/bin"

# Configure auto-completion
[[ -r "${HOME}/.zsh/completion.zsh" ]] && \
  source "${HOME}/.zsh/completion.zsh"

# If we have a local SSH agent socket, use it.
[[ -r "${HOME}/.ssh/agent" ]] && \
  export SSH_AUTH_SOCK="${HOME}/.ssh/agent"

# Kubectl plugins via Krew
krew_bin_path="${KREW_ROOT:-${HOME}/.krew}/bin"
[[ -r "${krew_bin_path}" ]] \
  && pathappend "${krew_bin_path}"

# Pull in manually-defined aliases
[[ -r "${HOME}/.zsh/aliases.zsh" ]] && \
  source "${HOME}/.zsh/aliases.zsh"

# Finally enable iTerm integration - assumes you're using iTerm
[[ -r "${HOME}/.iterm2_shell_integration.zsh" ]] && \
  source "${HOME}/.iterm2_shell_integration.zsh"
