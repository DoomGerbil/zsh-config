# Base helpers for PATH mangling
pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

pathprepend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

# Configure some legacy Golang stuff
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Do some arbitrary PATH mangling
pathprepend "${GOBIN}"
pathprepend "/usr/local/sbin"
pathprepend "${HOME}/bin"

# Kubectl plugins via Krew
krew_bin_path="${KREW_ROOT:-${HOME}/.krew}/bin"
[[ -r "${krew_bin_path}" ]] \
  && pathappend "${krew_bin_path}"
