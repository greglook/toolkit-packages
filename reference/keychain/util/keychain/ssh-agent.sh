#!/bin/bash

# This script wraps the invocation of the ssh-agent to ensure that the
# requested keys are loaded.


##### CONFIGURATION #####

# path to the cached agent info file
agent_info="$HOME/.ssh/agent_info"



##### AGENT CONTROL #####

# Gets the IDs of any running ssh-agent processes, separated by newlines.
agent_pids() {
    #ps -u $USER -o pid,comm | grep -P '^\s*\d+ ssh-agent' | awk '{ print $1 }'
    for proc in /proc/[0-9]*; do
        pid=$(echo $proc | cut -d / -f 3)
        if cat /proc/$pid/cmdline 2> /dev/null | grep -P '^ssh-agent' > /dev/null; then
            echo $pid
        fi
    done
}


# Returns success if the shell is currently connected to an ssh-agent.
agent_is_connected() {
    if [[ -n "$SSH_AUTH_SOCK" && -n "$SSH_AGENT_PID" ]]; then
        if [[ ! -S $SSH_AUTH_SOCK ]]; then
            #echo "ssh-agent socket $SSH_AUTH_SOCK does not exist"
            return 1
        fi
        if [[ -n "$(agent_pids | grep $SSH_AGENT_PID)" ]]; then
            #echo "ssh-agent ($SSH_AGENT_PID) is connected"
            return 0
        else
            #echo "ssh-agent connection info is present but no matching process ($SSH_AGENT_PID) was found"
            return 1
        fi
    fi
    #echo "No ssh-agent connected"
    return 1
}


# Loads the agent information file.
load_agent_info() {
    source $agent_info > /dev/null
}


# Starts the ssh-agent and writes information to file.
start_agent() {
    ssh-agent | grep -v "echo" > $agent_info
    chmod 600 $agent_info
}



##### AGENT INITIALIZATION #####

# abort if already connected to an ssh-agent
if agent_is_connected; then
    echo "Already connected to ssh-agent ($SSH_AGENT_PID)"
    exit
fi

# if there is a cached info file and a running agent, try to use it
if [[ -f $agent_info && -n "$(agent_pids)" ]]; then
    #echo "Attempting to use cached ssh-agent info file"
    load_agent_info
    if agent_is_connected; then
        echo "Connected to ssh-agent ($SSH_AGENT_PID)"
        exit
    fi
fi

# need to load the keychain
#echo "No ssh-agent connection info available, launching new agent"

# kill running agents
for pid in $(agent_pids); do
    echo "Killing running ssh-agent ($pid)"
    kill -KILL $pid
done

# launch ssh-agent
if start_agent && load_agent_info; then
    echo "Started ssh-agent ($SSH_AGENT_PID)"
else
    echo "Failed to start ssh-agent!"
fi
