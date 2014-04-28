#!/bin/zsh

# Initialize a tmux workspace session for a Clojure project. The first argument
# should be an absolute path to the project's root directory. The session name
# defaults to the project directory name. If a namespace is given, the src and
# test editor panes will be started in the respective nested directories.

if [[ -z "$1" ]]; then
    echo "Usage: $0 <project root> [session name] [code namespace]"
    exit 1
fi

PROJECT_ROOT=$1
SESSION=${2:-$(basename $PROJECT_ROOT)}
NAMESPACE=$3

# Don't run inside tmux!
if [[ -n "$TMUX" ]]; then
    echo "Workspace must be set up from outside tmux!"
    exit 1
fi

# Check if session already exists.
if tmux has-session -t $SESSION 2> /dev/null; then
    echo "tmux already contains session: $SESSION"
    exit 1
fi

echo "Initializing Clojure workspace '$SESSION' at $PROJECT_ROOT"

# Initialize workspace
tmux -2 new-session -d -s $SESSION

tmux new-window -t "$SESSION:0" -n 'misc' -c "$HOME" -k

tmux new-window -t "$SESSION:1" -n 'git' -c "$PROJECT_ROOT"

tmux new-window -t "$SESSION:2" -n 'repl' -c "$PROJECT_ROOT/src/$NAMESPACE"
tmux send-keys -t "$SESSION:2" "lein trampoline repl" # C-m

tmux new-window -t "$SESSION:3" -n 'src' -c "$PROJECT_ROOT/src/$NAMESPACE"

tmux new-window -t "$SESSION:4" -n 'test' -c "$PROJECT_ROOT/test/$NAMESPACE"
tmux split-window -t "$SESSION:4" -h -c "$PROJECT_ROOT"
tmux send-keys -t "$SESSION:4.1" "lein test-refresh" # C-m

tmux new-window -t "$SESSION:5" -n 'doc'  -c "$PROJECT_ROOT/doc"

# Attach to session
tmux select-window -t "$SESSION:3"
tmux select-window -t "$SESSION:1"
tmux attach -t "$SESSION"
