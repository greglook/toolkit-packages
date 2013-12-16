# Updates a symlink pointing to the ssh-agent authentication socket. When
# executed outside tmux, this updates the symlink to point to the current auth
# socket. When run inside tmux, this sets the shell's environment to point to
# the symlink.


# only meaningful if logged in via ssh
if [[ -n "$SSH_TTY" ]]; then

    local auth_link="$HOME/.ssh/auth_sock"

    # if running outside of tmux...
    if [[ -z "$TMUX" ]]; then

        # update link to reflect auth socket
        if [[ -z "$SSH_AUTH_SOCK" ]]; then
            rm -f $auth_link
        else
            ln -sf $SSH_AUTH_SOCK $auth_link
        fi

    # if running inside of tmux...
    else

        # if link exists, set up env variable
        if [[ -e $auth_link ]]; then
            export SSH_AUTH_SOCK=$auth_link
        else
            unset SSH_AUTH_SOCK
        fi

    fi

fi
