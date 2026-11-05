# Base helpers for PATH mangling
pathappend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

pathprepend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

# Configure some legacy Golang stuff
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Python system-wide packages
if [[ -d "/Library/Frameworks/Python.framework/Versions/Current/bin" ]]; then
  export PY_SYS_PACKAGES="/Library/Frameworks/Python.framework/Versions/Current/bin"
  pathprepend "${PY_SYS_PACKAGES}"
fi
if [[ -d "${HOME}/Library/Python/3.9/bin" ]]; then
  export PY_USER_PACKAGES="${HOME}/Library/Python/3.9/bin"
  pathprepend "${PY_USER_PACKAGES}"
fi

## Do some arbitrary PATH mangling - these are prepended, so they are added here in reverse priority order

# Golang bin paths
pathprepend "${GOBIN}"

# Homebrew binaries
if [[ -d "${HOMEBREW_PREFIX}/bin" ]]; then
  pathprepend "${HOMEBREW_PREFIX}/bin"
fi

# Personal binaries
pathprepend "${HOME}/bin"
pathprepend "${HOME}/.local/bin"

# And here we add lower-priority paths to the end
# Kubectl plugins via Krew
krew_bin_path="${KREW_ROOT:-${HOME}/.krew}/bin"
[[ -r "${krew_bin_path}" ]] &&
  pathappend "${krew_bin_path}"
