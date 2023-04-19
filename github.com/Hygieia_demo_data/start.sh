cd mongodb
echo $(./runner.sh)

cd ../git
echo $(./runner.sh)

cd ../jenkins/modify_data/
echo $(./change_timestamp.sh)