# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Added Adnroid Home directory
# export ANDROID_HOME=/home/alvaro/android-sdk-linux/tools
# export PATH="$PATH:/home/alvaro/android-sdk-linux/platform-tools"

RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[33;1m\]"
GREEN="\[\033[32;1m\]"
BROWN="\[\033[0;33m\]"
BLUE="\[\033[34;1m\]"
WHITE="\[\033[37;1m\]"
SMILEY="${GREEN}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"

USER_DISTRO="${BROWN}[${GREEN}\u ${BLUE}$(lsb_release -is)${BROWN}]"

#----------------------- GIT INFO on PROMPT -------------------------
#parse_git_branch() {
# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#}

# Get number of files added to the index (but uncommitted)
function git_num_added_files {
  expr $(git status --porcelain 2>/dev/null| grep "^M" | wc -l)
}

# Get number of files that are uncommitted and not added
function git_num_not_added {
  expr $(git status --porcelain 2>/dev/null| grep "^ M" | wc -l)
}

# Get number of total uncommited files
#expr $(git status --porcelain 2>/dev/null| egrep "^(M| M)" | wc -l)

function git_num_untracked_files {
  expr $(git status --porcelain 2>/dev/null| grep "^??" | wc -l)
}

function parse_git_deleted {
  [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
}
function parse_git_untracked {
  [[ $(git status 2> /dev/null | grep "Arquivos não monitorados:") != "" ]] && echo '!'
}
function parse_git_added {
  [[ $(git status 2> /dev/null | grep "new file:") != "" ]] && echo '+'
}
function parse_git_modified {
  [[ $(git status 2> /dev/null | grep modificado:) != "" ]] && echo "*"
}
function parse_git_dirty {
  echo " $(parse_git_added)$(parse_git_deleted)$(parse_git_modified)$(parse_git_untracked)"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
GIT_BRANCH="${RED}\$(parse_git_branch)"

#---------------------------------------------------------------------------

PS1="${BROWN}\342\224\214\342\224\200${USER_DISTRO} \`${SELECT}\`\n${BROWN}\342\224\224\342\224\200>[${YELLOW}\w${BROWN}]${GIT_BRANCH}${BROWN}#${NORMAL} "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias la='ls -la'
    alias ~='cd ~'
    alias cd..='cd ..'
    alias ..='cd ..'
    alias .2='cd ../..'
    alias .3='cd ../../..'
    alias .4='cd ../../../..'
    alias .5='cd ../../../../..'
    alias path='echo -e ${PATH//:/\\n}'
    alias sudoe='sudo -E'
    alias svi='sudoe vim'
    alias edit='vim'
    alias mv='mv -i'
    alias cp='cp -i'
    alias ln='ln -i'
    alias rm='rm -i'

    alias histg="history | grep"

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'

fi

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm

#jade
#export JADE_LIB=/home/alvaro/jade/lib
#export JADE_CP=$JADE_LIB/http.jar:$JADE_LIB/iiop.jar:$JADE_LIB/jade.jar:$JADE_LIB/jadeTools.jar:
#$JADE_LIB/commons-codec/commons-codec-1.3.jar
#alias rJade='java -cp $JADE_CP jade.Boot'
#alias cJade='javac -cp $JADE_CP'

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/alvaro/.gvm/bin/gvm-init.sh" ]] && source "/home/alvaro/.gvm/bin/gvm-init.sh"
