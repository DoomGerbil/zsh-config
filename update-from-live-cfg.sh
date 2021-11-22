#! /usr/bin/env bash

echo "Updating repo from live configuration files."
[[ -r "${HOME}/.zprofile" ]] && \
  echo "Updating .zprofile"
  cp "${HOME}/.zprofile" .zprofile

[[ -r "${HOME}/.zshrc" ]] && \
  echo "Updating .zshrc"
  cp "${HOME}/.zshrc" .zshrc

[[ -r "${HOME}/.zsh" ]] && \
  echo "Updating .zsh directory"
  cp -R "${HOME}/.zsh/" .zsh/
  # Don't check in the cache, since that will vary per user.
  rm -f .zsh/cache/*
