#!/bin/sh

echo "Initiating user_data.sh" 

apt update -y
apt install xfsprogs net-tools unzip jq -y
mkfs -t xfs /dev/nvme1n1
mkdir /data
mount /dev/nvme1n1 /data

BLK_ID=$(sudo blkid /dev/nvme1n1 | cut -f2 -d" ")

if [[ -z $BLK_ID ]]; then
  echo "Hmm ... no block ID found ... "
  exit 1
fi

echo "$BLK_ID     /data   xfs    defaults   0   2" | sudo tee --append /etc/fstab

mount -a

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "eip_allocid: ${eip_allocid}"
aws ec2 associate-address --allocation-id ${eip_allocid} --allow-reassociation --instance-id $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)

echo "user_data.sh complete!"

