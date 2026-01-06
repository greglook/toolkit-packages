# Set XDG environment variables and tool-specific configuration to keep the
# home directory clean(er).
# https://wiki.archlinux.org/title/XDG_Base_Directory

# Set base XDG vars
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DATA_HOME $HOME/.local/share

# AWS CLI
set -gx AWS_CONFIG_FILE $XDG_CONFIG_HOME/aws/config
set -gx AWS_SHARED_CREDENTIALS_FILE $XDG_CONFIG_HOME/aws/credentials

# Clojure
set -gx GITLIBS $XDG_STATE_HOME/clojure/gitlibs

# GPG
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg

# Leiningen
set -gx LEIN_HOME $XDG_DATA_HOME/lein

# NPM
set -gx NPM_CONFIG_INIT_MODULE  $XDG_CONFIG_HOME/npm/config/npm-init.js
set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm
set -gx NPM_CONFIG_TMP $XDG_RUNTIME_DIR/npm
#set -gx NPM_CONFIG_PREFIX $HOME/.local/

# Sqlite
set -gx SQLITE_HISTORY $XDG_CACHE_HOME/sqlite_history

# wget
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
