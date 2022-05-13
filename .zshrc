#! /usr/bin/env zsh

# Set $ZSHRC if not already set
export ZSHRC="${ZSHRC:-$HOME/.zsh}"

[[ -r "${ZSHRC}/zshrc.zsh" ]] && \
  source "${ZSHRC}/zshrc.zsh"
