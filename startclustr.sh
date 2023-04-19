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

#Creating new cluster
kubeadm init --token=y2bcde.zv1gcyg9wn2ov12o
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

#Installing feature for CNI
kubectl apply -f https://git.io/weave-kube-1.6

#Creating namespace
kubectl create namespace devops

#To schedule pods on the master
kubectl taint nodes --all node-role.kubernetes.io/master-

#Adding services
cd services/
bash addservices.sh
#Adding Pods
cd ../pods/
bash addpods.sh

echo "Run kubectl get svc,pods -n devops to see the containers"
