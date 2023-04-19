#!/bin/bash +x

file=`find . -name "terratest-setup.tf"`

if [ -z "$file" ]; then
    file="main.tf"
fi

CURRENT_PATH="\.\."

echo "####[debug] Updated source of the module"
sed -i -e "s|$CURRENT_PATH|$whereIam|" $file
echo "###[command] head -25 $file"
head -25 $file