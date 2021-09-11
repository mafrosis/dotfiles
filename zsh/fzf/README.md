fzf
===========

_a command-line fuzzy finder_

Helper for setup of [`fzf`](https://github.com/junegunn/fzf).

Although commonly used in vim for opening files, `fzf` is also very useful on the CLI for
interactive searching through any list:

    mpc add "$(find /mp3 -type d | fzf | sed 's:/mp3::')"

Setup
-----------

As typical for this repo, `install.sh` installs the `fzf` binary based on OS/CPU architecture.

The repo [`junegunn/fzf`](https://github.com/junegunn/fzf) is submoduled in at
`~/dotfiles/zsh/fzf/external`, to make `fzf-tmux` and shell key bindings / completions available.

Normal `fzf` installation involves running their
[install script](https://github.com/junegunn/fzf/blob/master/install). In this config, that script
is not used - the `fzf` setup commands have been added directly to `~/.zshrc`.
