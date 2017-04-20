#
# ~/.bashrc
#

# If not running interactively, don't do anything

# Variables

[[ $- != *i* ]] && return

export BASHRC_DIR="${HOME}/.bash"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR=vim
export PATH="${PATH}:${HOME}/.bin"

RUBY_GEMS=$(ls -t -U | ruby -e 'puts Gem.user_dir' 2> /dev/null)

if [[ ! -z $RUBY_GEMS ]]; then
    export PATH="${PATH}:${RUBY_GEMS}/bin"
fi

if [[ -z $TMUX ]]; then
    export TERM=xterm-256color
else
    export TERM=screen-256color
fi

# Load settings
for rc in ${BASHRC_DIR}/*.sh ; do
    source ${rc};
done

# SSH agent
if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi

if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing) > /dev/null
fi

ssh-add -l > /dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# Rename tmux window on ssh
function ssh {
    if [[ ! -z ${TMUX} ]]; then
        tmux rename-window "$(echo $* | rev | cut -d ' ' -f1 | rev)"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}
