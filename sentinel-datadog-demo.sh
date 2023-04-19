#!/bin/bash

. ./sentinel-datadog-func.sh

function generate_demo_data {
    local -r substract_minutes=$1
    local -r num_records=$2
    local -r workspace=$3
    local -r num_sentinel_rules="10"
    local -r sleep_time="5"

    log_info "creating demo data..."
    for i in $(seq 1 "$num_records"); do
        log_info "creating demo record #${i}..."
        passed=$(rand_num "$num_sentinel_rules")
        failed=$((num_sentinel_rules - passed))
        hard_failed=$(rand_num "$failed") 
        soft_failed=$(rand_num "$((failed - hard_failed))") 
        advisory_failed=$(rand_num "$((failed - hard_failed - soft_failed))") 
        timestamp="$(date -D "-${substract_minutes}M" +%s)"
        id="run-$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 16 ; echo '')"

        send_datadog_metrics "$workspace" "$id" "$timestamp" "$passed" "$failed" "$hard_failed" "$soft_failed" "$advisory_failed"

        log_info "demo record #$i created."

        sleep $sleep_time
    done
    
}

function main {
    generate_demo_data "15" "10" "sentinel-datadog-demodata"
}

main