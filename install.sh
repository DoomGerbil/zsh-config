#! /usr/bin/env bash

echo "!! Installing prereqs !!"

echo "Installing Oh My ZSH"
[[ -d "${HOME}/.oh-my-zsh" ]] || \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Powerlevel10K"
p10kdir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "${p10kdir}" ]] || \
  git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${p10kdir}/themes/powerlevel10k"

echo "Installing FZF and Ripgrep from Homebrew"
command -v "fzf" >"/dev/null" || \
  brew install fzf

command -v "rg" >"/dev/null" || \
  brew install ripgrep

echo "Installing new configuration files."
[[ -r "${HOME}/.zprofile" ]] && \
  echo "Backing up your existing .zprofile to .zprofile.old"
  cp "${HOME}/.zprofile" "${HOME}/.zprofile.old"

[[ -r "${HOME}/.zshrc" ]] && \
  echo "Backing up your existing .zshrc to .zshrc.old"
  cp "${HOME}/.zshrc" "${HOME}/.zshrc.old"

[[ -r "${HOME}/.zsh" ]] && \
  echo "Backing up your existing .zsh directory to .zsh.old"
  cp -R "${HOME}/.zsh" "${HOME}/.zsh.old"

cp .zprofile "${HOME}/.zprofile"
cp .zshrc "${HOME}/.zshrc"
cp -R .zsh "${HOME}/.zsh"
