#!/bin/sh
#
# zap: kill processes by name

case $1 in
    -*) SIG=$1; shift ;;
esac

if test -z $1
then
    echo 'Usage: zap [-2] pattern' 1>&2
    exit 1
fi

# Get our name so we can ignore
# our process and child processes
# TODO: Can I filter based on parent and child PIDs?
prog=`basename $0`

pids=`ps u -U $USER |
    awk '
        NR == 1 { print >"/dev/tty" } # Print ps header
        NR > 1 && /'$*'/ && $0 !~ /'$prog'/ { print | "pick -" }' |
            awk '{ print $2 }'` # Pull out the PID

if test -z $pids
then
    echo "No processes selected" >&2
    exit 1
fi

kill $SIG $pids

