#!/bin/bash

found=0

for FILE in $*
do
    if test $(git diff --cached HEAD ${FILE} | egrep "[><]{7}" | wc -l) != 0
    then
      echo "----------------------------------------------------------------------"
      echo -e "\e[1;37mFILE: $FILE\e[0m"
      echo "----------------------------------------------------------------------"
      git diff --cached HEAD ${FILE} | egrep --color=auto -n -C 2 '[><]{7}'
      echo ""
      found=$((found+1))
    fi
done

if [[ ${found} -ne 0 ]]
then
    echo "######################################################################"
    echo -e "\n\t\e[31mERROR: Merging tags found.\e[0m\n"
    exit 1
fi

echo -e " \e[42;30m[DONE]\e[0m \e[1;30mNo merging tags found\e[0m"
