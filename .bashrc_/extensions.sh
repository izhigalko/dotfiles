#!/usr/bin/env bash
# Virtualenv wrapper
[[ -f /usr/bin/virtualenvwrapper.sh ]] && [[ -d ${WORKON_HOME} ]] && source /usr/bin/virtualenvwrapper.sh
# Completion
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion