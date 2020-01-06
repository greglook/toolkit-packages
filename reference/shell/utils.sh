# Common utilities for writing shell scripts.


### PREAMBLE ###

set -eo pipefail

if [[ -n $DEBUG ]]; then
    set -x
fi


### FUNCTIONS ###

fail() {
    echo "$@" >&2
    exit 1
}

color() {
    readonly ansi="$1"
    readonly bold="$2"
    shift 2
    if [[ $bold == 1 ]]; then
        echo -ne "\033[1;${ansi}m$@\033[0m"
    else
        echo -ne "\033[${ansi}m$@\033[0m"
    fi
}

red() { color 31 "$@"; }
green() { color 32 "$@"; }
yellow() { color 33 "$@"; }
blue() { color 34 "$@"; }
magenta() { color 35 "$@"; }
cyan() { color 36 "$@"; }
