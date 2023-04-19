#!/bin/bash

################################################################################
# Requiriments:
# This script needs to be in the path to be executed by crontab
#
# This script sync deploy scripts to s3://<artifacts_bucket>/deployment_scripts
# Mantainers:
#
# - Gonzalo Lopez <gonzalo.lopez@techmahindra.com>
#
# Lint: Shellcheck
#
# LOGS: /var/logs/sync_deployment_scripts.log
################################################################################

BUCKET="$1"
BUCKET_PATH="s3://${BUCKET}/deployment_scripts"
SCRIPT_NAME="$(basename "$0")"
DS_PATH="/usr/Siemens/DeploymentCenter/repository/deploy_scripts" #the path can be configured in the file install_config.properties

exec 2>&1 > /var/log/sync_deployment_scripts.log

function log {
    local -r level="$1"
    local -r message="$2"
    local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
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

function finished_generating_files {
    LOWEST_DIR=$(find $DS_PATH -type d | tail -1 | xargs)
    log_info "Lowest dir: $LOWEST_DIR"
    [[ $LOWEST_DIR = $DS_PATH ]] && log_info "No new install folder found" && HAS_FILES=0 && return
    IFS='/'
    read -ra PARTS <<< $LOWEST_DIR
    unset IFS
    if [ ${#PARTS[@]} != 9 ] ; then
        log_info "Other subfolders found in deployment scripts dir, DeploymentCenter hasn't finished generating files"
        HAS_FILES=0
        return
    fi
    log_info "Found new finished install scripts in $LOWEST_DIR"
    HAS_FILES=1
}

sync() {
    log_info "Syncing... PATH=${DS_PATH} BUCKET_PATH=${BUCKET_PATH}"
    finished_generating_files
    log_info "HAS_FILES: $HAS_FILES"
    [[ $HAS_FILES = 0 ]] && echo "No new files to sync" && return
    aws s3 sync "$DS_PATH" "$BUCKET_PATH"
    aws s3 ls "$BUCKET_PATH"
    log_info "Syncing finish..."
    rm -rf "${DS_PATH:?}"/*
    log_info "clean up deploy scripts dir"
}

sync
