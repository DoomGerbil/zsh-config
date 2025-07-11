#! /usr/bin/env zsh

# Import any user-specific secrets here
# This file is obviously not part of the config distribution, so it may not exist
USER_SECRETS_FILE="${USER_SECRETS_FILE:-${HOME}/.secrets.zsh}"
if [[ -r "${USER_SECRETS_FILE}" ]]; then
  if find ${USER_SECRETS_FILE} -type f -perm +044 | grep "${USER_SECRETS_FILE}"; then
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

# Completion support for AWS's CLI tool
plugins+=(aws)

# Automatically pop up a notification when a long-running process finishes
# MacOS: Requires `brew install terminal-notifier`
plugins+=(bgnotify)

# Homebrew completion
plugins+=(brew)

# Colorize the output of various commands
plugins+=(colored-man-pages colorize)

# Let zsh tell you how to install something if you run a command that isn't installed
plugins+=(command-not-found)

# Copy the path of the current file to the clipboard
plugins+=(copypath)

# # Directory history plugin
# Disabled because it stomps on word-based kb nav
# plugins+=(dirhistory)

# Automatically load per-directory settings from `.envrc` files
# Disabled because this makes my terminal slow
# plugins+=(direnv)

# Completion for Docker and Docker Compose
plugins+=(docker docker-compose)

# Load environment variables from a `.env` file in the current directory
plugins+=(dotenv)

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

# MacOS system shortcuts
plugins+=(macos)

# Completion for minikube
plugins+=(minikube)

# Completion and aliases for npm/nvm
plugins+=(npm nvm)

# Completion for Python environment management
plugins+=(pyenv)

# Completion for Terraform
plugins+=(terraform)

# Corrects previous incorrect console commands
plugins+=(thefuck)

plugins+=(timer)

# These are manually-managed plugins that enable some suggestions and syntax highlighting
plugins+=(fzf-tab zsh-autosuggestions zsh-syntax-highlighting)

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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

# Configure gcloud for GKE Auth and MacOS Python
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# If we have a local SSH agent socket, use it.
if [ -r "${HOME}/.ssh/agent" ]; then
  export SSH_AUTH_SOCK="${HOME}/.ssh/agent"
fi

export PAGER="bat"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Only enable iTerm integration if running in iTerm
if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
  [[ -r "${HOME}/.iterm2_shell_integration.zsh" ]] && \
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Enable SSH to use credentials stored on security keys.
export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
