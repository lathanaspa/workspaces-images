#!/usr/bin/env bash
set -ex

START_COMMAND="/opt/zoho-mail-desktop/squashfs-root/launcher"
PGREP="zoho-mail-desktop"
export MAXIMIZE="true"
export MAXIMIZE_NAME="Zoho Mail"
MAXIMIZE_SCRIPT="${STARTUPDIR}/maximize_window.sh"
DEFAULT_ARGS=""
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit 1
eval set -- "$options"

while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        -u|--url) OPT_URL=$2; shift 2;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

FORCE=$1

kasm_exec() {
    if [ -n "$OPT_URL" ] ; then
        URL=$OPT_URL
    elif [ -n "$1" ] ; then
        URL=$1
    fi

    /usr/bin/filter_ready
    /usr/bin/desktop_ready
    bash "${MAXIMIZE_SCRIPT}" &
    "${START_COMMAND}" ${ARGS}
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] || [ -n "$FORCE" ] ; then
        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -f "$START_COMMAND" > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                set +e
                bash "${MAXIMIZE_SCRIPT}" &
                "${START_COMMAND}" ${ARGS}
                set -e
            fi
            sleep 1
        done
        set -x
    fi
}

if [ -n "$GO" ] || [ -n "$ASSIGN" ] ; then
    kasm_exec
else
    kasm_startup
fi