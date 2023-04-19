set -e

# echo "##[debug] Reading workload.config file and exporting ENV variables"
# echo "##[debug] Declared variables are:"
array=($(awk -F '=' '{ print $1 }' workload.config))
array2=($(awk -F '=' '{ print $2 }' workload.config))
i=0
while [ $i -lt ${#array[*]} ]; do
    if [ "${array[$i]}" == "$1" ]; then
        set ${array[$i]}=${array2[$i]}
        export ${array[$i]}=${array2[$i]}
        echo ${array2[$i]}
    fi

    i=$(( $i + 1));
done

# echo "##[endgroup]"