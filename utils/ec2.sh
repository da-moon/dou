#!/bin/bash

######d##########################################################################
#
# This script helps you to stop/start instances 
# Mantainers:
#
# - Gonzalo Lopez <gonzalo.lopez@techmahindra.com>
#
# Lint: Shellcheck
#
################################################################################

readonly BOOTSTRAP_FILE="../environments/bootstrap.tfvars"
SCRIPT_NAME="$(basename "$0")"

function print_usage {
  echo
  echo "Usage: $SCRIPT_NAME [OPTIONS]"
  echo
  echo "This script can be used to stop start resources created by EIC IAC code."
  echo
  echo "Options:"
  echo
  echo -e "  --start\t\t\tstart ec2 instances.Required if --stop not defined."
  echo -e "  --stop\t\t\tstop ec2 instances.Required if --start not defined."
  echo -e "  --bootstrap-var-file\t\tBootstrap var file used to install EIC Code. Optional. Default: $BOOTSTRAP_FILE."
  echo -e "  --prefix\t\t\tprefix used to install EIC resources. Optional."
  echo -e "  --region\t\t\tAWS region. Optional."
  echo
  echo "Example:"
  echo
  echo "  $SCRIPT_NAME --start "
  echo "  $SCRIPT_NAME --bootstrap-var-file ../environments/bootstrap --stop"
  echo "  $SCRIPT_NAME --region us-east-1 --prefix myprefix --start"
}

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

function scale_asgs {
  local pattern="$1"
  local region="$2"
  local count="$3"
  local asgs=""
  local name=""

  asgs=$(aws autoscaling describe-auto-scaling-groups \
      --region "$region" \
      --output json \
      --query 'AutoScalingGroups[*]' )

  jq -c '.[]' <<< "$asgs" | while read -r asg; do
      name=$(jq -r '.AutoScalingGroupName' <<< "$asg")
      if [[ "$name" == *"$pattern"* ]] ; then
          log_info "updating $name asg..."
          aws autoscaling update-auto-scaling-group \
            --region "$region" \
            --auto-scaling-group-name "$name" \
            --min-size "$count" \
            --max-size "$count" \
            --desired-capacity "$count" 
      fi
  done
}

function start_instances {
  local pattern="$1"
  local region="$2"

  log_info "starting instances..."
  scale_asgs "$pattern" "$region" "1"
}

function stop_instances {
  log_info "stoping instances..."
  scale_asgs "$pattern" "$region" "0"
}


function assert_not_empty {
  local -r arg_name="$1"
  local -r arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    log_error "The value for '$arg_name' cannot be empty"
    print_usage
    exit 1
  fi
}

function assert_either_or {
  local -r arg1_name="$1"
  local -r arg1_value="$2"
  local -r arg2_name="$3"
  local -r arg2_value="$4"

  if [[ -z "$arg1_value" && -z "$arg2_value" ]]; then
    log_error "Either the value for '$arg1_name' or '$arg2_name' must be passed, both cannot be empty"
    print_usage
    exit 1
  fi
}

function start {
  local bootstrap_file="$BOOTSTRAP_FILE"
  local prefix=""
  local region=""
  local pattern=""
  local start=""
  local stop=""

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --bootstrap-var-file)
        bootstrap_file="$2"
        shift
        ;;
      --region)
        region="$2"
        shift
        ;;
      --prefix)
        prefix="$2"
        shift
        ;;
      --start)
        start="true"
        shift
        ;;
      --stop)
        stop="true"
        shift
        ;;
      --help)
        print_usage
        exit
        ;;
      *)
        log_error "Unrecognized argument: $key"
        print_usage
        exit 1
        ;;
    esac

    shift
  done

  if [[ -z $prefix && -z $region  ]]; then
    region=$(grep "bootstrap_region" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
    prefix=$(grep "installation_prefix" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
    log_info "bootstrap file: $bootstrap_file "
    assert_not_empty "bootstrap_region" "$region"
  else
    assert_not_empty "--region" "$region"
  fi

  if [[ -n "$prefix" ]] ; then
      pattern="${prefix}-tc-"

  else
      pattern="tc-"
  fi

  assert_either_or "--stop" "$stop" "--start" "$start"

  log_info "region: $region "
  log_info "pattern: $pattern "

  if [[ "$start" == "true" ]] ; then
    start_instances "$pattern" "$region"
  else
    stop_instances "$pattern" "$region"
  fi
}
start "$@"