#!/bin/bash

# read last version
lastVersion=$(git tag | sort -V | tail -1)
# is it empty?
if [ -z "$lastVersion" ]; then
    echo "0.0.1"
else
    # invert the version
    revLastVersion=$(echo $lastVersion | rev)
    # my variables
    arrayVersion=();
    change=false
    IFS='.' read -ra ADDR <<< "$revLastVersion"
    for x in "${ADDR[@]}" 
    do
        # Is it a number? 
        if [[ "$x" =~ ^[0-9]+$ ]]; then
            # only for change one number
            if [ "$change" = false ]; then
                # x <= 9 (any number)
                if [ "$x" -lt 99 ]; then
                    revNum=$(echo $x | rev)
                    new_vs=`expr $revNum + 1`;
                    # invert the number
                    arrayVersion+=.$(echo $new_vs | rev);
                    # change the variable to avoid change another number
                    change=true
                else
                    arrayVersion+=(.0)
                fi
            else
                arrayVersion+=.$x
            fi
        fi
    done
    # invert the version
    rev=$(echo $arrayVersion | rev)
    # final version
    echo "${rev%?}"
fi