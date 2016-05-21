# antigen
source ~/.antigen.zsh

# antigen for packages - https://github.com/zsh-users/antigen
antigen use oh-my-zsh       # https://github.com/robbyrussell/oh-my-zsh
antigen bundle autoenv
antigen bundle golang
antigen bundle git
antigen bundle github
antigen bundle gitignore
antigen bundle jira
antigen bundle rbenv
antigen bundle bundler
antigen bundle rake
antigen theme robbyrussell

# Wire up gopath
export GOPATH=$HOME/dev/go
PATH=$PATH:$GOPATH/bin
export PATH="/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home/bin:/Users/nathanc/bin:/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home/bin:/usr/local/bin:/usr/local/go/bin:/Users/nathanc/.rbenv/shims:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/local/go/bin:/Users/nathanc/bin:/Users/nathanc/dev/go/bin"

# os-specitic settings
os=`uname`
if [[ "$os" == 'Linux' ]]; then
  u
  JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:bin/javac::")
  alias ls='ls --color=auto'
elif [[ "$os" == 'Darwin' ]]; then
  JAVA_HOME=`/usr/libexec/java_home -v1.7`
  alias ls='ls -G'
fi


# command aliases 
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias st='git status'

# other aliases
alias hs='homesick'

# quickly add patterns to the local gitignore
function gi {
  echo "$1" >> .gitignore
}

# import local stuff
source ~/.zsh_local

