#!/usr/bin/env bash

if [[ `which grc 2> /dev/null` ]] ; then
    alias grc='grc --colour=auto'
    alias ping='grc ping'
    alias last='grc last'
    alias netstat='grc netstat'
    alias traceroute='grc traceroute'
    alias make='grc make'
    alias gcc='grc gcc'
    alias configure='grc ./configure'
    alias cat="grc cat"
    alias tail="grc tail"
    alias head="grc head"
fi
alias ls='ls --color=auto --all --human-readable --group-directories-first'
alias grep='grep --color=auto'
alias cp='cp --interactive --verbose --recursive --preserve=all'
alias mv='mv --interactive --verbose'
alias rm='rm --recursive --interactive --verbose'
alias du='du --human-readable'
alias df='df --human-readable'
alias free='free --human --total'
[[ `which colordiff 2> /dev/null` ]] && alias diff='colordiff'
alias sudo='sudo -E'
