# Disable default greeting
set -U fish_greeting

# Commands to run in interactive sessions go here
if status is-interactive
    if test $TERM != linux
        starship init fish | source
    end
end
