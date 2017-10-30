#!/bin/bash

if [[ `which ssh-agent 2> /dev/null` ]]; then
    RUNNED_AGENT=$(pgrep -u $USER ssh-agent 2> /dev/null)

    # Restart agent if run without exporting variables
    if [[ ! -z $RUNNED_AGENT && -z $SSH_AGENT_PID ]]; then
        export SSH_AGENT_PID=$RUNNED_AGENT
        eval $(ssh-agent -k > /dev/null)
    fi

    if [[ -z $SSH_AGENT_PID ]]; then
        ssh-agent > ~/.ssh-agent-thing
        eval $(<~/.ssh-agent-thing) > /dev/null
    fi

    ssh-add -l > /dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
fi
