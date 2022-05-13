#! /usr/bin/env bash

echo "!! Installing prereqs !!"

echo "Installing Oh My ZSH"
[[ -d "${HOME}/.oh-my-zsh" ]] || \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Powerlevel10K"
p10kdir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "${p10kdir}" ]] || \
  git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${p10kdir}/themes/powerlevel10k"

# Install fzf if not present
command -v "fzf" >"/dev/null" || \
  echo "Installing FZF from Homebrew" && \
  brew install fzf

# Install ripgrep if not present
command -v "rg" >"/dev/null" || \
  echo "Installing Ripgrep from Homebrew" && \
  brew install ripgrep

echo "Installing new configuration files."

echo "Installing .zshenv"
[[ -r "${HOME}/.zshenv" ]] && \
  echo "Backing up your existing .zshenv to .zshenv.old" && \
  cp "${HOME}/.zshenv" "${HOME}/.zshenv.old"
cp .zshenv "${HOME}/.zshenv"

echo "Installing .zprofile"
[[ -r "${HOME}/.zprofile" ]] && \
  echo "Backing up your existing .zprofile to .zprofile.old" && \
  cp "${HOME}/.zprofile" "${HOME}/.zprofile.old"
cp .zprofile "${HOME}/.zprofile"

echo "Installing .zshrc"
[[ -r "${HOME}/.zshrc" ]] && \
  echo "Backing up your existing .zshrc to .zshrc.old" && \
  cp "${HOME}/.zshrc" "${HOME}/.zshrc.old"
cp .zshrc "${HOME}/.zshrc"

echo "Installing .zsh directory"
[[ -r "${HOME}/.zsh" ]] && \
  echo "Backing up your existing .zsh directory to .zsh.old" && \
  cp -R "${HOME}/.zsh" "${HOME}/.zsh.old"
cp -R .zsh "${HOME}/.zsh"
