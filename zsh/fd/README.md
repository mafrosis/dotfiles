fd
===========

_a simple, fast and user-friendly alternative to 'find'_

Helper for setup of [`fd`](https://github.com/sharkdp/fd).

```
USAGE:
    fd [FLAGS/OPTIONS] [<pattern>] [<path>...]

FLAGS:
    -H, --hidden            Search hidden files and directories
    -I, --no-ignore         Do not respect .(git|fd)ignore files
    -s, --case-sensitive    Case-sensitive search (default: smart case)
    -i, --ignore-case       Case-insensitive search (default: smart case)
    -g, --glob              Glob-based search (default: regular expression)
    -a, --absolute-path     Show absolute instead of relative paths
    -l, --list-details      Use a long listing format with file metadata
    -L, --follow            Follow symbolic links
    -p, --full-path         Search full path (default: file-/dirname only)
    -0, --print0            Separate results by the null character
    -h, --help              Prints help information
    -V, --version           Prints version information

OPTIONS:
    -d, --max-depth <depth>            Set maximum search depth (default: none)
    -t, --type <filetype>...           Filter by type: file (f), directory (d), symlink (l),
                                       executable (x), empty (e), socket (s), pipe (p)
    -e, --extension <ext>...           Filter by file extension
    -x, --exec <cmd>                   Execute a command for each search result
    -X, --exec-batch <cmd>             Execute a command with all search results at once
    -E, --exclude <pattern>...         Exclude entries that match the given glob pattern
    -c, --color <when>                 When to use colors: never, *auto*, always
    -S, --size <size>...               Limit results based on the size of files.
        --changed-within <date|dur>    Filter by file modification time (newer than)
        --changed-before <date|dur>    Filter by file modification time (older than)

ARGS:
    <pattern>    the search pattern - a regular expression unless '--glob' is used (optional)
    <path>...    the root directory for the filesystem search (optional)
```
