ripgrep
===========

_ripgrep is a line-oriented search tool that recursively searches the current directory for a regex pattern_

Helper for setup of [`rg`](https://github.com/BurntSushi/ripgrep).

Search with one-result-per-line:

    rg -i 776b6e --no-heading

Combined with `fd`:

    fd -t f -X rg -i 776b6e
