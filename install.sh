#!/bin/sh

srcpath=`pwd |sed -e "s#$HOME/\?#../#"`

for t in *
do
    # skip support files
    if [ "$t" = "installsh" ]; then continue; fi
    if [ "$t" = "setuphome.sh" ]; then continue; fi
    if [ "$t" = "README.md" ]; then continue; fi

    # ensure permissions
    chmod 700 $t

    # skip existing links
    if [ -h "$HOME/bin/$t" ]; then continue; fi

    # move existing files out of the way
    if [ -e "$HOME/bin/$t" ]; then
        if [ -e "$HOME/bin/__$t" ]; then
            echo "want to override $HOME/bin/$t but backup exists"
            continue;
        fi

        echo -n "Backup "
        mv -v "$HOME/bin/$t" "$HOME/bin/__$t"
    fi

    # create link
    echo -n "Link "
    ln -v -s "$srcpath/$t" "$HOME/bin/$t"
done

