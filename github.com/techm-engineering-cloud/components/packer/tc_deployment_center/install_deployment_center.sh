#!/bin/sh

#----------------------------------------------------------------------------------------
# This script always installs DeploymentCenter as the first step. Then it mounts 
# the persistence EFS volume to a temporary directory to check if it has data, and 
# delete it in case of a force reinstall. Finally, it overwrites the recently installed
# folder /usr/Siemens/DeploymentCenter/webserver with the EFS mounted volume to maintain
# persistent state.
# This sequence was favored instead of just installing everything in EFS since the
# beginning, because populating the repository during the install process takes hours,
# compared to one minute at most when doing it in EC2 instance storage instead.
# Folder structure at the end:
# - /software -> EBS volume for software repository, baked into the image
# - /usr/Siemens/DeploymentCenter/repository -> EC2 instance store, baked into the image
# - /usr/Siemens/DeploymentCenter/webserver -> EFS, persisted across rebakes
#----------------------------------------------------------------------------------------

set -e

DC_ROOT=/usr/Siemens/DeploymentCenter
SOFTWARE_PATH=/usr/Siemens/DeploymentCenter/downloads

install_deployment_center() {
    whoami
    sudo mkdir -p $DC_ROOT
    sudo chown -R tc:tc $DC_ROOT
    sudo mkdir -p $SOFTWARE_PATH
    sudo chown -R tc:tc $SOFTWARE_PATH

    sudo cp -R /software/${DC_FOLDER_TO_INSTALL}/* $SOFTWARE_PATH
    sudo chown -R tc:tc $SOFTWARE_PATH

    # Install DeploymentCenter
    ls -lsa $SOFTWARE_PATH/
    cd $SOFTWARE_PATH/deployment_center
    ls -lsa
    # Encrypt password
    echo "Encrypting password"
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export JRE64_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    echo "JAVA_HOME: $JAVA_HOME"
    echo "JRE64_HOME: $JRE64_HOME"
    ENCRYPTED_PASS=$(./dc_encrypt.sh -password="${DC_ADMIN_PASS}")
    sed "s|\${dc_admin_user}|${DC_ADMIN_USER}|; s|\${dc_admin_pass}|${ENCRYPTED_PASS}|" /tmp/install_config.properties > $SOFTWARE_PATH/deployment_center/install_config.properties
    echo "Installing DeploymentCenter"
    ./deployment_center.sh -install -inputFile=install_config.properties
    cd $DC_ROOT/webserver/rootscripts
    sudo ./root_servicessetup.sh

    # Set hostname to "localhost" in properties files
    echo "Updating hostname in properties files"
    cd $DC_ROOT/webserver
    sed "s|DC_HOST_NAME=.*|DC_HOST_NAME=localhost|" dcserver.properties > dcserver.properties.new
    mv dcserver.properties.new dcserver.properties
    cd repotool
    sed "s|hostName=.*|hostName=localhost|" repository.properties > repository.properties.new
    mv repository.properties.new repository.properties

    sudo chown -R tc:tc "$DC_ROOT"

}

mount_efs() {
    DEST=$1
    PERSIST=$2
    echo "Mounting EFS to $DEST, persist: $PERSIST"
    sudo mkdir -p "$DEST"
    if [ "$PERSIST" != "true" ] ; then
        sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${EFS_ID}".efs."${REGION}".amazonaws.com:/ "$DEST"
    else
        sudo echo "${EFS_ID}.efs.${REGION}.amazonaws.com:/ $DEST nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" | sudo tee --append /etc/fstab
        sudo mount -a
    fi
    sudo chown tc:tc "$DEST"
}

update_deployment_center() {
    USER=$(grep "^user" $SOFTWARE_PATH/deployment_center/install_config.properties | sed 's|user=||')
    PASS=$(grep "^password" $SOFTWARE_PATH/deployment_center/install_config.properties | sed 's|password=||')
    cd $SOFTWARE_PATH/deployment_center
    sudo systemctl stop dcserver
    sudo systemctl stop repotool
    sudo systemctl stop publisher
    ./deployment_center.sh -maintenance -serverDir=$DC_ROOT/webserver -user="${USER}" -password="${PASS}" -addSoftwareDir=/software -useEncryptedPassword=true
    sleep 90 # Wait a bit for the repotool to pick and process the files
}

generate_pass_file(){

    # generate password file
    cd $SOFTWARE_PATH/deployment_center/
    ./dc_encrypt.sh \
        -password="${DC_ADMIN_PASS}" \
        -file=dcadmin.pwf
}

install_sync_deployment_scripts_cron() {

    FREQ="* * * * *" #frequency every minute
    USER="tc"
    GROUP="tc"
    LOG_FILE="/var/log/sync_deployment_scripts.log"
    SCRIPT_PATH="/usr/local/bin"
    SCRIPT_NAME="sync_deployment_scripts.sh"

    sudo mv /tmp/"$SCRIPT_NAME" "$SCRIPT_PATH"
    sudo chmod +x "${SCRIPT_PATH}/${SCRIPT_NAME}"
    sudo touch "$LOG_FILE"
    sudo chown "$USER":"$GROUP" "$LOG_FILE"

    cronline="${FREQ} ${USER} ${SCRIPT_PATH}/${SCRIPT_NAME} ${ARTIFACTS_BUCKET}"
    echo "#s3_sync_deployment_scripts" > /tmp/sync_deployment_scripts
    echo "$cronline" >> /tmp/sync_deployment_scripts

    sudo mv /tmp/sync_deployment_scripts /etc/cron.d/
    sudo chown root:root /etc/cron.d/sync_deployment_scripts
    sudo chmod 600 /etc/cron.d/sync_deployment_scripts
}

install () {
    echo "Installing DeploymentCenter"
    install_deployment_center
    df -h

    sudo systemctl stop dcserver
    sudo systemctl stop repotool
    sudo systemctl stop publisher

    mount_efs "/tmp/db" "false"
    echo "Files in EFS:"
    ls -l /tmp/db

    if [ ! "$(ls -A /tmp/db)" ] || [ "$DELETE_DATA" = "true" ] ; then
        echo "EFS empty or DELETE_DATA is true, deleting data in EFS and copying recently created data from $DC_ROOT/webserver/db"
        sudo rm -rf /tmp/db/*
        cp -R $DC_ROOT/webserver/db/* /tmp/db/
    fi

    sudo umount /tmp/db
    sudo rm -rf $DC_ROOT/webserver/db/*
    mount_efs "$DC_ROOT/webserver/db" "true"
    df -h

    sudo hostnamectl set-hostname "${MACHINE_NAME}"
    echo "Hostname: $HOSTNAME"

    update_deployment_center
    install_sync_deployment_scripts_cron
    generate_pass_file
}

sudo mv /tmp/generate_deployment_scripts.py /home/tc
sudo chmod +x /home/tc/generate_deployment_scripts.py
sudo chown tc:tc /home/tc/generate_deployment_scripts.py
install

