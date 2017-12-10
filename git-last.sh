#!/bin/bash
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
# Print out last commit message from current branch for each
# file/directory in pwd

git ls-tree --name-only HEAD | \
    while read f; do
        git --no-pager log -n 1 --format="$f:|%s|(%h) %an" -- $f
    done | \
    column -t -s "|" | \
    sed "s@\(.*:\)\(.*\)\((.*)\)\(.*\)@`FG 2`\1`FG 9`\2`FG 3`\3`FG 5`\4@"

