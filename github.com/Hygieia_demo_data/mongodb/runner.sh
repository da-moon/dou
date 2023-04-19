source ../data.conf

mongo 127.0.0.1/demo_db --eval 'db.feature_branch.remove({})'

mongo 127.0.0.1/demo_db --eval 'db.builds.remove({number: { $nin: ["1","2","3"]}})'


mongo 127.0.0.1/demo_db --eval 'db.feature_branch.insert({"name" : "Feature A",
	"_class" : "com.capitalone.dashboard.model.FeatureBranch", 
	"firstCommitTimeStamp" : NumberLong('"$build_time_stamp_feature_a"000') , 
	"deployTimeStamp" : NumberLong('"$deploy_time_stamp_feature_a"000') ,
	"commitIdFirstCommit" : "'"$feature_a_id"'", 
	"gitRepoUrl" : "https://github.com/jasmeetkohli/dummyRepo"
})'


mongo 127.0.0.1/demo_db --eval 'db.feature_branch.insert({"name" : "Feature B",
	"_class" : "com.capitalone.dashboard.model.FeatureBranch", 
	"firstCommitTimeStamp" : NumberLong('"$build_time_stamp_feature_b"000') , 
	"deployTimeStamp" : NumberLong('"$deploy_time_stamp_feature_b"000') ,
	"commitIdFirstCommit" : "'"$feature_b_id"'", 
	"gitRepoUrl" : "https://github.com/jasmeetkohli/dummyRepo"
})'

mongo 127.0.0.1/demo_db --eval 'db.feature_branch.insert({"name" : "Feature C",
	"_class" : "com.capitalone.dashboard.model.FeatureBranch", 
	"firstCommitTimeStamp" : NumberLong('"$build_time_stamp_feature_c"000') , 
	"deployTimeStamp" : NumberLong('"$deploy_time_stamp_feature_c"000') ,
	"commitIdFirstCommit" : "'"$feature_c_id"'", 
	"gitRepoUrl" : "https://github.com/jasmeetkohli/dummyRepo"
})'
