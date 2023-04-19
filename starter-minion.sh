#!/bin/bash
#Updating packages and adding new repository
apt-get update && apt-get install -y apt-transport-https=1.2.19
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

#Installing kubernetes and docker engine
apt-get install -y docker-engine=1.11.2-0~xenial
apt-get install -y kubelet=1.6.1-00 kubeadm=1.6.1-00 kubectl=1.6.1-00 kubernetes-cni=0.5.1-00
apt-get install -y nfs-common
