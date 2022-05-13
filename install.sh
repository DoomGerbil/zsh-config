#! /usr/bin/env bash

echo "Checking and installing prereqs"

[[ -d "${HOME}/.oh-my-zsh" ]] || \
  (echo "Oh My ZSH not found, installing..." && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")


p10kdir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "${p10kdir}" ]] || \
  (echo "Powerlevel10K not found, installing..." && \
  git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${p10kdir}/themes/powerlevel10k")

# Install fzf if not present
command -v "fzf" >"/dev/null" || \
  (echo "FZF not found, installing..." && \
  brew install fzf)

# Install ripgrep if not present
command -v "rg" >"/dev/null" || \
  (echo "Ripgrep not found, installing..." && \
  brew install ripgrep)

echo "Installing new configuration files."

echo "Installing .zshenv"
[[ -r "${HOME}/.zshenv" ]] && \
  echo "Backing up your existing .zshenv to .zshenv.old" && \
  mv "${HOME}/.zshenv" "${HOME}/.zshenv.old"
cp .zshenv "${HOME}/.zshenv"

echo "Installing .zprofile"
[[ -r "${HOME}/.zprofile" ]] && \
  echo "Backing up your existing .zprofile to .zprofile.old" && \
  mv "${HOME}/.zprofile" "${HOME}/.zprofile.old"
cp .zprofile "${HOME}/.zprofile"

echo "Installing .zshrc"
[[ -r "${HOME}/.zshrc" ]] && \
  echo "Backing up your existing .zshrc to .zshrc.old" && \
  mv "${HOME}/.zshrc" "${HOME}/.zshrc.old"

cp .zshrc "${HOME}/.zshrc"

echo "Installing .zsh directory"
[[ -r "${HOME}/.zsh" ]] && \
  echo "Backing up your existing .zsh directory to .zsh.old" && \
  mv "${HOME}/.zsh" "${HOME}/.zsh.old"

cp -R .zsh "${HOME}/.zsh"
