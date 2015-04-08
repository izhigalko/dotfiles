#!/usr/bin/env bash
function get_svn_branch() {
    local svn_url=$(svn info 2> /dev/null | awk '/^URL: .*/ { print $2 }')

    if [[ ${svn_url}  ]] ; then

        [[]]

    fi
}

# Colors

RED="\[\e[0;31m\]"
RED_BOLD="\[\e[1;31m\]"

GREEN="\[\e[1;32m\]"

RESET="\[\e[0m\]"

PS1="${RED_BOLD}host${RESET}::${GREEN}\h${RESET} "
PS1="${PS1}${RED_BOLD}pwd${RESET}::${RED}\w${RESET} "
PS1="${PS1}\n"
PS1="${PS1}${RED_BOLD}user${RESET}::${GREEN}\u${RESET} $> "