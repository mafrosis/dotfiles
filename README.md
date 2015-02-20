Isn't It
========

Everyone loves them.


Overview
--------

Dotfiles for configuration and various helper scripts and tools are all rolled into one. Plus a dose of Salt states for setting up my home servers.

The top level `install.sh` script does the hard work, pass one or more directory names to it to [stow](http://www.gnu.org/software/stow) the contents of that particular directory as symlinks in $HOME.

Each directory can also have its own `install.sh` to complement or override the behaviour of the top-levelscript. If a "per-app" install script returns `255`, the stow command will not be run at the top level (see [osx/install.sh](osx/install.sh) for an example of this).


Submodules
----------

A few git submodules are included:

 - [sorin-ionescu/prezto](http://github.com/sorin-ionescu/prezto): ZSH config framework
 - [gmarik/Vundle.vim](http://github.com/gmarik/Vundle.vim): Vim plugin management
 - [morgant/tools-osx](http://github.com/morgant/tools-osx): useful helper scripts for CLI on OSX
 - [mafrosis/salt-formulae](http://github.com/mafrosis/salt-formulae): more salt states
