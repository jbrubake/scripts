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
# Copyright 2026 Jeremy Brubaker <jbru362@gmail.com>
#
# abstract: ABSTRACT
#
# Defaults {{{1
#
# Documentation {{{1
#
VERSION=1.0
print_version() { # {{{2
    cat <<END
$(basename "$0") $VERSION
Copyright (C) 2026 Orion Arts
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Jeremy Brubaker.
END
} >&2

print_help() { # {{{2
    cat <<END
Usage: $(basename "$0") [OPTION]

DESCRIPTION

  -h, --help       display this help and exit
  -V, --version    output version information and exit
END
} >&2

# Process options {{{1
#
# Based on Adam Katz's original at
# https://gist.github.com/adamhotep/895cebf290e95e613c006afbffef09d7
#
# a refinement of https://stackoverflow.com/a/5255468/519360 see also [his]
# non-translating version at https://stackoverflow.com/a/28466267/519360
#
print_noarg()   { printf '%s requires an argument\n' "$1"; } >&2
print_invalid() { printf 'Invalid option: %s\n' "$1"; } >&2

# Preprocess long options {{{2
#
reset=true stopped= grab=
for opt in "$@"; do
    # {{{
    # reset the "$@" array so we can rebuild it
    if [ -n "$reset" ]; then
        set --
        unset reset
    fi

    # Split --option=arg
    case $opt in
        --?*=*)  optarg=${opt#*=} opt=${opt%%=*} ;;
        *)       unset optarg ;;
    esac

    # If $grab is set then we have an option waiting for an argument
    if [ -n "$grab" ]; then
        optarg=$opt # $opt holds the needed argument
        opt=$grab   # recheck the previous option
        unset grab  # unset the flag
    fi

    case $stopped$opt in
        --)                stopped=true; set -- "$@" -- ;;
        # }}}
        # Long options
        #
        --long-short)      set -- "$@" -L ${optarg+"$optarg"} ;;
        --long-only-noarg) echo Got --long-only-noarg ;;
        --long-only)
            # $optarg is normally only set if we passed --opt=arg. If we passed
            # '--opt arg' without the '=' we need to grab the next value of $opt
            # as our argument
            #
            # $optarg is set so we can process the option
            if [ -n "$optarg" ]; then
                echo "Got --long-only=$optarg"
            # $optarg is not set so we set a flag to the name of this option so
            # the next time through the loop we can match this block again
            else
                grab=--long-only
            fi
            ;;

        --help)    set -- "$@" -h ;;
        --version) set -- "$@" -V ;;
        # {{{

        --*)       print_invalid "$opt"; print_help; exit 1 ;;
        *)         set -- "$@" "$opt" ;;
    esac
done
# }}}

# Process short options {{{2
#
while getopts ":L:hV" opt; do
    case $opt in
        L)  echo Got --long-short=$OPTARG ;;

        h)  print_help; exit ;;
        V)  print_version; exit ;;

        \?) print_invalid "-$OPTARG"; print_help; exit 1 ;;
        :)  case $OPTARG in
                c) opt='-c, --config' ;;
            esac
            print_noarg "$opt"; print_help; exit 1 ;;
    esac
done
shift $((OPTIND-1))
OPTIND=1

# Main {{{1
#
