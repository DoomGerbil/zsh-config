#! /usr/bin/env bash

echo "Updating repo from live configuration files."
# .zshenv
[[ -r "${HOME}/.zsh/zshenv.zsh" ]] && \
  echo "Updating zshenv" && \
  cp "${HOME}/.zsh/zshenv.zsh" .zsh/zshenv.zsh

# .zprofile
[[ -r "${HOME}/.zsh/zprofile.zsh" ]] && \
  echo "Updating zprofile" && \
  cp "${HOME}/.zsh/zprofile.zsh" .zsh/zprofile.zsh

# .zshrc
[[ -r "${HOME}/.zsh/zshrc.zsh" ]] && \
  echo "Updating zshrc" && \
  cp "${HOME}/.zsh/zshrc.zsh" .zsh/zshrc.zsh

if [[ -r "${HOME}/.zsh" ]]; then
  echo "Updating .zsh directory"

  # Copy the live .zsh into the repo dir, ignoring the per-machine cache and various MacOS system files
  rsync -av --progress "${HOME}/.zsh/" ".zsh/" \
  --exclude "cache" \
  --exclude "completions" \
  --exclude ".DS_Store"
fi
