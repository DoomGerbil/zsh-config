# This assumes that Oh My ZSH is installed at this path
zsh_path="${ZSH_PATH:-$HOME/.oh-my-zsh}"
[[ -r "${zsh_path}" ]] && \
  export ZSH="${zsh_path}" && \
  export ZSH_CUSTOM="${ZSH}/custom"

# Do the early initalization of pyenv
command -v "pyenv" >"/dev/null" && \
  eval "$(pyenv init --path)"

# Detect Homebrew if installed, and let it export env vars.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [[ -x $brew_bin ]] && eval "$($brew_bin shellenv)" && break
done

# Homebrew Python packages - if installed, add them to the PATH
if [[ -d "${HOMEBREW_PREFIX}/opt/python/Frameworks/Python.framework/Versions/Current/bin" ]]; then
  export PY_BREW_PACKAGES="${HOMEBREW_PREFIX}/opt/python/Frameworks/Python.framework/Versions/Current/bin"
  pathprepend "${PY_BREW_PACKAGES}"
fi
