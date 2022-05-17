#!/bin/sh
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2014 Jeremy Brubaker <jbru362@gmail.com>
#
# abstract: kill processes by name
#

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

