echo "##[command]go test -v"
go test -v -timeout $TERRATEST_TIMEOUT | tee test_output.log

echo "##[command]terratest_log_parser -testlog test_output.log -outputdir test_output"
terratest_log_parser -testlog test_output.log -outputdir test_output