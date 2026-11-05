#! /usr/bin/env zsh

# Import any user-specific secrets here
# This file is obviously not part of the config distribution, so it may not exist
USER_SECRETS_FILE="${USER_SECRETS_FILE:-${HOME}/.secrets.zsh}"
if [[ -r "${USER_SECRETS_FILE}" ]]; then
  # Glob qualifiers: A = group-readable, R = world-readable
  # Using an array, because qualifiers inside [[ ]] require EXTENDED_GLOB
  secrets_readable_by_others=( ${USER_SECRETS_FILE}(N.A) ${USER_SECRETS_FILE}(N.R) )
  if (( ${#secrets_readable_by_others} )); then
    echo "PROBLEM: User secrets file is readable by other users"
    echo "Skipping until you fix it: chmod 0600 ${USER_SECRETS_FILE}"
  else
    source "${USER_SECRETS_FILE}"
  fi
fi

# Switch on Powerlevel10K if running in Terminal, iTerm, or vscode, but not Warp, where it doesn't work properly
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then

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
  [[ -r "${ZSH_CUSTOM}/plugins/fzf-tab" ]] || \
    git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM}/plugins/fzf-tab"

  # Powerlevel 10K
  # To customize, run `p10k configure` or edit ${ZSHRC}/p10k.zsh.
  ZSH_THEME="powerlevel10k/powerlevel10k"
  [[ -r "${ZSHRC}/p10k.zsh" ]] && \
    source "${ZSHRC}/p10k.zsh"
fi

# Configure oh-my-zsh
COMPLETION_WAITING_DOTS="true"
HYPHEN_INSENSITIVE="true"

# This is my set of OMZSH plugins, but others might want a different set
# Comment out any you don't want, or add new ones from https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=()

# Install a collection of useful aliases
plugins+=(aliases)

plugins+=(alias-finder)
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default


# ASDF version manager - if installed, load it
# plugins+=(asdf)

# Completion support for AWS's CLI tool
# plugins+=(aws)

# Support for Bazel build tool - uncomment if needed.
# plugins+=(bazel)

# Automatically pop up a notification when a long-running process finishes
# MacOS: Requires `brew install terminal-notifier`
plugins+=(bgnotify)

# Homebrew completion
plugins+=(brew)

# Colorize the output of various commands
plugins+=(colored-man-pages colorize)

# Let zsh tell you how to install something if you run a command that isn't installed
plugins+=(command-not-found)

# Enable a collection of common aliases for various commands
# plugins+=(common-aliases)

# Copy the path of the current file to the clipboard
plugins+=(copypath)

# Automatically load per-directory settings from `.envrc` files
# Testing disabling because it felt like it made my terminal slow
plugins+=(direnv)

# # Directory history plugin
# Disabled because it stomps on word-based kb nav
# plugins+=(dirhistory)

# Completion for Docker and Docker Compose
plugins+=(docker docker-compose)

# Load environment variables from a `.env` file in the current directory
# Disabled because this is dupe functionality with direnv
# plugins+=(dotenv)

# Aliases using eza instead of ls, with completion support
# plugins+=(eza)
# zstyle ':omz:plugins:eza' 'git-status' yes
# zstyle ':omz:plugins:eza' 'show-group' smart



# Enables FZF for fuzzy finding.
plugins+=(fzf)

# Completion support for Google Cloud CLI tools
plugins+=(gcloud)

# Completion for the git CLI
plugins+=(git)
plugins+=(gitfast)

# Helm completion
plugins+=(helm)

# Aliases and completion for Kubectl
plugins+=(kubectl)
plugins+=(kubectx)

# MacOS system shortcuts
plugins+=(macos)

# Completion for minikube
# plugins+=(minikube)

# Mise en place integration
plugins+=(mise)

# Completion and aliases for npm/nvm
# plugins+=(npm nvm)

# Completion for Python bits
plugins+=(python pyenv pylint)
plugins+=(pip pipenv)
plugins+=(uv uv-env)

# Completion for pre-commit
plugins+=(pre-commit)

# SSH tools and helpers
plugins+=(ssh ssh-agent)
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent honor-existing yes
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain


# Completion for Terraform
plugins+=(terraform)

# Corrects previous incorrect console commands
plugins+=(thefuck)

plugins+=(timer)

# VSCode integration
plugins+=(vscode)

# These are manually-managed plugins that enable some suggestions and syntax highlighting
plugins+=(fzf-tab zsh-autosuggestions zsh-syntax-highlighting)

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Sets up FZF fuzzy finder if it's installed (brew install fzf)
if command -v "fzf" >"/dev/null"; then
  export DISABLE_FZF_AUTO_COMPLETION="false"
  export DISABLE_FZF_KEY_BINDINGS="false"
  export FZF_DEFAULT_OPTS="--height 100% --border"

  # If ripgrep is installed (brew install ripgrep) configure fzf to use it
  if command -v "rg" >"/dev/null"; then
      export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
  fi
fi

# Configure auto-completion
userCompletionFile="${HOME}/.zsh/completion.zsh"
[[ -r "${userCompletionFile}" ]] && \
  source "${userCompletionFile}"

# Pull in manually-defined aliases
userAliasesFile="${HOME}/.zsh/aliases.zsh"
[[ -r "${userAliasesFile}" ]] && \
  source "${userAliasesFile}"

# Configure gcloud for GKE Auth and MacOS Python
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# If we have a local SSH agent socket, use it.
if [ -r "${HOME}/.ssh/agent" ]; then
  export SSH_AUTH_SOCK="${HOME}/.ssh/agent"
fi

# Use bat as the pager if installed. Debian/Ubuntu ship it as `batcat`.
# PAGER/MANPAGER are read by other programs, so they need the real binary name, not an alias.
bat_bin="$(command -v bat || command -v batcat)"
if [[ -n "${bat_bin}" ]]; then
  [[ "${bat_bin:t}" == "batcat" ]] && alias bat="batcat"
  export PAGER="${bat_bin:t}"
  export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | ${bat_bin:t} -p -lman'"
fi

# Only enable iTerm integration if running in iTerm
if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
  [[ -r "${HOME}/.iterm2_shell_integration.zsh" ]] && \
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# On Mac, enable SSH to use credentials stored on security keys, if the lib is installed.
# This stays in /usr/local/lib even with Apple Silicon Homebrew, as ssh-agent only loads providers from /usr/lib* and /usr/local/lib* by default.
if [[ $OSTYPE == darwin* && -r /usr/local/lib/libsk-libfido2.dylib ]]; then
  export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
fi

####
# ACTIVATE OMZSH
# This basically needs to happen near the end of the chain -
# after plugins are configured, but before any user-specific aliases or completions are loaded.
####
source "${ZSH}/oh-my-zsh.sh"
