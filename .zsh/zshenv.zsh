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
export PY_SYS_PACKAGES="/Library/Frameworks/Python.framework/Versions/Current/bin"
export PY_USER_PACKAGES="${HOME}/Library/Python/3.9/bin"
export PY_BREW_PACKAGES="${HOMEBREW_PREFIX}/opt/python/Frameworks/Python.framework/Versions/Current/bin"

## Do some arbitrary PATH mangling - these are prepended, so they are added here in reverse priority order
# Python bin paths
pathprepend "${PY_USER_PACKAGES}"
pathprepend "${PY_BREW_PACKAGES}"
pathprepend "${PY_SYS_PACKAGES}"
# Golang bin paths
pathprepend "${GOBIN}"
# Homebrew binaries
pathprepend "${HOMEBREW_PREFIX}/bin"
# Personal binaries
pathprepend "${HOME}/bin"

# And here we add lower-priority paths to the end
# Kubectl plugins via Krew
krew_bin_path="${KREW_ROOT:-${HOME}/.krew}/bin"
[[ -r "${krew_bin_path}" ]] &&
  pathappend "${krew_bin_path}"
