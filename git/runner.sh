

source ../data.conf

make_changes() {

    echo "-----------------"
    feature_time_stamp=$1
    feature_id=$2
    echo $feature_time_stamp
    echo "Changing timestamp for id : $feature_id"
    echo $(git filter-branch -f --env-filter \
        'if [ $GIT_COMMIT = '"$feature_id"' ]
         then
             export GIT_AUTHOR_DATE="'"$feature_time_stamp"'"
             export GIT_COMMITTER_DATE="'"$feature_time_stamp"'"
         fi')
}


feature_a_time=$(date -r $build_time_stamp_feature_a -R)
feature_b_time=$(date -r $build_time_stamp_feature_b -R)
feature_c_time=$(date -r $build_time_stamp_feature_c -R)

rm -R -f Temp_Repo
echo $(git clone https://github.com/jasmeetkohli/Temp_Repo.git)

cd Temp_Repo

make_changes "$feature_c_time" "$feature_c_id"
echo $(git push -f)
make_changes "$feature_b_time" "$feature_b_id"
echo $(git push -f)
make_changes "$feature_a_time" "$feature_a_id"
echo $(git push -f)


