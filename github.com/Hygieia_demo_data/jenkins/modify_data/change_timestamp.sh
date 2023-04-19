
source ../../data.conf

make_changes() {
	build_file=$build_file_path/$1"/build.xml"
	test_file=$test_file_path/$1"/build.xml"
	deploy_file=$deploy_file_path/$1"/build.xml"

	echo "Changing timestamp for $1 : $2000"
	ssh -i $key_file $user@$host -t "sudo sed -i \"/\<timestamp\>/c\\<timestamp\>$2000\<\/timestamp>\" $build_file"
	ssh -i $key_file $user@$host -t "sudo sed -i \"/\<timestamp\>/c\\<timestamp\>$3000\<\/timestamp>\" $test_file"
	ssh -i $key_file $user@$host -t "sudo sed -i \"/\<timestamp\>/c\\<timestamp\>$4000\<\/timestamp>\" $deploy_file"	
}

delete_files(){
	ssh -i $key_file $user@$host -t "sudo rm -f -R $3/$1"
	ssh -i $key_file $user@$host -t "sudo rm -f -R $3/$2"		
}


make_changes 1 $build_time_stamp_feature_a $test_time_stamp_feature_a $deploy_time_stamp_feature_a
make_changes 2 $build_time_stamp_feature_b $test_time_stamp_feature_b $deploy_time_stamp_feature_b
make_changes 3 $build_time_stamp_feature_c $test_time_stamp_feature_c $deploy_time_stamp_feature_c


p1="*[4-9]*"
p2="[1-3][0-9]*"

echo "deleting unrequired builds"

delete_files $p1 $p2 $build_file_path
delete_files $p1 $p2 $test_file_path
delete_files $p1 $p2 $deploy_file_path

ssh -i dg_aws.pem $user@$host -t "sudo service jenkins restart"
