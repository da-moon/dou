#! /bin/bash
echo "Script to install Jenkins and Java 8 into Ubuntu18.04"
echo "Installing Java..."
add-apt-repository ppa:openjdk-r/ppa
apt-get update 
apt install -y openjdk-8-jdk
java -version
echo "Installing Jenkins..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get -y install jenkins
echo "Updating jenkins home variable"
echo 'export JENKINS_HOME="/var/lib/jenkins"' >> /etc/profile

