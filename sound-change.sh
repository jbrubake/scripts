#! /usr/bin/env sh
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
# Copyright 2021 Jeremy Brubaker <jbru362@gmail.com>
#
# Based on:
#   https://gist.github.com/miyl/40cdf1a66b360ad8ec0b19e2ffa56194
#
# Removing pulseaudio means removing pacmd, so this is an attempt at switching the default via pactl instead.
# It successfully sets the default - BUT it appears my programs don't go to that default for some reason?
#
# Unlike the other scripts where sinks are specified, this just switches between whatever sinks exist.
# Sinks can be specified by name or index. Index changes sometimes when you disconnect and reconnect, restart or whatever, so names are better.
# Annoyingly the command used to switch audio over to a new sink cannot take a name as its argument, otherwise I'd only need the name here.
#
# abstract: change sound output device
#
# TODO: Trigger a zenity or dmenu dialog with entr that asks whether to switch monitor and/or sound to hdmi? Could do the same for mounting.

# Names, which unlike indexes, are persistent

get_all_sinks() {
  pactl list short sinks | cut -f 2
}

get_default_sink() {
  pactl info | grep 'Default Sink' | cut -d':' -f 2
}

# DEF_SINK=$(get_default_sink)
# for SINK in $(get_all_sinks) ; do
  # [ -z "$FIRST" ] && FIRST=$SINK # Save the first index in case the current default is the last in the list
  # get_default_sink currently returns the index with a leading space
  # if [ " $SINK" = "$DEF_SINK" ]; then
    # NEXT=1;
  # Subsequent pass, don't need continue above
  # elif [ -n "$NEXT"  ]; then
    # NEW_DEFAULT_SINK=$SINK
    # break
  # fi
# done

# Don't particularly like this method of making it circular, but...
# [ -z "$NEW_DEFAULT_SINK" ] && NEW_DEFAULT_SINK=$FIRST;

# Set default sink for new audio playback
# pactl set-default-sink "$NEW_DEFAULT_SINK"

#SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

#notify-send --expire-time 1350 "Switched default output sink to: $($SCRIPT_DIR/print-default-sink.sh)"

# Switch all currently running audio streams over to the newly selected sink, via the script I found
# TODO: I think the below might need the index, not the name!:
# "$SCRIPT_DIR"/pipe-out-sink-switch-realtime.sh $NEW_DEFAULT_SINK

# THIS IS WHAT I NEED
pactl set-default-sink $(pactl list short sinks | cut -f2 | dmenu)

