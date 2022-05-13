#! /usr/bin/env zsh

# Base dir for all ZSH configuration
export ZSHRC="${HOME}/.zsh"

[[ -r "${ZSHRC}/zshenv.zsh" ]] && \
  source "${ZSHRC}/zshenv.zsh"
