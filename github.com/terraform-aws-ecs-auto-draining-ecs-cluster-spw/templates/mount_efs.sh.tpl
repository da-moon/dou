#cloud-boothook

## install EFS requirements
sudo yum install -y nfs-utils

### Create /efs dir for mounting EFS share
sudo mkdir /efs

### Add EFS share to /etc/fstab
echo "${efs_address}:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab

### Mount EFS Share
sudo mount -a