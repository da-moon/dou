# Description

This repository will allow a developer to quickly test and develop applications using Vagrant and Ansible, and once local development is finished, create amis and/or docker images with Packer. The list of applications can be found in ansible/linux/ubuntu/playbooks.

## Prerequisites

On your macbook:

- `brew install vagrant`
- `brew install virtualbox`
- `brew install ansible`
- `brew install packer`
- Check on your macbook's python/pip installation, they should look similar to this:

  ```
   brianconner@Brians-MacBook-Pro ubuntu $ python --version
   Python 2.7.16
   brianconner@Brians-MacBook-Pro ubuntu $ which python
   /usr/bin/python
   brianconner@Brians-MacBook-Pro ubuntu $ pip --version
   pip 20.2.4 from /Library/Python/2.7/site-packages/pip-20.2.4-py2.7.egg/pip (python 2.7)
   brianconner@Brians-MacBook-Pro ubuntu $ which pip
   /usr/local/bin/pip
   ansible/linux/ubuntu/inventories/vagrant/vagrant.py
  ```

- `pip install paramiko` - this is needed because of ansible/linux/ubuntu/inventories/vagrant/vagrant.py

TODO Make less prereqs, perhaps use ansible_local in the vagrant build so that the user doesn't have to set up<br>
deps they may not know about in all these playbooks - have the roles handle the deps as needed.

## Installation & How to Develop

This repo can be thought of as being in 2 parts, local development and build. We'll use rabbitmq on ubuntu as an example, adjust for your needs.

### Local development

1. Choose an application to work on, as well as your OS, which are currently Ubuntu or Amazon Linux 2(aml2).
2. `cd ansible/linux/ubuntu`
3. Open up the `Vagrantfile` in this folder, and uncomment the service you'd like to<br>
  work on in the `groups = {` section:<br>
  `"rabbitmq" => "192.168.4.45",`
4. `vagrant up`
5. Once it's up, you can get into the machine w/ `vagrant ssh`, and get back to your macbook by typing `exit`.
6. Put `http://192.168.4.45:15672/` into your browser to see RabbitMQ in the UI(the IP and port for your service will be different, consult the app's documentation).<br>
  )
7. Make adjustments to the ansible playbooks as needed to accomplish your JIRA task. You can update your<br>
  running vagrant machine after you make ansible changes with `vagrant up --provision`. Once you're happy with your app, move on to the Build section below.

  ### Cleanup

  1. From your macbook, `terraform destroy`.

  ### Build

  1. Now that your code changes are complete, it's time to use Packer to create an ami, docker image, or both.
  2. `packer build -var release=latest build/server/<your_application>.json`

  ### Cleanup

  1. We have AMI cleanup script which will retain the most recent x number of AMI's from group and delete the older ones.

    - Following groups will be defined ["vault","consul","rabbitmq","logstash-indexer","ec2-docker","mule","nomad","nomad-agent"] in lambda script which will group the images and process further.
    - For this script to work you need to pass flag release with value latest while generating image from packer. `packer build -var release=latest build/server/consul.json`

## Notes

To build & push docker images in ECR for DR region. $ packer build -var repository_uri={your_repo} build/containers/fly.json

You will notice that `fewknow` is the domain and client specific place holder. Feel free to replace with you domain or client info in a separate branch.

## Maintainers

- Sam Flint sam.flint@digitalonus.com

## Contributors

- Brian Conner brian.conner@digitalonus.com
