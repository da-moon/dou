#!/usr/bin/env bash

# [ NOTE ] => Run the script in the directory of your `main.tf` file to generate resource commit messages
scope="$(basename $(pwd))";
rm -f resource-commits.txt;
while read line;do
(
  echo "git commit -m 'feat(${scope}): $line implementation.'" ;
  echo "git commit -m 'docs(${scope}): ${line} synopsis.'";
  echo '' ;
) | tee -a resource-commits.txt > /dev/null ;
done < <(grep -Eh 'resource\s+"' *.tf* | sed -e 's/"\s"/./g' -e 's/"/`/g' -e 's/\s*{\s*$//g')
# ────────────────────────────────────────────────────────────
rm -f data-commits.txt;
while read line;do
(
  echo "git commit -m 'feat(${scope}): $line implementation.'" ;
  echo "git commit -m 'docs(${scope}): ${line} synopsis.'";
  echo '' ;
) | tee -a data-commits.txt > /dev/null ;
done < <(grep -Eh 'data\s+"' *.tf* | sed -e 's/"\s"/./g' -e 's/"/`/g' -e 's/\s*{\s*$//g')
