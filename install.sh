#!/bin/sh
#
# XXX: Description
#
#
# Usage:
#     install [OPTIONS]
#
# -n, --hostname         Override hostname
# -f, --force            Overwrite existing files and links
# -d, --destination=dest Install to dest instead of ~/bin
# -v, --verbose
#
# Exit codes:
#  1 = invalid option
#  3 = destdir not found
#
# TODO:
#  Only install if files are newer

## Reset just in case
# No other security precautions. This is a trusting script
IFS='
 	'

##
## Command line options
##
FORCE=              # do not overwrite files
VERBOSE=            # empty means be quiet
DESTDIR="$HOME/bin" # where to install everything
HOST=`hostname`
IGNOREFILE=.ignore  # list of files that shouldn't be linked
HOSTIGNORE="$IGNOREFILE.$HOST"    # host-specific ignore file

process_options ()
{
    while getopts "n:fd:i:v" opt; do
        case $opt in
          n) HOST=$OPTARG; HOSTIGNORE="$IGNOREFILE.$OPTARG" ;;
          f) FORCE='-f' ;;
          d) DESTDIR=$OPTARG ;;
          v) VERBOSE='-v' ;;
          ?) exit 1 ;;
        esac
    done
}

process_options "$@"

if ! test -d "$DESTDIR" && ! mkdir -p "$DESTDIR"
then
    echo "Could not create $DESTDIR" >&2
    exit 3
fi

# Action happens here, following these rules:
#
# - skip files in .ignore
# - skip files in .ignore.<host> if hostname = <host>
# - if -f was *not* specified
# -     Skip existing links
# -     Backup existing files
# -     Skip existing files if backup exists
# - else -f *was* specified
# -     Overwrite existing links and files
#
for f in *
do
    # skip ignored files
    test -e "$IGNOREFILE" &&
        grep "$f$" "$IGNOREFILE" >/dev/null && continue
    test -e "$HOSTIGNORE" &&
        grep "$f$" "$HOSTIGNORE" >/dev/null && continue

    # if file exists and -f not specified, make backups
    if test -e "$DESTDIR/$f" || test -L "$DESTDIR/$f" &&
        test -z $FORCE
    then
        # backup existing files
        # FIXME: This doesn't work if $f contains a pathname
        if test -e "$DESTDIR/__$f"
        then
            echo "Backup __$f already exists. Skipping" >&2
            continue
        else
            echo mv $VERBOSE $FORCE "$DESTDIR/$f" "$DESTDIR/__$f"
        fi
    fi

    # install
    echo cp $VERBOSE "$f" "$DESTDIR"
done

