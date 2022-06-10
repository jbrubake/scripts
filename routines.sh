#!/bin/sh
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2022 Jeremy Brubaker <jbru362@gmail.com>
#
# abstract: dmenu shell routines
#

set -u

_progname="$(basename $0)"
_xrdb="$(xrdb -query | grep "$_progname")"

getxres() { echo "$_xrdb" | awk "/$_progname.*$1/ {print \$2}"; }

make_dmenu_args() {
    _resources="font
                background
                foreground
                selbackground
                selforeground
                hibackground
                hiforeground
                hiselbackground
                hiselforeground
                outforeground
                outbackground
                borderwidth"

    _args=
    _r=
    for _r in $_resources; do
        _val=$(getxres "$_r")
        test -z "$_val" && continue

        case "$_r" in
            background)    _args="$_args -nb  $_val" ;;
            foreground)    _args="$_args -nf  $_val" ;;
            selbackground) _args="$_args -sb  $_val" ;;
            selforeground) _args="$_args -sf  $_val" ;;
            hibackground)  _args="$_args -nhb $_val" ;;
            hiforeground)  _args="$_args -nhf $_val" ;;
            outbackground) _args="$_args -shb $_val" ;;
            outforeground) _args="$_args -shf $_val" ;;
            font)          _args="$_args -fn  $_val" ;;
            borderwidth)   _args="$_args -bw  $_val" ;;
        esac

    done

    echo "$_args"
}

