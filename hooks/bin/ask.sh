#!/bin/bash

# Ask yes/no
# $1 Question text
# $2 No answer text
# $3 Yes answer text
ask_simple()
{
    if [[ -t 1 ]]
    then
        # Read user input, assign stdin to keyboard
        exec < /dev/tty
    else
        echo "No terminal found, ignoring warning."
        exit 0
    fi

    while read -p " > $1 (Y/n) " yn; do
        case ${yn} in
            [Yy] ) echo -e "$3"; break;;
            [Nn] ) echo -e "$2"; exit 1;;
            * ) echo "Please answer y (yes) or n (no):" && continue;
        esac
    done
}

"$@"
