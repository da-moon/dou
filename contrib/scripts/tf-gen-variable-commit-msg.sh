#!/usr/bin/env bash

# [ NOTE ] => Run the script in the directory of your `variables.tf` file to generate variable commit messages
scope="$(basename $(pwd))";
rm -f variable-commits.txt;
while read line; do
(
  echo "git commit -m 'feat(${scope}): $line declaration.'" ;
  echo "git commit -m 'docs(${scope}): ${line} synopsis.'";
  echo '' ;
) | tee -a variable-commits.txt > /dev/null ;
done < <(grep -Eh 'variable\s+"' *.tf*  | sed -e 's/ {//g' -e 's/"/`/g' )
