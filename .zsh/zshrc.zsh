#! /usr/bin/env zsh

# The location of the optional user-specific secrets helper
# Not part of the config distribution
USER_SECRETS_FILE="${USER_SECRETS_FILE:-${HOME}/.secrets.zsh}"

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

# Configure oh-my-zsh
COMPLETION_WAITING_DOTS="true"
HYPHEN_INSENSITIVE="true"

# This is my set of OMZSH plugins, but others might want a different set
# Comment out any you don't want, or add new ones from https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=()

# Install a collection of useful aliases
plugins+=(aliases)

# Completion support for AWS's CLI tool
# plugins+=(aws)

# Automatically pop up a notification when a long-running process finishes
# MacOS: Requires `brew install terminal-notifier`
plugins+=(bgnotify)

# Let zsh tell you how to install something if you run a command that isn't installed
plugins+=(command-not-found)

# Automatically load per-directory settings from `.envrc` files
# Disabled because this makes my terminal slow
# plugins+=(direnv)

# Completion for Docker and Docker Compose
plugins+=(docker)
plugins+=(docker-compose)

# Enables FZF for fuzzy finding.
plugins+=(fzf)

# Completion support for Google Cloud CLI tools
plugins+=(gcloud)

# Faster completion for the git CLI
plugins+=(gitfast)

# Helm completion
plugins+=(helm)

# Aliases and completion for Kubectl
plugins+=(kubectl)

# MacOS system shortcuts
plugins+=(macos)

# Completion for minikube
plugins+=(minikube)

# Completion and aliases for npm
# plugins+=(npm)

# Completion for nvm
# plugins+=(nvm)

# Completion for Python environment management
plugins+=(pyenv)

plugins+=(timer)

# Completion for Terraform
plugins+=(terraform)

# Aliases and completion for Yarn
# plugins+=(yarn)

# These are manually-managed plugins that enable some suggestions and syntax highlighting
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)

# Sets up FZF fuzzy finder if it's installed (brew install fzf)
if command -v "fzf" >"/dev/null"; then
  export FZF_BASE="/usr/local/opt/fzf"
  export DISABLE_FZF_AUTO_COMPLETION="false"
  export DISABLE_FZF_KEY_BINDINGS="false"
  export FZF_DEFAULT_OPTS="--height 40% --border"

  # If ripgrep is installed (brew install ripgrep) configure fzf to use it
  if command -v "rg" >"/dev/null"; then
      export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
  fi
fi

# Activate oh-my-zsh
source "${ZSH}/oh-my-zsh.sh"

# Configure auto-completion
userCompletionFile="${HOME}/.zsh/completion.zsh"
[[ -r "${userCompletionFile}" ]] && \
  source "${userCompletionFile}"

# Pull in manually-defined aliases
userAliasesFile="${HOME}/.zsh/aliases.zsh"
[[ -r "${userAliasesFile}" ]] && \
  source "${userAliasesFile}"

# Set any user-specific secret env vars
if [[ -r "${USER_SECRETS_FILE}" ]]; then
  if find ${USER_SECRETS_FILE} -type f -perm +044 | grep "${USER_SECRETS_FILE}"; then
    echo "PROBLEM: User secrets file is readable by other users"
    echo "Skipping until you fix it: chmod 0600 ${USER_SECRETS_FILE}"
  else
    source "${USER_SECRETS_FILE}"
  fi
fi

# Enable GKE Gcloud Auth
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Finally enable iTerm integration - assumes you're using iTerm
[[ -r "${HOME}/.iterm2_shell_integration.zsh" ]] && \
  source "${HOME}/.iterm2_shell_integration.zsh"
