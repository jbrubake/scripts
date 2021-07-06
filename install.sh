#!/bin/sh
# vim: foldmethod=marker foldmarker={,}
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
# Documentation {
#
# Manpage {
# NAME:
#      install.sh
#
# SYNOPSIS:
#     install.sh [OPTION] 
#         (see print_help() below for more)
#
# DESCRIPTION:
#     Install files in local directory
#
#     Install all files in local directory  to DESTDIR (default
#     is $HOME/bin), excluding any files in .ignore and
#     .ignore.<hostname>. The ignore files support shell globbing.
#
# BUGS:
#     - None so far
#}
print_help() {
    cat <<EOF
Usage: install.sh [OPTION]
Install scripts and binaries to DESTDIR (default is $HOME/bin).

 -n=HOST       use HOST as the hostname
 -f            overwrite existing files and links
 -d=DEST       install to DEST instead of $HOME/bin
 -V            explain what is being done
 -h            display this help and exit
EOF
}
#}
logmsg () {
    # Output messages
    #
    # Depends on $VERBOSE

    test $VERBOSE = 'yes' && echo "$*"
}
logerror () {
    # Output error messages

    echo "$*" >&2
}
# Process options {
#
# Flag Variables
#
FORCE='no'
VERBOSE='no'
DESTDIR="$HOME/bin"
HOST=$( hostname )
IGNOREFILE=.ignore  # list of files that shouldn't be linked
HOSTIGNORE=$IGNOREFILE.$HOST    # host-specific ignore file

while getopts "n:fd:Vh" opt; do
    case $opt in
        n) HOST=$OPTARG; HOSTIGNORE="$IGNOREFILE.$h" ;;
        f) FORCE='yes' ;;
        d) DESTDIR=$OPTARG ;;
        V) VERBOSE='yes' ;;
        h) print_help; exit ;;
        *) print_help; exit ;;
    esac
done

# Convert flag variables to install(1) options
if test $VERBOSE = 'yes'; then
    verbose='-v' # install(1) verbose flag
else
    verbose=
fi

if test $FORCE = 'yes'; then
    force=
else
    force='-b' # install(1) backup
fi

if ! test -d "$DESTDIR" && ! mkdir -p "$DESTDIR"; then
    logerror "FATAL: Could not create $DESTDIR. Exiting!"
    exit
fi

# }
# Action happens here, following these rules:
#
# - skip files in .ignore and .ignore.<host>
# - skip files if copy in DESTDIR is newer
# - if -f was *not* specified
# -     Backup existing files
# -     Skip if backup exists
# - else -f *was* specified
# -     Overwrite existing links and files
#
for f in *; do
    # skip ignored files. Works with shell globs
    for p in $(cat $IGNOREFILE $HOSTIGNORE 2>/dev/null); do
        test $f = $p && continue 2 # continue OUTER loop
    done

    if test $FORCE = 'no' && test -e "$DESTDIR/.$f~"; then
        # skip if -f not specified and backup exists
        logmsg "Backup .$f~ already exists. Skipping"
        continue
    fi

    # install
    install $verbose $force -t "$DESTDIR" -- "$f"
done

