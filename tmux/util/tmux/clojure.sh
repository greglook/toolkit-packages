#!/bin/zsh

# Initialize a tmux workspace session for a Clojure project. The first argument
# should be an absolute path to the project's root directory. The session name
# defaults to the project directory name. If a namespace is given, the src and
# test editor panes will be started in the respective nested directories.

if [[ -z "$1" ]]; then
    echo "Usage: $0 <project root> [session name] [code namespace]"
    exit 1
fi

# Recurse into subdirectories and print the first one containing multiple
# children. This can be used to traverse common namespace chains in source
# hierarchies.
seek_into() {
    d=$1
    while [[ -d $d ]]; do
        c=($d/*)
        [[ ${#c[@]} -ne 1 ]] && break
        d="${c[1]}"
    done
    echo $d
}

PROJECT_ROOT=$(cd $1 && pwd)
SESSION=${2:-$(basename $PROJECT_ROOT)}
NAMESPACE=$(echo $3 | tr '.-' '/_')

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
cd $PROJECT_ROOT

# Initialize workspace
tmux -2 new-session -d -s $SESSION #-c "$PROJECT_ROOT"

tmux new-window -t "$SESSION:0" -n 'misc' -c "$HOME" -k

tmux new-window -t "$SESSION:1" -n 'build' -c "$PROJECT_ROOT"

tmux new-window -t "$SESSION:2" -n 'repl' -c "$PROJECT_ROOT"
#tmux send-keys -t "$SESSION:2" "lein repl" C-m

tmux new-window -t "$SESSION:3" -n 'src' -c "$(seek_into "$PROJECT_ROOT/src")"

tmux new-window -t "$SESSION:4" -n 'test' -c "$(seek_into "$PROJECT_ROOT/test")"
tmux split-window -t "$SESSION:4" -h -c "$PROJECT_ROOT"
#tmux send-keys -t "$SESSION:4.1" "lein test-refresh" C-m

tmux new-window -t "$SESSION:5" -n 'doc'  -c "$PROJECT_ROOT/doc"

# Attach to session
tmux select-window -t "$SESSION:3"
tmux select-window -t "$SESSION:1"

exec tmux attach -t "$SESSION"
