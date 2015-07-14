#!/bin/bash

function usage() {
    echo "Dump MySQL database on all your running docker"
    echo "Usage: mysql-dumper target-dir-name"
    echo "  target-dir-name: The name of the directory where all the dumps will be dropped (ex: 2015-06-26)"
    exit -1;
}

DIR_NAME=""
VERBOSE=""
for arg in "$@"
do
    case "$arg" in
    --help) usage;;
    -h)	usage;;
    -v)	VERBOSE=1;;
    *)	DIR_NAME="$arg";;
    esac
done

if [ -z $DIR_NAME ]
then
    usage
fi

DUMP_PATH="/mnt/$DIR_NAME";
mkdir -p "$DUMP_PATH"
cd "$DUMP_PATH"

function log_date() {
    date '+%Y-%m-%d %H:%M:%S'
}

function log() {
    echo "[$(log_date)] $*"
}

function verbose() {
    if [ $VERBOSE ];
    then
    log "[DEBUG] $*"
    fi
}

log "Start dump in $DUMP_PATH"
eval `docker-gen /usr/local/etc/mysql-dumper.tpl`
