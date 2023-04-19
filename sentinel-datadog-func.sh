#!/bin/bash

readonly PLAN_LOG_FILE="./plan.log"
readonly TFE_API="https://app.terraform.io/api/v2"
SCRIPT_NAME=$(basename "$0")


function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$1"
  log "INFO" "$message"
}

function log_warn {
  local -r message="$1"
  log "WARN" "$message"
}

function log_error {
  local -r message="$1"
  log "ERROR" "$message"
}

function get_run_id {
  tfe_run_url="$(grep runs/ < ${PLAN_LOG_FILE})"
  echo "${tfe_run_url##*/}"
}

function get_policy_check {
    tfe_run_id="$(get_run_id)"
    log_info "Terraform Cloud Run ID: $tfe_run_id"
    policies="$(curl \
      --header "Authorization: Bearer $TERRAFORM_CLOUD_API_TOKEN" \
      "${TFE_API}/runs/${tfe_run_id}/policy-checks")"

    echo "$policies" | jq -r .
} 

function get_metrics {
    local -r policies_json="$1"
    result=$(echo "$policies_json" | jq -r '.data[].attributes.result' )
    response_struct='
    {
        "passed": .passed,
        "total-failed": .["total-failed"],
        "hard-failed": .["hard-failed"],
        "soft-failed": .["soft-failed"],
        "advisory-failed": .["advisory-failed"]
    }'
    response=$(echo "$result" | jq -r "$response_struct"  )
    echo "$response"
}

function send_metric {
    local -r workspace="$1"
    local -r run_id="$2"
    local -r timestamp="$3"
    local -r metric_name="$4" 
    local -r metric_value="$5"
    # Curl command
    curl -X POST "https://api.datadoghq.com/api/v1/series" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -d @- << EOF
{
  "series": [
    {
      "metric": "tfe.${metric_name}",
      "points": [
        [
          "${timestamp}",
          "${metric_value}"
        ]
      ],
      "tags": [
          "workspace:${workspace}",
          "run_id:${run_id}"
      ],
      "type": "count"
    }
  ]
}
EOF
}

function rand_num {
    local -r range="$1"
    if [[ $range -eq 0 ]]; then
        echo 0
    else 
        echo $((1 + RANDOM % range))
    fi
     
}

function send_datadog_metrics {
    local -r workspace=$1
    local -r run_id=$2
    local -r timestamp=$3
    local -r passed=$4
    local -r failed=$5
    local -r hard_failed=$6
    local -r soft_failed=$7
    local -r advisory_failed=$8

    log_info "$workspace $run_id $timestamp passed $passed"
    log_info "$workspace $run_id $timestamp total_failed $failed"
    log_info "$workspace $run_id $timestamp hard_failed $hard_failed"
    log_info "$workspace $run_id $timestamp soft_failed $soft_failed"
    log_info "$workspace $run_id $timestamp advisory_failed $advisory_failed"

    send_metric "$workspace" "$run_id" "$timestamp" "passed" "$passed"
    send_metric "$workspace" "$run_id" "$timestamp" "total_failed" "$failed"
    send_metric "$workspace" "$run_id" "$timestamp" "hard_failed" "$hard_failed"
    send_metric "$workspace" "$run_id" "$timestamp" "soft_failed" "$soft_failed"
    send_metric "$workspace" "$run_id" "$timestamp" "advisory_failed" "$advisory_failed"

}
