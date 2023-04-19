#!/bin/sh

#------------------------------------------------------------------------------------------------
# Find which folders inside "environments" folder include the provided software name
# The software name is provided in a json document from terraform
#------------------------------------------------------------------------------------------------

set -e 

eval "$(jq -r '@sh "export SOFTWARE=\(.software)"')"

OWN_DIR="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

ENVS=""
for x in $(find "$OWN_DIR/../../environments/$SOFTWARE" -type d | sed "s|.*environments/$SOFTWARE||") ; do
    ENVS="$ENVS$(basename $x),"
done

# Cut the last comma
ENVS=$(echo $ENVS | sed 's/.$//')

# Output in a format that terraform can use with the data external source
echo "{\"envs\": \"$ENVS\"}"

