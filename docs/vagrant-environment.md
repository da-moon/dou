# vagrant-environment

## Overview

This document outlines common snippets, usage guide and internal design
documents on this project's shared development environment.

## Requirements

- Hashicorp's `Vagrant`
- Virtual Machine Hypervisor : `virtual-box`
- at least `4096 MB` of RAM
- at least `4` logical CPU cores

## Usage

- Start the VM

```bash
vagrant up
```

If this is the first time you are starting the virtual machine, Vagrant is
going to ask you to install plugins. **You have to run the command another time
after the first run to start the VM**

The following environment variables can be used to customize VM requirements
without modifying the `Vagrantfile`:

```bash
# [ NOTE ] => these are the default values
# ────────────────────────────────────────────────────────────
# the location the directory containing the Vagrantfile is mounted inside Guest OS
# The default location inside guest is `${HOME}/<directory-name>`
export SYNCED_FOLDER="/home/vagrant/$(basename "${PWD}")"
# Ram limit.
# Defaults to 4 GB
export MEMORY=4096
# CPU core limit.
# Defaults to 4 logical cores
export CPUS=4
# Virtual Machine name as shown in Hypervisor
# Defaults to name of the directory `Vagrantfile` is in.
export VM_NAME="$(basename "${PWD}")"
```

> these environment variables must be set before running `vagrant up`

- Shutdown the VM

```bash
vagrant halt -f
```

- Setup and update SSH config file for using the Vagrant Box as a backend for
`vscode remote : SSH` extension:

```bash
PROJECT_NAME="$(basename "${PWD}")" ;
sed -n -i "/$PROJECT_NAME/,/LogLevel/!{//!p}" "${HOME}/.ssh/config" || true ;
echo '' >> "${HOME}/.ssh/config"
vagrant ssh-config >> "${HOME}/.ssh/config"
sed -i '/^\s*$$/d' "${HOME}/.ssh/config"
```

After running this snippet, you can ssh into the VM by running `ssh
${PROJECT_NAME}` and you can also use it as a backend for `vscode remote : SSH`
extension

- Destroy the VM

```bash
vagrant destroy -f
PROJECT_NAME="$(basename "${PWD}")" ;
sed -n -i "/$PROJECT_NAME/,/LogLevel/!{//!p}" "${HOME}/.ssh/config" || true ;
```

## Internals

### Virtual Machine VS Docker

The reason why we are using `Vagrant` with a Virtual Machine Hypervisor backend
instead of docker is primarily due to elavated priviledge and nested
virtualization requirements.

Specifically speaking, when building the golden image, we would like to test
our Ansible playbooks locally to speed up development process and make
debugging easier.

To do so, we need a clean Virtualized `RHEL` system that we can pass to
`Ansible` for provisioning. This system needs to be able to run `systemd`
services; Running SystemD in docker requires mounting `systemd` related `unix
sockets` into the Docker container.

Linux Sockets ( and`systemd` ) are only available on Linux system, making it
impossible for Mac/Windows users to use Docker for running tests.

Needless to say, the VM `vagrant` manages is an Ubuntu system which runs
`systemd` , making it possible to test Ansible playbooks that provision the
golden image with barebone `Docker` container, Ansible Molecule's `Docker`
driver, a bare `LXD` container or Ansible Molecule's `LXD` driver
