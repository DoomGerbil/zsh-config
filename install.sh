#! /usr/bin/env bash

echo "Checking and installing prereqs"

[[ -d "${HOME}/.oh-my-zsh" ]] || \
  (echo "Oh My ZSH not found, installing..." && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")

p10kdir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
[[ -d "${p10kdir}" ]] || \
  (echo "Powerlevel10K not found, installing..." && \
  git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${p10kdir}")

# Install fzf if not present
command -v "fzf" >"/dev/null" || \
  (echo "FZF not found, installing..." && \
  brew install fzf)

# Install ripgrep if not present
command -v "rg" >"/dev/null" || \
  (echo "Ripgrep not found, installing..." && \
  brew install ripgrep)

# Install terminal-notifier if not present
command -v "terminal-notifier" >"/dev/null" || \
  (echo "terminal-notifier not found, installing..." && \
  brew install terminal-notifier)

# Install eza if not present
command -v "eza" >"/dev/null" || \
  (echo "eza not found, installing..." && \
  brew install eza)

# Install libfido2 and related formulae if not present to support Yubikey/security key
libfido_installed=$(brew list | grep "^libfido2$")
[[ -z "${libfido_installed}" ]] && \
  (echo "libfido2 not found, installing..." && \
  brew install libfido2)

libsk_libfido_installed=$(brew list | grep "^libsk-libfido2$")
[[ -z "${libsk_libfido_installed}" ]] && \
  (echo "libsk-libfido2 not found, installing..." && \
  brew install libsk-libfido2)

libsk_libfido_install_installed=$(brew list | grep "^libsk-libfido2-install$")
[[ -z "${libsk_libfido_install_installed}" ]] && \
  (echo "libsk-libfido2-install not found, installing..." && \
  brew install michaelroosz/ssh/libsk-libfido2-install)

##
# END OF PRE-REQS
##

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
  rm -rf "${HOME}/.zsh.old" && mv "${HOME}/.zsh" "${HOME}/.zsh.old"

cp -R .zsh "${HOME}/.zsh"
