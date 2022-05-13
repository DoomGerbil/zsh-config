#! /usr/bin/env bash

echo "Updating repo from live configuration files."
# .zshenv
[[ -r "${HOME}/.zsh/zshenv.zsh" ]] && \
  echo "Updating zshenv" && \
  cp "${HOME}/.zsh/zshenv.zsh" .zsh/zshenv.zsh

# .zprofile
[[ -r "${HOME}/.zsh/zprofile.zsh" ]] && \
  echo "Updating zprofile" && \
  cp "${HOME}/.zsh/zshprofile.zsh" .zsh/zprofile.zsh

# .zshrc
[[ -r "${HOME}/.zsh/zshrc.zsh" ]] && \
  echo "Updating zshrc" && \
  cp "${HOME}/.zsh/zshrc.zsh" .zsh/zshrc.zsh

if [[ -r "${HOME}/.zsh" ]]; then
  echo "Updating .zsh directory"

  # Save the preservable contents of the cache dir, since we wipe it out otherwise
  tmpdir=$(mktemp)
  cachedir=".zsh/cache"
  cp "${cachedir}/README.md" "${tmpdir}/"

  cp -R "${HOME}/.zsh/" .

  # Don't save the cache, since that will vary per user.
  rm -f "${cachedir}/*"
  cp "${tmpdir}/README.md" "${cachedir}/README.md"
  touch "${cachedir}/.gitkeep"
fi
