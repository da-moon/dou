#!/bin/bash

### Comma separated list of directories to create
dirString="${dirList}"

IFS=', ' read -r -a array <<< "$dirString"

# Create directories, give ownership to 1000:1000
for element in "$${array[@]}"
do
    echo "Creating Directory: $element"
    mkdir -p $element
    echo "Changing ownership to 1000:1000"
    sudo chown -R 1000:1000 $element
done