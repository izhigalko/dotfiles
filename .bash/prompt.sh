#!/usr/bin/env bash

# Colors

RED="\e[0;31m"
RED_BOLD="\e[1;31m"
GREEN="\e[1;32m"
RESET="\e[0m"

function get_git_branch() {
    local prefix="${RED_BOLD}git${RESET}::"
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    [[ -n ${branch} ]] && printf "${prefix}${GREEN}${branch/#HEAD/detached}${RESET} "
}

function get_svn_branch() {
    local prefix="${RED_BOLD}svn${RESET}::"
    local svn_url=$(svn info 2> /dev/null | grep "^Relative URL: \^" | sed 's#^Relative URL: \^##g')
    local branch=$(printf "${svn_url}" | perl -ne 'm/((?<=\/branches\/)([^\/]+)|(?<=\/tags\/)([^\/]+)|(?<=\/)(trunk))/; print "$1\n"')

    if [[ -n ${branch}  ]] ; then

        printf "${prefix}${GREEN}${branch}${RESET} "

    elif [[ -n ${svn_url} ]] ; then

        printf "${prefix}${GREEN}${svn_url}${RESET} "

    fi
}

function get_virtual_env() {
    if [[ -n ${VIRTUAL_ENV} ]] ; then
        local venv=$(basename ${VIRTUAL_ENV})
        printf "${RED_BOLD}venv${RESET}::${GREEN}${venv}${RESET} "
    fi
}

# Prompt

PS1="\[${RED}\]\h\[${RESET}\]:\[${RED}\]\w\[${RESET}\] "
PS1="${PS1}\$(get_svn_branch)"
PS1="${PS1}\$(get_git_branch)"
PS1="${PS1}\$(get_virtual_env)"
PS1="${PS1}\n"
PS1="${PS1}\[${RED_BOLD}\]user\[${RESET}\]::\[${GREEN}\]\u\[${RESET}\] $> "
