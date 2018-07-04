dotfiles
========
My dotfiles and whatnot. You don't want this.

Setup Script
------------
This is only going to work on ubuntu, and probably only 16.04 and 18.04.
IF you specify `-f`, a full install is done which includes:
- **dotfiles** (bashrc, vimrc, etc.)
- **Editors**
  * [vim](https://www.vim.org/)
  * [mscode](https://code.visualstudio.com/)
- **Language support**
  * [golang](https://golang.org)
  * [node](https://nodejs.org/en/) (with [nvm](https://github.com/creationix/nvm))
  * [python](https://www.python.org) (with [pyenv](https://github.com/pyenv/pyenv-virtualenv))
- **vim plugins**
  * [tpope/vim-pathogen](https://github.com/tpope/vim-pathogen) - plugin manager
  * [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive) - git
  * [tpope/vim-unimpaired](https://github.com/tpope/vim-unimpaired) - operator mappings for things
  * [tpope/vim-surround](https://github.com/tpope/vim-surround) - surround things with other things
  * [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree) - tree view
  * [scrooloose/nerdcommenter](https://github.com/scrooloose/nerdcommenter) - quick commenting/uncommenting of things
  * [kien/ctrlp.vim](https://github.com/kien/ctrlp.vim) - find stuff
  * [rking/ag.vim](https://github.com/rking/ag.vim) - use ag to find text
  * [majutsushi/tagbar](https://github.com/majutsushi/tagbar) - a bar that shows ctags for navigation
  * [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) - nifty statusline
  * [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) - themes for nifty statusline
  * [lifepillar/vim-solarized8](https://github.com/lifepillar/vim-solarized8) - solarized theme for vim
  * [elzr/vim-json](https://github.com/elzr/vim-json) - json
  * [digitaltoad/vim-jade](https://github.com/digitaltoad/vim-jade) - jade
  * [fatih/vim-go](https://github.com/fatih/vim-go) - golang
  * [vim-ruby/vim-ruby](https://github.com/vim-ruby/vim-ruby) - ruby
  * [elixir-lang/vim-elixir](https://github.com/elixir-lang/vim-elixir) - elixir
  * [avakhov/vim-yaml](https://github.com/avakhov/vim-yaml) - yaml
  * [leafgarland/typescript-vim](https://github.com/leafgarland/typescript-vim) - typescript
  * [shime/vim-livedown](https://github.com/shime/vim-livedown) - visualizer for markdown
  
- **mscode extensions**
  * [PeterJausovec.vscode-docker](https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker) - Dockerfile
  * [ms-vscode.Go](https://marketplace.visualstudio.com/items?itemName=ms-vscode.Go) - golang
  * [christian-kohler.path-intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense) - Path intellisense
  * [dbaeumer.vscode-eslint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) - eslint integration
  * [EditorConfig.EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) - use .editorconfig files
  * [eg2.tslint](https://marketplace.visualstudio.com/items?itemName=eg2.tslint) - tslint
  * [esbenp.prettier-vscode](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) - prettify
  * [mikestead.dotenv](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv) - use .env files
  * [tht13.python](https://marketplace.visualstudio.com/items?itemName=tht13.python) - python
  * [vscodevim.vim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) - vim mode
- **tools**
  * [docker](https://www.docker.com/) 
  * [git](https://git-scm.com/)
  * [mercurial](https://www.mercurial-scm.org/)
  * [wget](https://gnu.org/software/wget/)
  * [curl](https://curl.haxx.se)
  * [httpie](https://httpie.org) - easier http cli for testing APIs
  * [gcloud](https://cloud.google.com/sdk/gcloud/) - the google cloud client cli
  * [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) - kubernetes cli
  * [jq](https://stedolan.github.io/jq/) - jq, for parting json and stuff
  * [homeshick](https://github.com/andsens/homeshick) - a .sh version of homesick, for syncing dotfiles in git
  * [ag](https://github.com/ggreer/the_silver_searcher) - full text search in files, honoring .gitignore
  * [scrot](http://pwet.fr/man/linux/commandes/scrot) - screenshots
  * [xclip](https://github.com/astrand/xclip) - copy/paste
- **gui apps**
  * [i3wm](https://i3wm.org) - tiling windows manager
  * [spotify](https://spotify.com/) - jams
  * [google-chrome](https://www.google.com/chrome/) - a web browser
  * [slack](https://slack.com)
  * [pavucontrol](https://github.com/pulseaudio/pavucontrol)

### Installation
```
# Default setup (vim, go, node, ctags, misc dev tools)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash

# Full install with errthang (default + i3wm, chrome, docker and other apps I use)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash -s -- -f

# Minimal install (just vim)
$ curl -LSs https://github.com/nkcraddock/dotfiles/raw/master/setup | bash -s -- -m
```


Git Config
----------
Some standard configuration for git is included in `~/.gitconfig`
For your custom settigns that wont be shared (like `name` and `email`) can be put in `~/.gitconfig_local` thusly:
```
[user]
    name = "Your Name"
    email = "your@email.com"
```

