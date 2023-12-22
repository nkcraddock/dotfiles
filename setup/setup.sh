# vim: filetype=sh
#
# Install my dev environment
#
# natron2 - image editor
#


TMP_FILE_PREFIX=${TMPDIR:-/tmp}/prog.$$
#GOLANG_VERSION="1.10.3"
PYTHON_VERSION="3.6.6"

# set up the installed file to track which packages we've installed
if [ ! -e ~/.scraw_installed ]; then
  touch ~/.scraw_installed
fi
INSTALLED_PACKAGES=$(cat ~/.scraw_installed)
CURRENT_PACKAGE=""

DEFAULT_PACKAGES="
  core
  git
  dotfiles
  node
  python
  awscli
  terraform
  vim
"
CORE_APT_PACKAGES="
  apt-utils
  build-essential
  curl
  fonts-font-awesome
  fonts-powerline
  git
  jq
  mercurial
  silversearcher-ag
  software-properties-common
  tmux
  net-tools
  unzip
  wget
  pandoc
  htop
"

#PACKAGES="node golang python ctags dotfiles devtools"

function usage() {
  echo "Usage: init [OPTION]
  -f          full (install everything)
  -m          minimal install (just vim)
  "
}

function log() {
  CONTEXT=$(caller 0 | awk -F ' ' '{print $2,$1}')
  if ! [[ -z "$CURRENT_PACKAGE" ]]; then
    CONTEXT="$CURRENT_PACKAGE | $CONTEXT"
  else
    CONTEXT="root | $CONTEXT"
  fi
  echo "[ $CONTEXT ]: $@"
}

function install_apt_packages() {
  for apt_pkg in $@; do
    if ! $(dpkg -s $apt_pkg &> /dev/null); then
      install_apt_package $apt_pkg
    fi
  done
}

update_apt() {
  log "apt-update"
  sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq -y $1 > /dev/null
}

add_apt_repo() {
  EXISTS=$(add-apt-repository -L | grep "$1")
  if ! $EXISTS; then
    log "$1"
    sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y $1
  fi
}

function install_apt_package() {
  log "$1"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $1 > /dev/null
}


function install_core() {
  install_apt_packages "${CORE_APT_PACKAGES}"
}

function install_vim() {
  if _has "vim"; then
    sudo apt remove -y vim
  fi
  add_apt_repo ppa:jonathonf/vim
  install_apt_package vim
}

function install_git() {
  install_apt_package git

  # ensure we have a gitconfig
  if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig_local
  fi

}

# still needs redone
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
    LATEST_NVM=$(curl -s https://api.github.com/repositories/612230/releases/latest | jq -r '.tag_name')
    $(curl -LSs https://raw.githubusercontent.com/creationix/nvm/$LATEST_NVM/install.sh | bash) &> /dev/null
    # Add NVM to bash_local so it'll work in the shell
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_local
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_local
    # load NVM so we can use it to install node
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi

  if _has nvm && ! _has node; then
    nvm install --lts &> /dev/null
  fi

  if _has npm && ! _has yarn; then
    npm install -g yarn nodemon &> /dev/null
  fi
}

function _has() {
  if $(type -t "$1" &> /dev/null); then
    return 0
  fi
  return 1
}

function install_python() {
  if ! _has pyenv; then
    install_apt_packages "libreadline-dev libssl-dev libbz2-dev zlib1g-dev"
    $(curl -LSs https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    {
      echo 'export PATH="$HOME/.pyenv/bin:$PATH"'
      echo 'eval "$(pyenv init -)"'
      echo 'eval "$(pyenv virtualenv-init -)"'
    } >> "$HOME/.bash_local") > /dev/null

    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    $(pyenv install 3.6.6 && pyenv global 3.6.6) &> /dev/null
  fi

  if _has pip && ! _has http; then
    pip install httpie httpie-jwt-auth &> /dev/null
  fi
}

function install_ssh-server() {
  if ! _has ssh-server; then
    install_apt_package openssh-server
    if $(sudo ufw status | grep inactive &> /dev/null); then
      log "Opening firewall"
      sudo ufw enable
      sudo ufw allow ssh
      sudo systemctl restart ssh
fi
  fi
}

function install_terraform() {
  if ! _has terraform; then
    install_apt_packages gnupg software-properties-common
    wget -q "https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip" -O /tmp/terraform.zip
    unzip /tmp/terraform.zip -d /tmp
    sudo mv /tmp/terraform /usr/local/bin/terraform
    rm -f /tmp/terraform.zip
  fi
}

function install_dotfiles() {
  if [ ! -d "$HOME/.homesick/repos/homeshick" ]; then
    $(git clone --depth=1 https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick) > /dev/null
    echo 'source $HOME/.homesick/repos/homeshick/homeshick.sh' >> ~/.bash_local
    source $HOME/.homesick/repos/homeshick/homeshick.sh
    $(yes | homeshick clone -q -b nkcraddock/dotfiles) &> /dev/null
    $(yes | homeshick link -q /dotfiles) &> /dev/null
  fi
}

function install_docker() {
  #if ! _has docker ; then
    install_apt_package docker.io
    sudo usermod -aG docker $(whoami)
  #fi
}

function install_awscli() {
  AWS_TMP="/tmp/aws"
  mkdir -p $AWS_TMP
  log "downloading awscli zip from amazon"

  curl -LSs "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$AWS_TMP/awscliv2.zip" &> /dev/null
  unzip $AWS_TMP/awscliv2.zip -d $AWS_TMP > /dev/null
  sudo $AWS_TMP/aws/install > /dev/null
  rm -rf /tmp/aws
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

function run_package_setup() {
    log "installing $pkg"
    if [[ ! $DRY_RUN == "YES" ]]; then
      CURRENT_PACKAGE=$pkg
      install_$pkg
      echo $pkg >> ~/.scraw_installed
    fi
}

function main() {
  PACKAGES="$DEFAULT_PACKAGES"

  for i in "$@"; do
    case $i in
      -e=*|--environment=*)
        TARGET_ENVIRONMENT="${i#*=}"
        shift # past argument=value
        ;;
      -p=*|--package=*)
        INDIVIDUAL_PACKAGE="${i#*=}"
        PACKAGES="${INDIVIDUAL_PACKAGE}"
        shift # past argument=value
        ;;
      --default)
        DEFAULT=YES
        shift # past argument with no value
        ;;
      --update-apt)
        UPDATE_APT=YES
        shift
        ;;
      --dry-run)
        DRY_RUN=YES
        shift
        ;;
      -*|--*)
        echo "Unknown option $i"
        usage
        exit 1
        ;;
      *)
        echo ALSO: $i
        ;;
    esac
  done


  if [[ ! $DRY_RUN == "YES" && $UPDATE_APT == "YES" ]]; then
    # update apt packages
    update_apt

    # upgrade everything
    sudo apt-get upgrade -y
  fi

  # look through the selected packages and install them
  for pkg in ${PACKAGES}; do
    CURRENT_PACKAGE=""
    if ! _has "install_$pkg" || [ $pkg == "$INDIVIDUAL_PACKAGE" ]  || [[ ! $INSTALLED_PACKAGES = *"$pkg"* ]] ; then
      run_package_setup $pkg
    fi
  done

  #install_vim_plugins "${DEFAULT_VIM_PLUGINS}"
  #install_dotfiles


  exit 0
}


main "$@"

echo "---------------------------------------------------"
echo "All finished. You'll want to source your bashrc."
echo "$ source ~/.bashrc"

/bin/bash
