#!/usr/bin/env bash

parse_svn_branch() {
  parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk '{print ""$1"" }'
}
parse_svn_url() {
  svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
parse_svn_repository_root() {
  svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}

# Colors

RED="\e[0;31m"
RED_BOLD="\e[1;31m"

GREEN="\e[1;32m"

RESET="\e[0m"

PS1="${RED_BOLD}host${RESET}::${GREEN}\h${RESET} "
PS1="${PS1}${RED_BOLD}pwd${RESET}::${RED}\w${RESET} "
PS1="${PS1}${RED_BOLD}svn${RESET}::${RED}$(parse_svn_branch)${RESET} "
PS1="${PS1}\n"
PS1="${PS1}${RED_BOLD}user${RESET}::${GREEN}\u${RESET} $> "