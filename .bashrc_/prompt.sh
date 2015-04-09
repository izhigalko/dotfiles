#!/usr/bin/env bash
function get_git_branch() {
    local prefix="${RED_BOLD}git${RESET}::"
    local branch=$(git name-rev HEAD 2> /dev/null | pcregrep -o "(?<=HEAD )(.*)")
    [[ -n ${branch} ]] && echo -e "${prefix}${GREEN}${branch}${RESET} "
}

function get_svn_branch() {
    local prefix="${RED_BOLD}svn${RESET}::"
    local svn_url=$(svn info 2> /dev/null | pcregrep -o "(?<=Relative URL: \^)(.*)")
    local branch=$(echo ${svn_url} | pcregrep -o "(?<=\/branches\/)([^\/]+)|(?<=\/tags\/)([^\/]+)|(?<=\/)(trunk)")

    if [[ -n ${branch}  ]] ; then

        echo -e "${prefix}${GREEN}${branch}${RESET} "

    elif [[ -n ${svn_url} ]] ; then

        svn_url=$(echo ${svn_url} | pcregrep -o "")
        echo -e "${prefix}${GREEN}${svn_url}${RESET} "

    fi
}

function get_virtual_env() {
    if [[ -n ${VIRTUAL_ENV} ]] ; then
        local venv=$(basename ${VIRTUAL_ENV})
        echo -e "${RED_BOLD}venv${RESET}::${GREEN}${venv}${RESET} "
    fi
}

# Colors

RED="\e[0;31m"
RED_BOLD="\e[1;31m"

GREEN="\e[1;32m"

RESET="\e[0m"

# Prompt

PS1="\[${RED_BOLD}\]host\[${RESET}\]::\[${GREEN}\]\h\[${RESET}\] "
PS1="${PS1}\[${RED_BOLD}\]pwd\[${RESET}\]::\[${GREEN}\]\w\[${RESET}\] "
PS1="${PS1}\$(get_svn_branch)"
PS1="${PS1}\$(get_git_branch)"
PS1="${PS1}\$(get_virtual_env)"
PS1="${PS1}\n"
PS1="${PS1}\[${RED_BOLD}\]user\[${RESET}\]::\[${GREEN}\]\u\[${RESET}\] $> "