#!/usr/bin/awk -f
#
# Print a ruler across the screen
#
# Based on a script posted by Jesse654 on
#   https://forums.linuxmint.com/viewtopic.php?t=91908
#

BEGIN {
    "tput cols" | getline col

    for ( i = 1;  i <= col / 10;  ++i )
        printf "        " (i<10? " " : "") i   #  eight spaces + 1 possible
    printf "\n"

    for ( i = 1;  i <= col;  ++i )
        printf i % 10
    printf "\n"
}
