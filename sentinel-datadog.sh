#!/bin/bash

. ./sentinel-datadog-func.sh

function jq_get {
    local -r jq_json="$1"
    local -r key="$2"
    echo "$jq_json" | jq -r ".[\"${key}\"]" 
}

function main {
    local -r workspace="sentinel-datadog-gmlp"
    timestamp="$(date +%s)"
    tfe_run_id="$(get_run_id)"
    policies_json=$(get_policy_check)

    metrics=$(get_metrics "${policies_json}")
    passed=$(jq_get "$metrics" "passed")
    failed=$(jq_get "$metrics" "total-failed")
    hard_failed=$(jq_get "$metrics" "hard-failed")
    soft_failed=$(jq_get "$metrics" "soft-failed")
    advisory_failed=$(jq_get "$metrics" "advisory-failed")

    send_datadog_metrics "$workspace" "$tfe_run_id" "$timestamp" "$passed" "$failed" "$hard_failed" "$soft_failed" "$advisory_failed"
}

main