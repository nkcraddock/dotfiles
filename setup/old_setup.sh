#!/usr/bin/env bash
# vim: filetype=sh
#
# Install my dev environment including vim, dotfiles, go, node, and ui stuff
# heheheh
TMP_FILE_PREFIX=${TMPDIR:-/tmp}/prog.$$
GOLANG_VERSION="1.10.3"
PYTHON_VERSION="3.6.6"

DEFAULT_APT_PACKAGES="
apt-utils
build-essential
curl
fonts-font-awesome
fonts-powerline
git
jq
mercurial
silversearcher-ag
wget
vim
"

DEFAULT_VIM_PLUGINS="
tpope/vim-fugitive
tpope/vim-unimpaired
tpope/vim-surround
scrooloose/nerdtree
scrooloose/nerdcommenter
kien/ctrlp.vim
rking/ag.vim
majutsushi/tagbar
milkypostman/vim-togglelist
vim-airline/vim-airline
vim-airline/vim-airline-themes
elzr/vim-json
digitaltoad/vim-jade
fatih/vim-go
vim-ruby/vim-ruby
elixir-lang/vim-elixir
avakhov/vim-yaml
shime/vim-livedown
leafgarland/typescript-vim
vim-syntastic/vim-syntastic
editorconfig/editorconfig-vim
"

function usage() {
  echo "Usage: init [OPTION]
  -f          full (install everything)
  -m          minimal install (just vim)
  "
}

function install_apt_packages() {
  for apt_pkg in $@; do
    if ! $(dpkg -s $apt_pkg &> /dev/null); then
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $apt_pkg
    fi
  done
}

function install_vim_plugins() {
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  # make sure we have pathogen
  if [ ! -e ~/.vim/autoload/pathogen.vim ]; then
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi

  # install all the plugins
  for plugin in $@; do
    local plugin_name="${plugin##*/}"

    if [ ! -d $HOME/.vim/bundle/$plugin_name ]; then
      git clone --depth=1 "https://github.com/$plugin" "$HOME/.vim/bundle/$plugin_name"
    fi
  done
}

