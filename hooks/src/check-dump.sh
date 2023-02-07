#!/bin/bash

found=0

for FILE in $*
do
    EXT="${FILE##*.}"

    if [[ "$EXT" != "php" ]]
    then
        continue
    fi

    if test $(git diff --cached HEAD ${FILE} | grep "\+\s.*dump[(]" | wc -l) != 0
    then
      echo "----------------------------------------------------------------------"
      echo -e "\e[1;37mFILE: $FILE\e[0m"
      echo "----------------------------------------------------------------------"
      git diff --cached HEAD ${FILE} | grep --color=auto -C 2 -ne "\+\s.*dump[(]"
      echo ""
      found=$((found+1))
    fi
done

if [[ ${found} -ne 0 ]]
then
    echo "######################################################################"
    echo -e "\n\t\e[31mERROR: dump() calls found.\e[0m\n"
    exit 1
fi

echo -e " \e[42;30m[DONE]\e[0m \e[1;30mNo dump() found\e[0m"
