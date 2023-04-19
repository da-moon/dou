#!/bin/bash

if [ -z "${TERRATEST_TIMEOUT}" ]; then
    TERRATEST_TIMEOUT="120m"
else
    TERRATEST_TIMEOUT="${TERRATEST_TIMEOUT}m"
fi

# echo "##[debug] Download go packages"
# go mod tidy

echo "##[command]go test -v"
/usr/local/go/bin/go test -v -timeout $TERRATEST_TIMEOUT | tee test_output.log

echo "##[command]terratest_log_parser -testlog test_output.log -outputdir test_output"
terratest_log_parser -testlog test_output.log -outputdir test_output

TEST_FAIL=$(cat test_output/summary.log | grep -w "FAIL")

if [ -n "$TEST_FAIL" ]; then
    exit 1
else
    exit 0
fi
