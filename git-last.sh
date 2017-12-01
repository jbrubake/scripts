#!/bin/bash
#
# Print out last commit message from current branch for each
# file/directory in pwd

git ls-tree --name-only HEAD | \
    while read f; do
        git --no-pager log -n 1 --format="$f:|%s|(%h) %an" -- $f
    done | \
    column -t -s "|" | \
    sed "s@\(.*:\)\(.*\)\((.*)\)\(.*\)@`FG 2`\1`FG 9`\2`FG 3`\3`FG 5`\4@"

