#!/bin/bash

set -e
SCRIPT_NAME="$(basename "$0")"

print_usage() {
  echo
  echo "Usage: $SCRIPT_NAME [OPTIONS]"
  echo
  echo "This script installs teamcenter in the current server."
  echo
  echo "Options:"
  echo
  echo -e "  --latest      \t\tIndicates that the latest installation scripts from the CI/CD S3 bucket should be used."
  echo -e "  --scripts-path\t\tFull S3 bucket path were installation scripts are located."
  echo -e "  --ignore-failures\t\tIgnore errors running the teamcenter deployment script."
  echo
  echo "Example:"
  echo
  echo "  $SCRIPT_NAME --latest"
  echo "  $SCRIPT_NAME --scripts-path my-bucket/deployment_scripts/env1/install/20220810155354UTC"
  echo ""
}

parse_args() {
  SCRIPTS_PATH=""
  IGNORE_FAILURES=0

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --scripts-path)
        SCRIPTS_PATH="$2"
        shift
        ;;
      --latest)
        SCRIPTS_PATH=$(aws s3 cp s3://${BUCKET}/stage_outputs/03_generate_install_scripts/${ENV_NAME}/outputs.json - | jq -r '.scripts_s3_path')
        ;;
      --ignore-failures)
        IGNORE_FAILURES=1
        ;;
      *)
        echo "Unrecognized argument: $key"
        print_usage
        exit 1
        ;;
    esac
    shift
  done

  if [ "$SCRIPTS_PATH" = "" ] ; then
      print_usage
      exit 1
  fi
}

prepare_dirs() {
    sudo mkdir -p /usr/Siemens/Teamcenter13/teamcenter_root
    sudo chown tc:tc /usr/Siemens
    sudo chown tc:tc /usr/Siemens/Teamcenter13
    sudo chown tc:tc /usr/Siemens/Teamcenter13/teamcenter_root
}

download_scripts() {
    MACHINE_NAME=$(echo $HOSTNAME)
    if [ "$SCRIPTS_PATH" = "" ] ; then
        echo "Missing SCRIPTS_PATH env var"
        exit 1
    fi
    mkdir -p "$HOME/install"
    cd "$HOME/install"
    rm -rf "$HOME/install/*"
    if aws s3 ls "s3://$SCRIPTS_PATH/deploy_$MACHINE_NAME.zip" ; then
        SCRIPTS_PATH="s3://$SCRIPTS_PATH/deploy_$MACHINE_NAME.zip"
        echo "Downloading installation scripts from $SCRIPTS_PATH"
    else
        PARENT=$(dirname "s3://$SCRIPTS_PATH")
        LATEST_SCRIPT=$(aws s3 ls "$PARENT" --recursive \
            | grep "deploy_$MACHINE_NAME.zip" \
            | tail -n1 \
            | awk '{print $4}') 
        LATEST_SCRIPT_DIR=$(basename $( dirname $LATEST_SCRIPT))
        SCRIPTS_PATH="$PARENT/$LATEST_SCRIPT_DIR/deploy_$MACHINE_NAME.zip"
        echo "Downloading installation scripts from $SCRIPTS_PATH"
    fi
    
    aws s3 cp "$SCRIPTS_PATH" .
    unzip -qq -o deploy_$MACHINE_NAME.zip
}

upload_logs_to_s3() {
    S3_PATH="s3://${BUCKET}/stage_outputs/env-${ENV_NAME}/${STAGE_NAME}/failed_bake_logs/$(date +%F_%H_%M_%S)"
    aws s3 sync "$HOME/install/logs" "$S3_PATH"
}

tail_log() {
    set +e
    cd "$HOME/install"
    mkdir -p logs
    echo "--> Waiting for log file to be available"
    while [ "$LOG" = "" ] || [ ! -f "$HOME/install/logs/$LOG" ] ; do
        LOG=$(ls -lrt logs/ | grep "deployer" | grep -v "diagnostics" | grep -v "debug" | grep -v "scanner" | awk '{print $9}' | tail -1)
        echo "--> Log: $LOG"
        sleep 2
    done
    echo "--> Tailing log $LOG"
    tail -f "$HOME/install/logs/$LOG"
}

