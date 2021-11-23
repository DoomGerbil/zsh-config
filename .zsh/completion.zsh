#!/usr/bin/env zsh

# Define where our completions and zsh functions live and can be loaded from
local_completions_dir="${ZSHRC}/completions"
FPATH="${FPATH}:${ZSHRC}/functions:${local_completions_dir}"

# Rebuild the autocomplete cache if it's more than a day old
find ~/.zcompdump -type f -mtime +1d -exec rm -f {} \;

autoload bashcompinit; bashcompinit
autoload -Uz compinit; compinit

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# Use completion caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Insert spaces after a completion so you can just keep typing
zstyle ':completion:*' add-space true

# AWS - handled by OMZSH plugin

# Bazel - handled by OMZSH plugin

# Docker - handled by OMZSH plugin, but with customized completion settings
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# gcloud/gsutil - handled by OMZSH plugin

# GH/hub - handled by OMZSH plugin

# Kubectl - handled by OMZSH plugin
zstyle ':completion:*:*:kubectl:*' list-grouped false

# Load Kubens completion when needed
[[ -r "${local_completions_dir}/_kubens" ]] \
  || curl -Ssl https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.zsh -o "${local_completions_dir}/_kubens"

# Load Kubectx completion when needed
[[ -r "${local_completions_dir}/_kubectx" ]] \
  || curl -Ssl https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.zsh -o "${local_completions_dir}/_kubectx"

# If kustomize is installed, rebuild its completion functions
command -v "kustomize" >"/dev/null" && \
  rm -f "${local_completions_dir}/_kustomize" && \
  kustomize completion zsh > "${local_completions_dir}/_kustomize"

# If stern (K8S log tailer) is installed, rebuild its completion functions
command -v "stern" >"/dev/null" && \
  rm -f "${local_completions_dir}/_stern" && \
  stern --completion zsh > "${local_completions_dir}/_stern"
