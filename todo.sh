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
# abstract: Add per-directory todo list support to todo.sh
#
# Requires todo.sh. The todo.txt configuration must only set TODO_FILE,
# DONE_FILE and REPORT_FILE if not already set
#
# Avoid infinite recursive calls if something is broken {{{1
#
if [ -n "$TODOSH_WRAPPER_RUN" ]; then
    printf 'todo.sh wrapper is calling itself!\n' >&2
    exit 1
else
    export TODOSH_WRAPPER_RUN=1
fi

# Set defaults to point to a local todo {{{1
#
# Keep TODO_DIR as the default so TODO_ACTIONS_DIR still points at the global
# location
#
# NOTE: Because of how todo.sh is written, $(pwd) is required if TODO_FILE is
# todo.txt. If TODO_FILE is hidden, todo.sh suppresses showing the uppercase
# basename when listing items
export TODO_FILE=$(pwd)/todo.txt
export DONE_FILE=.done.txt
# I don't think keeping the report is useful when it's so easy to regenerate
export REPORT_FILE=/dev/null

# Decide if we want the global or local todo list {{{1
#
case $1 in
    # Use the local todo list (create if necessary)
    #
    -l|--local)
        shift

        # todo.sh always creates a blank todo list if none exists. This makes
        # sense for a global todo but not a local one. So if the local file does
        # not exist we need check to see if we are creating a new item
        if ! [ -r "$TODO_FILE" -a -f "$TODO_FILE" ]; then
            unset skip create
            for arg in "$@"; do
                if [ -n "$skip" ]; then
                    unset skip
                    continue
                fi
                case $arg in
                    # -d todo_config is the only option that takes an argument
                    -d) skip=1; continue ;;
                    -*) continue ;;
                    # if we find one of these we are creating a todo item
                    add | a | addm) create=1; break ;;
                esac
            done

            # Exit with no output if there is no todo file and we aren't adding
            # an item. This lets the common case of checking for local todos
            # work the way you would expect
            [ -z "$create" ] && exit
        fi
        ;;

    # Use the global todo list
    -g|--global)
        shift
        # Unset so the global defaults are used
        unset TODO_FILE DONE_FILE REPORT_FILE
        ;;

    # Use the local todo list if it exists, otherwise the global todo list
    *)
        [ -f "$TODO_FILE" -a -r "$TODO_FILE" ] ||
            unset TODO_FILE DONE_FILE REPORT_FILE
        ;;
esac

# Use a custom default action if provided. todo.sh's TODOTXT_DEFAULT_ACTION does
# not support arguments but TODOSH_DEFAULT_ACTION does
[ $# -eq 0 -a -n "$TODOSH_DEFAULT_ACTION" ] &&
    set -- $TODOSH_DEFAULT_ACTION

# This wrapper is meant to be installed in $HOME so remove $HOME from $PATH
# before trying to call the real todo.sh
#
# command -p won't work because todo.sh might be installed in /usr/local/bin
path=$(echo "$PATH" | tr : '\n' | sed '/\/home/d' | paste -sd : -)
PATH=$path exec command todo.sh "$@"

