#!/bin/sh
#
# nu: print number of unique users currently logged on

exec who | cut -d' ' -f1 | uniq | wc -l
