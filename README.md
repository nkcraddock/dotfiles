dotfiles
========

My dotfiles and whatnot. You don't want this.

Installation
------------
This is only going to work on ubuntu, and probably only 16.04 and 18.04
```
# Default setup (vim, go, node, ctags, misc dev tools)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash

# Full install with errthang (default + i3wm, chrome, docker and other apps I use)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash -s -- -f

# Minimal install (just vim)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash -s -- -m
```
