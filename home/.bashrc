#!/bin/bash

# Add ~/bin to path
PATH="$HOME/bin:$PATH"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# run local bash stuff (pc-specific aliases and such)
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

# os-specific switches
os=`uname`
if [[ "$os" == 'Linux' ]]; then
  alias ls='ls --color=auto'
elif [[ "$os" == 'Darwin' ]]; then
  alias ls='ls -G'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# history
HISTCONTROL=ignoredups:erasedups
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWCOLORHINTS=1
PROMPT_DIRTRIM=2
PROMPT_COMMAND='__git_ps1 "\[\e[01;34m\]\w\[\e[0m\]" "\n\h\$ "'
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# aliases for homeshick
alias hs-update="homeshick pull dotfiles && homeshick link dotfiles"
alias hs="homeshick"

# random aliases
alias st="git status"
alias api='http --auth-type=jwt --auth="$API_TOKEN"'

gi() {
  echo "$*" >> .gitignore
}

