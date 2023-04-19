# IIDK

Immutable Infrastructure development kit

--------------------------------------------------------------------------------

# Description

This repository will allow a developer to quickly test and develop custom image builds using Vagrant and Ansible, and once local development is finished, create cloud images with Packer. The list of roles to build images can be found in ansible/linux/ubuntu/playbooks/roles.

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

- You will need to update you bash profile and set an enviroment variable to take use of some cool tricks. Once this is done you should be able to run this command and get the same output.

```
fewknow@Jamess-MacBook-Pro IIDK (sam-testing)$ ENV | grep VAGRANT
VAGRANT=true
```

--------------------------------------------------------------------------------

## Supported Cloud Platforms

![AWS Support](./_docs/aws_icon.png)

--------------------------------------------------------------------------------

## Installation & How to Develop

This repo can be thought of as being in 2 parts, local development and building in the cloud. We'll use rabbitmq on ubuntu as an example, adjust for your needs.

--------------------------------------------------------------------------------

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

  1. From your macbook, `vagrant destroy`.

  ### Build

  1. Now that your code changes are complete, it's time to use Packer to create an cloud images.

    - Navigate to the IIDK/build/server directory
    - Update the variables for your cloud provider `<cloud>_variables.pkrvars.hcl`
    - Run packer command for you cloud provider `packer build -var-file <cloud>_variables.pkrvars.hcl <cloud>.pkr.hcl`

  2. There is a `terraform` folder that will allow you to spin up a cloud environment to build you image for testing.

    - Navigate to the correct folder that you want, provide the credentials for that cloud platform and run `terraform apply`

  ### Cleanup

  1. You will need to destroy the cloud environment you made with `terraform destroy`.
  2. You may also need to delete the image you created in the cloud depending on where you stored it.

--------------------------------------------------------------------------------

## Notes

You will notice that `fewknow` is the domain and client specific place holder. Feel free to replace with you domain or client info in a separate branch.

--------------------------------------------------------------------------------

## Maintainers

- Sam Flint sam.flint@digitalonus.com Testing
