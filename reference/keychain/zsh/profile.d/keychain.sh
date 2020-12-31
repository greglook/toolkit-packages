# Sets up keychain agents on login.

# Initialize the ssh key agent.
$HOME/util/keychain/ssh-agent.sh
source $HOME/.ssh/agent_info > /dev/null

# Add the default key if none are present.
ssh-add -l > /dev/null || ssh-add

# TODO: set up gpg-agent?
