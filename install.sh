#!/bin/sh
#
# Install all files to DESTDIR (default is $HOME/bin),
# excluding any files in .ignore and .ignore.<hostname>.
# The ignore files support shell globbing.
#
#
# TODO: Install only if dest is older
show_help() {
    cat <<EOF
Usage:
    install.sh [OPTIONS]

-n, --hostname         Override hostname
-f, --force            Overwrite existing files and links
-d, --destination=dest Install to dest instead of ~/bin
-v, --verbose
-h, --help
EOF
    exit
}
#
# Exit codes:
   ERR_INVALID_OPTION=1
   ERR_DESTDIR_NOT_FOUND=2
#

## Reset just in case
# No other security precautions. This is a trusting script
IFS='
 	'

##
## Command line options
##
BACKUP=-b           # backup existing files
VERBOSE=            # empty means be quiet
DESTDIR="$HOME/bin" # where to install everything
HOST=`hostname`
IGNOREFILE=.ignore  # list of files that shouldn't be linked
HOSTIGNORE="$IGNOREFILE.$HOST"    # host-specific ignore file

while getopts "n:fd:vh" opt; do
    case $opt in
        n) HOST=$OPTARG; HOSTIGNORE="$IGNOREFILE.$OPTARG" ;;
        f) BACKUP= ;;
        d) DESTDIR=$OPTARG ;;
        v) VERBOSE='-v' ;;
        h) show_help ;;
        ?) exit $ERR_INVALID_OPTION ;;
    esac
done

if ! test -d "$DESTDIR" && ! mkdir -p "$DESTDIR"
then
    echo "Could not create $DESTDIR" >&2
    exit $ERR_DESTDIR_NOT_FOUND 
fi

# Action happens here, following these rules:
#
# - skip files in .ignore and .ignore.<host>
# - if -f was *not* specified
# -     Backup existing files
# -     Skip existing files if backup exists
# - else -f *was* specified
# -     Overwrite existing links and files
#
for f in *
do

    # skip ignored files. Works with shell globs
    for p in $(cat $IGNOREFILE $HOSTIGNORE 2>/dev/null); do
        test $f = $p && continue 2 # continue OUTER loop
    done

    # skip if -f not specified and backup exists
    if test -e "$DESTDIR/$f~" && test $BACKUP = '-b'
    then
        echo "Backup $f~ already exists. Skipping" >&2
        continue
    fi

    # install
    install $VERBOSE $BACKUP -t "$DESTDIR" "$f"
done

