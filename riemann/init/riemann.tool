#!/sbin/runscript

# This script assumes that Riemann has a user and group set up, and that the
# system gem `riemann-tools` has been installed. This script should not be run
# directly; instead, link other scripts to this one like so:
#
#   $ ln -s /etc/init.d/riemann.tool riemann.health
#
# Author: Greg Look (greg@mvxcvi.com)

TOOL=${RC_SVCNAME:8}
COMMAND="riemann-$TOOL"

RUN_DIR=/var/run/riemann/tool
PIDFILE=$RUN_DIR/${TOOL}.pid

checktool() {
    if [ 'tool' == "$TOOL" ]; then
        eerror "The riemann.tool script is a meta-script!"
        eerror "Instead, symlink other tool scripts to this one."
        eend 1
        exit
    fi
}

depend() {
    need riemann
}

start() {
    checktool
    checkpath -d -m 0755 -o riemann:riemann $RUN_DIR
    ebegin "Starting Riemann $TOOL metrics"
    start-stop-daemon \
        --start \
        --user riemann:riemann \
        --pidfile $PIDFILE \
        --make-pidfile \
        --background \
        --exec $COMMAND -- \
        $RIEMANN_TOOL_ARGS \
        2>&1 > /dev/null
    eend $?
}

stop() {
    checktool
    ebegin "Stopping Riemann $TOOL metrics"
    start-stop-daemon \
        --stop \
        --pidfile $PIDFILE \
        --exec $COMMAND
    eend $?
}
