# ZSH configuration and tuning

Copy the `.zsh/` directory, `.zprofile`, and `.zshrc` into your home directory and start a new shell.

## Prerequisites

You'll need to install a few things to get full use of this.

* First, install [Oh My ZSH](https://github.com/ohmyzsh/ohmyzsh#basic-installation)
* Next, install using Oh My ZSH - [Powerline 10K](https://github.com/romkatv/powerlevel10k#oh-my-zsh)
* Then use Homebrew to install FZF - `brew install fzf`
* And Ripgrep - `brew install ripgrep`
* And if you don't already have it, the `gcloud` CLI is useful as well - `brew install google-cloud-sdk`

It also contains some iTerm2-specific things that may or may not matter to you. :shrug:

You will probably want to do the "optional" one-time setup steps for P10K as well
(installing fonts, etc) or things might look a little weird.

## Configuring

The main shell configuration happens in `~/.zsh/zshrc.zsh`.

You may want to tweak some of the things that it's doing, or add other random stuff in there.

In particular, you probably want to have a look at the `plugins=()` line and choose the set of plugins
that are useful for you from [the list](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins). This is the
set of plugins I use, but YMMV:

```bash
plugins=(aliases aws bazel direnv docker fzf gcloud gh git history iterm2 pyenv kubectl terraform zsh-autosuggestions zsh-syntax-highlighting)
```

If you have shell aliases, you should stick them in `~/.zsh/aliases.zsh`.

If you have specific autocompletion configuration tweaks, you should stick them in `~/.zsh/completion.zsh`.

`~/.zsh/p10k.zsh` contains a whole bunch of configuration options for Powerline 10K. This package has
my configuration, but you may want to tweak it to do some things differently - this is where you change
all of those settings. See the [P10k config docs](https://github.com/romkatv/powerlevel10k#configuration)
for full details.
