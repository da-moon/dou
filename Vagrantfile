# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

VM_NAME = "elixir_vm_"
MEMORY_SIZE_MB = 1024
NUMBER_OF_CPUS = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "pitakill/elixir"
  
  config.vm.box_version = "1.0.1600970855"
  config.ssh.password = "vagrant"

  ['1', '2', '3'].each do |machine|
    ip_prefix = machine == '1' ? '172.20.20.11' : machine == '2' ? '172.20.20.21' : '172.20.20.22'

    config.vm.define "elixir_box_#{machine}" do |elixir_box|
      elixir_box.vm.provider "virtualbox" do |v|
        v.name = "#{VM_NAME}#{machine}"
        v.customize ["modifyvm", :id, "--memory", MEMORY_SIZE_MB]
        v.customize ["modifyvm", :id, "--cpus", NUMBER_OF_CPUS]
      end
      elixir_box.vm.network :private_network, ip: "#{ip_prefix}"
      # elixir_box.vm.provision :shell, :path => "vagrant_provision.sh"
    end
  end
end
