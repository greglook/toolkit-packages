# Shell profiling functions to keep track of multiple timers.


##### PROFILING FUNCTIONS #####

typeset -A profile_start


epoch_millis() {
    echo $(($(date +%s%N)/1000000))
}


profile_begin() {
    local profile=${1:-default}
    profile_start[$profile]=$(epoch_millis)
}


profile_end() {
    local profile=${1:-default}
    local start=$profile_start[$profile]
    # TODO: check for empty start
    local end=$(epoch_millis)
    local elapsed=$(awk "BEGIN { print $end - $start }")
    echo "$profile: $elapsed ms"
}
