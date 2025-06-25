#!/usr/bin/env zsh

# This file contains a collection of completion settings and custom completions that I use, or have found useful.
# YMMV, but feel free to use this as a starting point for your own completion settings.

# WIP/TODO: Check completion cache files for file modtimes over a threshold, wipe if old and then rebuild from scratch
# On macos, these are all equivalent timestamps for the same file:
# ❯ GetFileInfo -m $ZSHRC/completions/_kpt
# 12/12/2024 12:29:45
# ❯ stat -f "%Sm" $ZSHRC/completions/_kpt
# Dec 12 12:29:45 2024
# ❯ stat -f "%m" $ZSHRC/completions/_kpt
# 1734006585

# Define where our completions and zsh functions live and can be loaded from
local_completions_dir="${ZSHRC}/completions"
completion_cache_dir="${ZSHRC}/cache"
FPATH="${local_completions_dir}:${FPATH}:${HOMEBREW_PREFIX}/share/zsh/site-functions/:${ZSHRC}/functions"

# Rebuild the autocomplete cache if it's more than a day old
find ~/.zcompdump -type f -mtime +1d -exec rm -f {} \; 2>/dev/null

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
# Uncomment this line to manually install AWS CLI completion
complete -C '/usr/local/bin/aws_completer' aws

# Bazel - handled by OMZSH plugin

# Docker - handled by OMZSH plugin, but with customized completion settings
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# fzf-tab config
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# set the maximum number of items to show in the completion list
zstyle ':completion:*' list-max-items 20
# Git specific completion hints
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'case "$group" in "commit tag") git show --color=always $word ;; *) git show --color=always $word | delta ;; esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'case "$group" in "modified file") git diff $word | delta ;; "recent commit object name") git show --color=always $word | delta ;; *) git log --color=always $word ;; esac'

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

# ADR Tools completion, if installed via Homebrew
adr_tools_completion_path="${HOMEBREW_PREFIX}/etc/bash_completion.d/adr-tools"
[[ -r "${adr_tools_completion_path}" ]] && \
  source "${adr_tools_completion_path}"

# Custom AWS profile completer
aws-profiles() {
    cat ~/.aws/config | grep '\[.*profile' | grep -v '#' | tr -d '[]' | sed 's/profile //'
  }

set-aws-profile() {
  local aws_profile=$1
  export AWS_PROFILE=${aws_profile}
  export AWS_REGION=eu-west-2
}
