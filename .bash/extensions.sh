#!/usr/bin/env bash
[[ -f ${BASHRC_DIR}/virtualenvwrapper/virtualenvwrapper.sh ]] && \
    [[ -d ${WORKON_HOME} ]] && \
    source ${BASHRC_DIR}/virtualenvwrapper/virtualenvwrapper.sh

[[ -f ${BASHRC_DIR}/bash-completion/bash_completion ]] && \
    . ${BASHRC_DIR}/bash-completion/bash_completion

[[ -f ${BASHRC_DIR}/git-completion.bash ]] && \
    source ${BASHRC_DIR}/git-completion.bash
