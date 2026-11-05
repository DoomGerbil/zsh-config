# TODOs

## Structural improvemnts

- Rather than scattering if [[$OSTYPE == darwin*]] checks everywhere, add per-OS files and source the right ones from zshrc.zsh (and zshenv.zsh for PATH):

```bash
.zsh/os/darwin.zsh   # brew/macos plugins, Python framework paths, SSH_SK_PROVIDER, iTerm
.zsh/os/linux.zsh    # bat/fd aliases, notify-send check for bgnotify
.zsh/os/wsl.zsh      # sourced in addition to linux.zsh

case $OSTYPE in darwin*) os=darwin ;; linux*) os=linux ;; esac
[[ -r $ZSHRC/os/$os.zsh ]] && source $ZSHRC/os/$os.zsh
[[ -n $WSL_DISTRO_NAME && -r $ZSHRC/os/wsl.zsh ]] && source $ZSHRC/os/wsl.zsh
```

- The macos and brew plugins would move into darwin.zsh.

- Allow for a git-ignored .zsh/local.zsh for per-machine overrides.
- bgnotify should go in only where terminal-notifier or notify-send exists; it does nothing useful on WSL.

## WSL-specific additions (add to wsl.zsh)

- Slow tab completion: WSL adds every Windows PATH entry under /mnt/c/..., which makes completion and command-not-found very slow. Set appendWindowsPath = false under [interop] in /etc/wsl.conf, then add back only what you need (for example the VS Code bin directory).
- open: alias open=wslview (from wslu), or explorer.exe.
- SSH agent and security keys: WSL can't see your YubiKey without usbipd-win. The usual workaround is to let Windows OpenSSH do the work. In a WSL-only gitconfig include, set core.sshCommand = ssh.exe and gpg.ssh.program = ssh-keygen.exe. Alternatively, bridge the Windows or 1Password agent into SSH_AUTH_SOCK using npiperelay and socat. Your gitconfig currently has security-key signing on by default, so commits will fail in WSL without one of these.
- Git credentials: point credential.helper at the Windows Git Credential Manager, or keep using SSH everywhere, which your insteadOf rule already does.
- Fonts: the Nerd Font for p10k has to be installed in Windows and selected in Windows Terminal, not installed inside the distro. This is worth a README note.

## install.sh

- It installs everything with brew, and the brew list | grep checks fail outright if brew isn't there. Either support Linuxbrew explicitly, or detect apt/dnf/pacman and map package names (e.g. bat, fd-find, eza, ripgrep, fzf, zsh).
- Skip the libfido2/libsk-libfido2 steps and terminal-notifier on Linux.
- Linux needs two steps macOS doesn't: make sure zsh itself is installed
  - Optionally run chsh -s "$(command -v zsh)", since the default shell there is usually bash.
- .zshenv is copied, but the README's manual instructions leave it out.
