#!/usr/bin/env sh


function open() {
    # Open any given document file(s) for editing (or just viewing).

    if [ -x /usr/bin/exo-open ] ; then
        # echo "exo-open $@" >&2
        setsid exo-open "$@" >& /dev/null
        return
    fi

    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            # echo "xdg-open $file" >&2
            setsid xdg-open "$file" >& /dev/null
        done
        return
    fi

    echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}


function main() {
    echo "I am running the main function"
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
    # conditional running
    main "$@"
fi
