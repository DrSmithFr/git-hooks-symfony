#!/bin/bash

echo "Affected files:"
for FILE in $*
do
    echo -e "  - $FILE"
done

echo ""

./hooks/bin/ask.sh ask_simple \
    "Have you double checked that only relevant files were added?" \
    "Please ensure the right files were added!"

exit $?

"$@"