boot_fsc() {
    echo ">> Configuring FSC auto start on boot"
    SANITIZED_MACHINE_NAME=$(echo "$HOSTNAME" | sed 's|[-_]||g')
    F=""
    for f in $(ls /usr/Siemens/Teamcenter13/teamcenter_root/fsc/bin/su_FSC*) ; do
        candidate=$(basename $f | sed 's|su_FSC_||' | sed 's|_tc||')
        if echo "$candidate" | grep "$SANITIZED_MACHINE_NAME" || echo "$SANITIZED_MACHINE_NAME" | grep "$candidate" ; then
            echo "File $f matches $SANITIZED_MACHINE_NAME, using it for booting FSC"
            F=$f
        else
            echo "File $f doesn't match $SANITIZED_MACHINE_NAME, skipping"
        fi
    done
    if [ -f "$F" ] ; then
        echo ">> Copying $F"
        sudo cp "$F" "/etc/init.d/$(basename $F)"
        sudo chmod +x "/etc/init.d/$(basename $F)"
        sudo /sbin/chkconfig $(basename $F) on
        sudo systemctl enable $(basename $F)
        sudo systemctl start $(basename $F)
    else
        echo ">> File $F not found, FSC will not start on boot"
    fi
}

boot_pool_mgr() {
    echo ">> Configuring pool manager auto start on boot"
    F="/var/tmp/server.mgr_config1_PoolA.service"
    if [ -f "$F" ] ; then
        echo ">> Enabling pool manager autostart with $F"
        sudo cp "$F" "/etc/systemd/system"
        sudo chmod +x "/etc/systemd/system/server.mgr_config1_PoolA.service"
        sudo systemctl enable server.mgr_config1_PoolA.service
        sudo systemctl start server.mgr_config1_PoolA.service
        sleep 30
    else
        echo ">> File $F not found, pool manager will not start on boot"
    fi
}

run_scripts() {
    cd "$HOME/install"
    echo "Retrieving Deployment Center credentials from AWS Secrets Manager"
    DC_USER=$(aws secretsmanager get-secret-value --secret-id=${DC_USER_SECRET_NAME} | jq -r '.SecretString')
    DC_PASS=$(aws secretsmanager get-secret-value --secret-id=${DC_PASS_SECRET_NAME} | jq -r '.SecretString')
    set +e
    rm -f "$HOME/install/logs/*"
    tail_log &
    ./deploy.sh \
        -dcusername="$DC_USER" \
        -dcpassword="$DC_PASS" \
        -dcUrl="http://${DC_URL}/deploymentcenter/" \
        -softwareLocation=/software \
        -ignoreDiagnostics
    SC=$?
    LOG=$(ls -lrt logs/ | grep "deployer" | grep -v "diagnostics" | grep -v "debug" | grep -v "scanner" | awk '{print $9}' | tail -1)
    echo "====> Deploy command exit status: $SC"
    set -e
    if [ "$SC" != 0 ] ; then
        echo "Installation was not successful, uploading logs to S3"
        upload_logs_to_s3
        if [ "$IGNORE_FAILURES" = 0 ] ; then
            exit 1
        fi
    fi

    if [ "${START_FSC}" = "true" ] ; then
        boot_fsc
    else
        echo ">> Not starting FSC on boot"
    fi

    if [ "${START_POOL_MGR}" = "true" ] ; then
        boot_pool_mgr
    else
        echo ">> Not starting pool manager on boot"
    fi
}

run_post_install() {
    if [ -f "$HOME/tc_post_install.sh" ] ; then
        echo ">>> Running post installation script"
        "$HOME/tc_post_install.sh"
    fi
}

ORIGINAL_ARGS="$@"
parse_args "$@"
prepare_dirs
download_scripts
run_scripts
run_post_install
exit 0

