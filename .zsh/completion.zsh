#!/usr/bin/env zsh

# Define where our completions and zsh functions live and can be loaded from
local_completions_dir="${ZSHRC}/completions"
completion_cache_dir="${ZSHRC}/cache"
FPATH="${local_completions_dir}:${FPATH}:${ZSHRC}/functions"

# Rebuild the autocomplete cache if it's more than a day old
find ~/.zcompdump -type f -mtime +1d -exec rm -f {} \;

autoload bashcompinit; bashcompinit
autoload -Uz compinit; compinit

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

# Use completion caching
# Guarantee that the cache directory exists, otherwise things get unhappy
mkdir -p ${completion_cache_dir} && \
  zstyle ':completion:*' cache-path "${completion_cache_dir}"

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on

# Insert spaces after a completion so you can just keep typing
zstyle ':completion:*' add-space true

## Per-command completion configuration
## Kept in alpha-sort order for ease of updates/discovery

# AWS - handled by OMZSH plugin

# Azure CLI - if installed and completion doesn't exist, fetch and install it.
azcli_ac_path="$(find /usr/local/Cellar/azure-cli/**/etc/bash_completion.d/az)"
[[ -r "${azcli_ac_path}" && ! -r "${local_completions_dir}/_az" ]] \
  && ln -s "${azcli_ac_path}" "${local_completions_dir}/_az"
compdef az

# Bazel - handled by OMZSH plugin

# Docker - handled by OMZSH plugin, but with customized completion settings
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# gcloud/gsutil - handled by OMZSH plugin

# GitHub's hub CLI - handled by OMZSH plugin

# JFrog CLI (Artifactory) - if installed, rebuild the completion index and
command -v "jf" >"/dev/null" && \
  jf completion zsh > "${local_completions_dir}/_jf"

# KPT - if installed, rebuild the completion index
command -v "kpt" >"/dev/null" && \
  kpt completion zsh > "${local_completions_dir}/_kpt"

# Kubectl - handled by OMZSH plugin
zstyle ':completion:*:*:kubectl:*' list-grouped false

# Kubens - if installed and completion doesn't exist, fetch them
[[ -x "$(command -v kubens)" && ! -r "${local_completions_dir}/_kubens" ]] \
  && curl -Ssl https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubens.zsh -o "${local_completions_dir}/_kubens"

# Kubectx - if installed and completion doesn't exist, fetch them
[[ -x "$(command -v kubectx)" && ! -r "${local_completions_dir}/_kubectx" ]] \
  && curl -Ssl https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubectx.zsh -o "${local_completions_dir}/_kubectx"

# Kustomize - if installed, rebuild the completion index
command -v "kustomize" >"/dev/null" && \
  kustomize completion zsh > "${local_completions_dir}/_kustomize"

# OpenShift CLI (oc) - if installed, rebuild the completion index
command -v "oc" >"/dev/null" && \
  oc completion zsh > "${local_completions_dir}/_oc"

# Stern (K8S log tailer) - if installed, rebuild the completion index
command -v "stern" >"/dev/null" && \
  stern --completion zsh > "${local_completions_dir}/_stern"

# Buildpack CLI (pack) - if installed, rebuild the completion index
command -v "pack" >"/dev/null" && \
  [[ -r "${HOME}/.pack/completion.zsh" ]] && \
  source ~/.pack/completion.zsh

# Custom AWS profile completer
aws-profiles() {
    cat ~/.aws/config | grep '\[.*profile' | grep -v '#' | tr -d '[]' | sed 's/profile //'
  }

set-aws-profile() {
  local aws_profile=$1
  export AWS_PROFILE=${aws_profile}
  export AWS_REGION=eu-west-2
}
