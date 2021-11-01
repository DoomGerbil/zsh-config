# Base dir for all ZSH configuration
export ZSHRC="${HOME}/.zsh"

# This assumes that Oh My ZSH is installed at this path
zsh_path="${ZSH_PATH:-$HOME/.oh-my-zsh}"
[[ -r "${zsh_path}" ]] && \
  export ZSH="${zsh_path}" && \
  export ZSH_CUSTOM="${ZSH}/custom"

# Do the early initalization of pyenv
command -v "pyenv" >"/dev/null" && \
  eval "$(pyenv init --path)"
