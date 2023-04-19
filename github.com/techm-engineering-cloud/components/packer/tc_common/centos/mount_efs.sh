#!/bin/sh

set -ex

DEST=${DEST}
EFS_ID=${EFS_ID}
REGION=${REGION}

echo "Mounting EFS ${EFS_ID} to ${DEST}"
sudo mkdir -p "${DEST}"
sudo chown tc:tc "${DEST}"
sudo echo "${EFS_ID}.efs.${REGION}.amazonaws.com:/ ${DEST} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" | sudo tee --append /etc/fstab
sudo mount -a
df -h

