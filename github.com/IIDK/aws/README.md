# Vagrant AWS Provider Setup

In this directory run
```bash
vagrant plugin install vagrant-aws
vagrant box add aws-dummy dummy.box
ssh-keygen -t rsa -b 4096 -m pem  -f ./vagrant.key -C "vagrant" -N ""
```

go into ./terraform/main.tf and and update the user local variable. Replace tmobbs with a name to mark the ec2 instances as your own.update the allow_sources to include your IP.
cd to the terraform dir and deploy the terraform vpc. (You'll need valid AWS keys in your environment vars)
```bash

pushd terraform 
terraform apply
popd 
```

# Install the amazon.aws collection from ansible galaxy
ansible-galaxy collection install amazon.aws

go into ./ubuntu/Vagrantfile and search and replace all instance of tmobbs with whatever you changed local.user to. update the subnets and sg groups.

switch to the ubuntu subdir and deploy your ec2 instance with vagrant
```bash
cd ubuntu
vagrant up
```
ssh into your ec2 instance
```bash
vagrant ssh
```

destroy your ec2 instance 
```bash
vagrant destroy
```
