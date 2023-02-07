#!/bin/bash

git_current_commit()
{
    commit=$(git rev-parse --verify HEAD)
    if [[ "$commit" != "" ]]
    then
        echo HEAD
    else
        # Initial commit: diff against an empty tree object
        echo 4b825dc642cb6eb9a060e54bf8d69288fbee4904
    fi
}

git_origin_commit()
{
    branch=$(git rev-parse --abbrev-ref HEAD)
    commit=$(git rev-parse --verify "origin/$branch")

    if [[ "$commit" != "" ]]
    then
        echo "$commit"
    else
        # Initial commit: diff against an empty tree object
        echo 4b825dc642cb6eb9a060e54bf8d69288fbee4904
    fi
}

git_modified_files()
{
    against="$1"

    for FILE in $(git diff-index --name-only --cached --diff-filter=ACMR "$against" --)
    do
        [[ -f "$FILE" ]] && echo "$FILE"
    done
}

git_modified_files_by_ext()
{
    EXT="$1"; shift
    EXT_LENGTH=$((${#EXT} + 1))

    for FILE in "$@"
    do
        [[ -f "$FILE" ]] && \
        [[ ${FILE: -${EXT_LENGTH}} == ".$EXT" ]] && \
        echo "$FILE"
    done
}

str_remove_prefix()
{
    PREFIX=$1 && shift

    for string in "$@"
    do
        result=${string#"$PREFIX"}
        [[ "$string" != "$result" ]] && echo "$result"
    done
}