function install_node() {
  if [ -f $HOME/.nvm/nvm.sh ]; then
    source $HOME/.nvm/nvm.sh
  else
    # Install the latest version of NVM
    LATEST_NVM=$(curl -s https://api.github.com/repos/creationix/nvm/releases/latest | jq -r '.tag_name')
    curl -LSs https://raw.githubusercontent.com/creationix/nvm/$LATEST_NVM/install.sh | bash
    # Add NVM to bash_local so it'll work in the shell
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_local
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_local
    # load NVM so we can use it to install node
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi

  if _has nvm && ! _has node; then
    nvm install --lts
  fi

  if _has npm && ! _has yarn; then
    npm install -g yarn
  fi
}

function _has() {
  if $(type -t "$1" &> /dev/null); then 
    return 0 
  fi 
  return 1
}

function install_golang() {
  if [ ! -d "$HOME/.go" ] && [ ! -d "$HOME/go" ]; then
    wget -q "https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    tar -C "$HOME" -xzf /tmp/go.tar.gz
    mv "$HOME/go" "$HOME/.go"
    {
      echo '# GoLang'
      echo 'export GOROOT=$HOME/.go'
      echo 'export PATH=$PATH:$GOROOT/bin'
      echo 'export GOPATH=$HOME/go'
      echo 'export PATH=$PATH:$GOPATH/bin'
    } >> "$HOME/.bash_local"
    mkdir -p $HOME/go/{src,pkg,bin}
    rm -f /tmp/go.tar.gz
  fi

  if _has go && ! _has drive; then
    go get -u github.com/odeke-em/drive/cmd/drive
  fi
}

function install_python() {
  if ! _has pyenv; then
    install_apt_packages "libreadline-dev libssl-dev libbz2-dev zlib1g-dev"
    curl -LSs https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    {
      echo 'export PATH="$HOME/.pyenv/bin:$PATH"'
      echo 'eval "$(pyenv init -)"'
      echo 'eval "$(pyenv virtualenv-init -)"'
    } >> "$HOME/.bash_local"

    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    pyenv install 3.6.6 && pyenv global 3.6.6
  fi

  if _has pip && ! _has http; then
    pip install httpie httpie-jwt-auth
  fi
}

function install_ctags() {
  if ! _has ctags; then
    git clone -q --depth=1 https://github.com/universal-ctags/ctags.git /tmp/ctags
    install_apt_packages autotools-dev autoconf pkg-config
    cd /tmp/ctags
    ./autogen.sh
    ./configure
    make
    sudo make install
    cd -
    rm -rf /tmp/ctags
  fi

  install_vim_plugins "ludovicchabant/vim-gutentags.git"
}

function install_dotfiles() {
  if [ ! -d "$HOME/.homesick/repos/homeshick" ]; then 
    git clone --depth=1 https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    echo 'source $HOME/.homesick/repos/homeshick/homeshick.sh' >> ~/.bash_local
    source $HOME/.homesick/repos/homeshick/homeshick.sh
    yes | homeshick clone -b nkcraddock/dotfiles
    yes | homeshick link /dotfiles
  fi
}

function install_uiapps() {
  install_apt_packages "i3 pavucontrol scrot xclip vim-gnome fonts-powerline"

  # For the nvidia 1070, we need 390
  if [[ $(ubuntu-drivers devices | grep -q nvidia-driver) -eq 0 ]]; then
    if [[ $(dpkg -s nvidia-driver-390 &> /dev/null) -ne 0 ]]; then
      sudo add-apt-repository -y ppa:graphics-drivers/ppa
      sudo apt-get update
      sudo apt-get install -y nvidia-driver-390
    fi
  fi

  # google chrome
  if ! _has google-chrome; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable
    echo "BROWSER=$(which google-chrome)" >> ~/.bash_local
  fi

  # slack
  if ! _has slack; then
    sudo snap install slack --classic
  fi

  # spotify
  if ! _has spotify; then
    sudo snap install spotify
  fi
}

function install_vscode() {
  if ! _has code; then
    # set up the microsoft repo
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # install code
    sudo apt-get update
    sudo apt-get install -y code

    # install all the extensions
    VSCODE_EXTENSIONS="
    PeterJausovec.vscode-docker
    ms-vscode.Go
    christian-kohler.path-intellisense
    dbaeumer.vscode-eslint
    EditorConfig.EditorConfig
    eg2.tslint
    esbenp.prettier-vscode
    mikestead.dotenv
    tht13.python
    vscodevim.vim
    "
    for ext in $VSCODE_EXTENSIONS; do
      code --install-extension $ext
    done
  fi
}

function install_docker() {
  if ! _has docker; then
    curl -o- https://get.docker.com | bash
    sudo usermod -aG docker $(whoami)
  fi
}

function install_devtools() {
  # grab httpie if we didnt install python
  if [[ ! $PACKAGES = *"python"* ]]; then
    install_apt_packages "httpie"
  fi

  # gcloud cli
  if ! _has gcloud; then
    source /etc/lsb-release
    export CLOUD_SDK_REPO="cloud-sdk-${DISTRIB_CODENAME}"
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk
  fi

  # kubectl cli
  if ! _has kubectl; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    # kubectl shell autocompletion
    echo "source <(kubectl completion bash)" >> ~/.bash_local
    # the k alias
    echo "alias k='kubectl'" >> ~/.bash_local
  fi
}


function main() {
  PACKAGES="node golang python ctags dotfiles devtools"
  local -r OPTS=':hfm'
  while builtin getopts ${OPTS} opt "${@}"; do

    case $opt in
      h) usage ; exit 0
        ;;

      f) # 
        PACKAGES="${PACKAGES} uiapps docker vscode"
        ;;

      m) # minimal
        PACKAGES=""
        ;;


      \?)
        echo ${opt} ${OPTIND} 'is an invalid option' >&2;
        usage;
        exit ${INVALID_OPTION}
        ;;
    esac
  done

  # update apt packages
  sudo apt-get update -q

  # upgrade everything (no balls)
  sudo apt-get upgrade -y

  install_apt_packages "${DEFAULT_APT_PACKAGES}"

  for pkg in ${PACKAGES}; do
    if _has "install_$pkg"; then
      install_$pkg
    fi
  done

  install_vim_plugins "${DEFAULT_VIM_PLUGINS}"
  install_dotfiles


  exit 0
}


main "$@"

echo "---------------------------------------------------"
echo "All finished. You'll want to source your bashrc."
echo "$ source ~/.bashrc"

