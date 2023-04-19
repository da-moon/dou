#!/bin/sh

sudo apt update -y
sudo apt install xfsprogs -y
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /data
sudo mount /dev/nvme1n1 /data

BLK_ID=$(sudo blkid /dev/nvme1n1 | cut -f2 -d" ")

if [[ -z $BLK_ID ]]; then
  echo "Hmm ... no block ID found ... "
  exit 1
fi

echo "$BLK_ID     /data   xfs    defaults   0   2" | sudo tee --append /etc/fstab

sudo mount -a

echo "Bootstrapping Complete!"

