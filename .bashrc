#
# ~/.bashrc
#

# If not running interactively, don't do anything

# Variables

[[ $- != *i* ]] && return

export BASHRC_DIR="${HOME}/.bash"
export WORKON_HOME=/opt/dev/virtualenvs
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR=vim
export TERM=xterm-256color
export PATH="${PATH}:${HOME}/.bin"

# Load settings

if [[ -d ${BASHRC_DIR} ]] ; then

    for rc in ${BASHRC_DIR}/*.sh ; do

        source ${rc}

    done

elif [[ -f ${BASHRC_DIR} ]] ; then

    source ${BASHRC_DIR}

fi

# SSH agent

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi

if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing) > /dev/null
fi

ssh-add -l > /dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

