#
# ~/.bashrc
#

# If not running interactively, don't do anything

# Variables
export BASHRC_DIR="$HOME/.bashrc_"
export WORKON_HOME=/opt/dev/virtualenvs
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR=vim

[[ $- != *i* ]] && return

# Load settings

if [[ -d ${BASHRC_DIR} ]] ; then

    for rc in ${BASHRC_DIR}/*.sh ; do

        source ${rc}

    done

elif [[ -f ${BASHRC_DIR} ]] ; then

    source ${BASHRC_DIR}

fi
