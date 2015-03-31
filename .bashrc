#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='[\u@\h \w]\$ '

case "$TERM" in
    rxvt-256color)
        TERM=rxvt-unicode
        ;;
    rxvt-unicode-256color)
        TERM=rxvt-unicode
        ;;
esac

export WORKON_HOME=/opt/dev/virtualenvs

[[ -f /usr/bin/virtualenvwrapper.sh ]] && source /usr/bin/virtualenvwrapper.sh
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
