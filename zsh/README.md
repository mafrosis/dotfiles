ZSH Cheatsheet
==========

Basics
----------

The tricks in this section are mostly known as [substitutions](https://zsh.sourceforge.io/Guide/zshguide05.html#l123),
but here they are organised around common data types and operations.

### String

**NOTE:** Indexing is done from 1

| Description | Demo | Output |
| - | - | - |
| Get the length of a string | `TEST=foobar; print ${#TEST}` | `8`
| String slice | `TEST=foobar; print ${TEST[1,3]}` | `foo`
| String slice | `TEST=foobar; print ${TEST[2,3]}` | `oo`
| String slice | `TEST=foobar; print ${TEST[4,-1]}` | `bar`
| Replace first occurance | `TEST=foobarfoobar; print ${TEST/foo/bar}` | `barbarfoobar`
| Replace all occurances | `TEST=foobarfoobar; print ${TEST//foo/bar}` | `barbarbarbar`
| [Split a string into an array](https://zsh.sourceforge.io/Guide/zshguide05.html#l124) | `TEST=foo,bar,baz; ARRAY=${(s:,:)TEST}; print $ARRAY[3]` | `foo bar baz`
| [Path directory](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:h}` | `/foo` | Like `dirname`
| [Path filename](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:t}` | `bar.baz` | Like `basename`
| [Path extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:e}` | `baz`
| [Path drop extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:r}` | `/foo/bar`
| [Path filename & drop extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:t:r}` | `bar`


### [Array](https://zsh.sourceforge.io/Guide/zshguide05.html#l121)

Arrays are defined using simple curved brackets.

**NOTE:** Indexing is done from 1

| Description | Demo | Output |
| - | - | - |
| Create an array | `TEST=(foo bar); print ${TEST}` | `foo bar`
| Append to an array | `TEST=(foo bar); TEST+=(baz); print ${TEST}` | `foo bar baz`
| Select element | `TEST=(foo bar baz qux); print ${TEST[1]}` | `foo`
| Select element | `TEST=(foo bar baz qux); print ${TEST[-1]}` | `qux`
| Select element | `TEST=(foo bar baz qux); print ${TEST[-2]}` | `baz`
| Select range | `TEST=(foo bar baz qux); print ${TEST[1,2]}` | `foo bar`
| Select range | `TEST=(foo bar baz qux); print ${TEST[1,3]}` | `foo bar baz`
| Select range | `TEST=(foo bar baz qux); print ${TEST[2,4]}` | `bar baz qux`
| Select range | `TEST=(foo bar baz qux); print ${TEST[2,-1]}` | `bar baz qux` 
| Remove first element | `TEST=(foo bar); shift TEST; print ${TEST}` | `bar`
| Remove last element (pop) | `TEST=(foo bar); shift -p TEST; print ${TEST}` | `foo`
| Array length | `TEST=(foo bar); print ${#TEST}` | `2`
| Array slice | `TEST=(foo bar baz); print ${TEST:0:2}` | `foo bar`
| Array slice to end | `TEST=(foo bar); print ${TEST:1}` | `bar`
| Check value in array | `TEST=(foo bar); (($TEST[(Ie)baz])); print $?` | `1`
| Remove element at index | `TEST=(foo bar); TEST[1]=(); print ${TEST}` | `bar`
| [Split a string into an array](https://zsh.sourceforge.io/Guide/zshguide05.html#l124) | `TEST=foo,bar,baz; ARRAY=${(s:,:)TEST}; print $ARRAY[3]` | `foo bar baz`
| [Join an array into a string](https://zsh.sourceforge.io/Guide/zshguide05.html#l124) | `TEST=(foo bar baz); print ${(j:,:)TEST}` | `foo,bar,baz`


### [Dict/Hash/Map](https://zsh.sourceforge.io/Guide/zshguide05.html#l122)

Associative arrays are defined using `typeset`. When used inside a function, these are automatically
[scoped locally](#variable-scope-with-local).  To create a global use `typeset -gA`.

| Description | Demo | Output |
| - | - | - |
| Create a dict | `typeset -A TEST=([k1]=foo [k2]=bar); print ${TEST}` | `foo bar`
| Add a key/value pair | `typeset -A TEST; print ${TEST}; TEST[k3]=baz; print ${TEST}` | `baz`
| Get value at key | `typeset -A TEST=([k1]=foo [k2]=bar); print $TEST[k1]` | `foo`
| Remove key | `typeset -A TEST=([k1]=foo [k2]=bar); unset 'TEST[k2]'; print ${TEST}` | `foo`
| Iterate array keys | `typeset -A TEST=([k1]=foo [k2]=bar); for k in ${(k)TEST}; print $k` | `k1` `k2`
| Iterate array kv pairs  | `typeset -A TEST=([k1]=foo [k2]=bar); for k v in ${(kv)TEST}; print $k,$v` | `k1,foo` `k2,bar`


### Math

Arithmetic is done inside double curved brackets.

| Description | Demo | Output | Note |
| - | - | - | - |
| Basics | `print $(( 2 * 3 + 3 ))` | `9`
| Basics | `(( foo = 2 * (3 + 3) )); print $foo` | `12`
| Using a variable | `i=4; (( i = i + 1 )); print $i` | `5` | `$` not required
| Using a variable | `TEST=(foo bar); (( foo = ${#TEST} + 9 )); print $foo` | `11` | `$` _is_ required when using `#` expansion
| Float | `print $(( 1.5 / 0.5 ))` | `3.`
| Float to int | `print $(( int(1.5 / 0.5) ))` | `3` | `zmodload zsh/mathfunc`


Filesystem
----------

Selecting files in the filesystem. Known as _globbing_, or filename generation. Apply extra filtering
with [glob qualifiers](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) and/or [modifiers](https://zsh.sourceforge.io/Guide/zshguide05.html#l118).

To run the `Demo` commands, setup some test files with this command:
```
mkdir t && cd t && mkdir -p dir1/sdir1 dir2/sdir2/sdir3 && touch cmd1 cmd2 file1 file2 && chmod +x cmd1 cmd2 && ln -sf file1 symlink1 && ln -sf file2 symlink2
```

| Description | Demo | Output | Note |
| - | - | - | - |
| [Basic wildcard](https://zsh.sourceforge.io/Guide/zshguide05.html#l137) | `print d*` | `dir1 dir2`
| [Char class wildcard](https://zsh.sourceforge.io/Guide/zshguide05.html#l137) | `print [cf]*` | `cmd1 cmd2 file1 file2`
| [Char class wildcard](https://zsh.sourceforge.io/Guide/zshguide05.html#l137) | `print [c-f]*` | `cmd1 cmd2 dir1 dir2 file1 file2`
| [String match](https://zsh.sourceforge.io/Guide/zshguide05.html#l137) | `print {cmd,file}*` | `cmd1 cmd2 file1 file2`
| [Single char match](https://zsh.sourceforge.io/Guide/zshguide05.html#l137) | `print d?r1` | `dir1`
| [Match files recursively](https://zsh.sourceforge.io/Guide/zshguide05.html#l140) | `ls **/*.f` || Equivalent to `find . -name "*.f"`
| [Find in files recursively](https://zsh.sourceforge.io/Guide/zshguide05.html#l140) | `grep fo **/*.f` || Equivalent to `find . -name "*.f" \| xargs grep fo`
| [Match files only](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(.)` | `file1 file2 cmd1 cmd2`
| [Match dirs only](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(/)` | `dir1 dir2`
| [Match executables only](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(*)` | `cmd1 cmd2`
| [Match symlinks only](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(@)` | `symlink1 symlink2`
| [Match by file mode](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(f:644:)` | `file1 file2`
| [Match by file mode](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print *(f:u+x:)` | `cmd1 cmd2 dir1 dir2 symlink1 symlink2`
| [Path directory](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:h}` | `/foo` | Like `dirname`
| [Path filename](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:t}` | `bar.baz` | Like `basename`
| [Path extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:e}` | `baz`
| [Path drop extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:r}` | `/foo/bar`
| [Path filename & drop extension](https://zsh.sourceforge.io/Guide/zshguide05.html#l118) | `TEST=/foo/bar.baz; print ${TEST:t:r}` | `bar`


### Finding files

The recursive double-glob an effective replacement for `find`. The built-in globbing flags allow to
replace most of the common use-cases when searching for files.

Globbing flags `(o)` and `(O)` sort in normal or reverse order of _other_ things:

* `n` is for names - so `(on)` gives the default order while `(On)` is reverse order
* `L` file size
* `l` number of links
* `m` and modified time
* `a` access time
* `c` inode changed time
* `d` refers to subdirectory depth (useful with recursive globbing to show a file tree ordered depth-first)

| Description | Demo | Note |
| - | - | - | - |
| [Sort by name](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print -l **/*.yaml(on)` | Equivalent to just `(n)`, as `(o)` is the default lexical ordering
| [Sort by name, reversed](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print -l **/*.yaml(On)` |
| [Sort by modified time](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print -l **/*.yaml(om)` |
| [20 most recently modified files](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print -l **/*.yaml(om[1,20])` |
| [10 largest files](https://zsh.sourceforge.io/Guide/zshguide05.html#l141) | `print -l **/*.yaml(OL[1,10])` |


Scripting
----------

### Parameter Expansion Flags

When a variable is _expanded_ into its value, it's possible to modify behaviour with _flags_.

> If the opening brace is directly followed by an opening parenthesis, the string up to the matching
> closing parenthesis will be taken as a list of flags.

[Parameter expansion flags manual](https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion-Flags)

| Description | Flag | Demo | Output |
| - | - | - | - |
| Capitalise words | `C` | `TEST=foo; print ${(C)TEST}` | `Foo`
| Lowercase | `L` | `TEST=(FOO Bar); print ${(L)TEST}` |  `foo bar`
| Uppercase | `U` | `TEST=foo; print ${(U)TEST}` | `FOO`
| Sort an array, lexical reversed | `O` | `TEST=(foo bar baz); print ${(O)TEST}` | `foo baz bar`
| Sort an array, lexical forward | `Oo` | `TEST=(foo bar baz); print ${(Oo)TEST}` | `bar baz foo`
| Sort an array, numerical ascending | `n` | `TEST=(bar3 bar2 bar21 bar23 bar1); print ${(n)TEST}` | `bar1 bar2 bar3 bar21 bar23`
| Sort an array, numerical descending | `nO` | `TEST=(bar3 bar2 bar21 bar23 bar1); print ${(nO)TEST}` | `bar23 bar21 bar3 bar2 bar1`
| Sort an array, by index reversed | `Oa` | `TEST=(foo bar baz); print ${(Oa)TEST}` | `baz bar foo`
| Escape shell special chars | `q` | `TEST="foo ?acon"; print ${(q)TEST}` | `foo\ \?ar`
| Unescape shell special chars | `Q` | `TEST="foo\ \?acon"; print ${(Q)TEST}` | `foo ?acon`
| Count number of chars | `c` | `TEST="foo bar"; print ${(c)#TEST}` | `7`
| Count number of words | `w` | `TEST="foo bar"; print ${(w)#TEST}` | `2`
| Print dict keys | `k` | `typeset -A TEST=([k1]=foo [k2]=bar); print ${(k)TEST}` | `k1 k2`
| Print dict values | `v` | `typeset -A TEST=([k1]=foo [k2]=bar); print ${(v)TEST}` | `foo bar`
| Print dict keys & values | `kv` | `typeset -A TEST=([k1]=foo [k2]=bar); print ${(kv)TEST}` | `k1 foo k2 bar`


[Functions](https://zsh.sourceforge.io/Guide/zshguide03.html#l48)
----------

### Variable scope with local

All variables declared inside or outside functions are global by default. Use the `local` keyword
to scope a variable to a function.
```
function log() {
    local msg=$1
}
```

### Returning from a function

Functions may only return a single integer. Standard use is as a success/failure code - `0` meaning
success, and any non-zero value indicating an error.
```
function demo() {
    local msg=$1
    if [[ -n $msg ]]; then
        return 44
    else
        return 0
    fi
}
demo foo; print $?
demo; print $?
```

To return a string from a function, one must use `print` ([or, `echo` if you're brave](#echo-or-print))
and capture the output on `stdout`. By its nature, this method is limited to only strings!
```
function demo() {
    local msg=$1
    if [[ -n $msg ]]; then
        print foo
        return 44
    else
        print bar
        return 0
    fi
}
RET=$(demo foo); print $?; print $RET
RET=$(demo); print $?; print $RET
```

### Logging and returning

As a function can only return a string via `stdout`, any script logging must be done on `stderr`.
Following is a helper function you might find useful.

```
function log {
	>&2 print "\e[35m$1\e[0m"
}
```


[Shell History](https://zsh.sourceforge.io/Guide/zshguide03.html#l55)
----------

Other things you can do with history, besides the well known `sudo !!`. These are also available in
bash.

| Description | Operator |
| - | - |
| Last command | `!!`
| `n`th recent command | `!n`
| Most recent command starting with `str` | `!str`
| Last command's arguments | `!*`
| Last command's first argument | `!^`
| Last command's last argument | `!$`
| Last command's `n`th argument | `!:n`


Using print
----------

| Description | Demo |
| - | - |
| Print arguments in two columns | `print -C 2 {1..50}`
| Print arguments in two columns, row-by-row | `print -aC 2 {1..50}`
| Print arguments in columns wrapped at term width | `print -c {1..50}`
| Print arguments with newlines instead of spaces | `print -l foo bar baz`
| Do not add a newline to the output | `print -n foo`
| Sort arguments in ascending order | `print -o foo bar baz`
| Sort arguments in descending order | `print -O foo bar baz`


Bash vs ZSH
----------

### Globbing and Word Splitting

Unlike `bash`, by default `zsh` does not perform word splitting or glob expansion in variables. In
`bash`, writing:
```
cmd $var
```

Really means something like (pseudocode):
```
cmd(glob(split($var)))
```

This is why variables must always be quoted in `bash`.

For a more lengthy explanation, read [security implications of forgetting to quote a variable in bash](https://unix.stackexchange.com/questions/171346/security-implications-of-forgetting-to-quote-a-variable-in-bash-posix-shells).


### Force Globbing and Word Splitting in ZSH

| Description | Operator | Demo | Output |
| - | - | - | - |
| Perform word splitting | `$=var` | `TEST="foo bar baz"; TEST=($=TEST); print ${#TEST}` | 3
| Perform globbing | `$~var` | `touch /tmp/foobar; TEST=/tmp/foo*; print ${~TEST}` | `/tmp/foobar`


### Echo or Print?

For the most part, you can swap `echo` for `print` without issue. Problems are found when trying to
use `echo` in portable scripts, and when trying to output control chars (eg. newlines, tabs).

For more info than you ever wanted on the subject, read [why is printf better than echo](https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo#65819).


### Further reading

* Some interesting nuggets can be found in [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
* To see what works in which shell, refer to [Unix Shells](https://hyperpolyglot.org/unix-shells)


Glossary
----------

| Term | AKA | Meaning | Example |
| - | - | - | - |
| Globbing | Filename generation | Patterns which expand to match filenames in the filesystem | `ls /etc/*.conf`
| Parameter expansion | Variables | When a variable is _expanded_ into its value, often magic happens | `TEST=foo; print ${TEST}`
| History expansion | `!` | Fetch parts of the last shell command | `print !!`
| Word splitting | - | When a variable containing spaces is split into multiple parameters (or words) | `TEST="foo bar baz"; TEST=($=TEST); print ${#TEST}`
| Field splitting | - | When a variable is split into multiple parameters by a specific value. A magic variable named `$IFS` determines which value to split on | `IFS=x; TEST=fooxbarxbaz; print $=TEST`


References
----------

 * https://zsh.sourceforge.io/Guide/zshguide.html
 * [Another ZSH CheatSheet](https://gist.github.com/ClementNerma/1dd94cb0f1884b9c20d1ba0037bdcde2)
 * https://thevaluable.dev/zsh-expansion-guide-example/
 * https://unix.stackexchange.com/questions/298548/matching-files-using-curly-brace-expansion-in-zsh#298625
 * https://unix.stackexchange.com/questions/461360/glob-character-within-variable-expands-in-bash-but-not-zsh#461361
 * https://unix.stackexchange.com/questions/26661/what-is-word-splitting-why-is-it-important-in-shell-programming#26672
 * https://unix.stackexchange.com/questions/171346/security-implications-of-forgetting-to-quote-a-variable-in-bash-posix-shells#171347
 * https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo#65819
 * https://mywiki.wooledge.org/BashPitfalls
 * https://hyperpolyglot.org/unix-shells
 * [Zsh — print command gist](https://gist.github.com/YumaInaura/2a1a915b848728b34eacf4e674ca61eb)
