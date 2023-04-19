#!/bin/sh

set -ex 

install_tools() {
    sudo yum -y install unzip ksh nc bind-utils libaio jq wget xfsprogs
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -qq -o awscliv2.zip
    sudo ./aws/install
}

mount_ebs() {
    echo "Preparing to mount EBS volume for software repo. Current devices:"
    sudo lsblk
    sudo df -h
    sudo mkfs -t xfs /dev/nvme1n1
    sudo mkdir $1
    sudo mount /dev/nvme1n1 $1
    echo "After formatting and mounting volume. Current devices:"
    sudo lsblk
    sudo df -h
    sudo ls -la $1
}

download_extract() {
    DIR=$(echo "$1" | sed 's|.zip||; s|.*/||')
    sudo mkdir -p "${MOUNT_PATH}/$DIR"
    sudo /usr/local/bin/aws s3 cp "$1" "${MOUNT_PATH}/${DIR}.zip"
    set +e
    sudo unzip -qq -o "${MOUNT_PATH}/${DIR}.zip" -d "${MOUNT_PATH}/$DIR"
    set -e
    sudo rm -f "${MOUNT_PATH}/${DIR}.zip"
}

copy_s3_files() {
    cd $1
    if [[ ${SOURCE_S3_URI} != */ ]] ; then
        SOURCE_S3_URI=${SOURCE_S3_URI}/
    fi
    for f in $(/usr/local/bin/aws s3 ls ${SOURCE_S3_URI} | awk '{print $4}' | grep ".zip") ; do 
        download_extract ${SOURCE_S3_URI}$f
    done
    sudo find ${MOUNT_PATH} -type d -exec chmod 755 {} \; # Allow non root users to list files in all dirs with +x permission on dirs
    sudo find ${MOUNT_PATH} -type f -exec chmod +wr {} \;
}

MOUNT_PATH="/software"
install_tools
mount_ebs ${MOUNT_PATH}
copy_s3_files ${MOUNT_PATH}

