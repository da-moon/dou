# -*- mode: ruby -*-
# vim: set ft=ruby :
synced_folder  = ENV[     'SYNCED_FOLDER'      ]  || "/home/vagrant/#{File.basename(Dir.pwd)}"
memory         = ENV[           'MEMORY'       ]  || 4096
cpus           = ENV[           'CPUS'         ]  || 4
vm_name        = ENV[           'VM_NAME'      ]  || File.basename(Dir.pwd)
forwarded_ports= [
  "8200",
]
Vagrant.configure("2") do |config|
  config.vm.define "#{vm_name}"
  config.vm.hostname = "#{vm_name}"
  config.vm.synced_folder ".","#{synced_folder}",auto_correct:true, owner: "vagrant",group: "vagrant",disabled:true
  config.vagrant.plugins = [ "vagrant-vbguest" ]
  config.vm.box = "fjolsvin/ubuntu-desktop"
  config.vm.box_version = "1.0.0"
  config.vm.guest = :ubuntu
  config.vm.provider "virtualbox" do |vb, override|
    vb.memory = "#{memory}"
    vb.cpus   = "#{cpus}"
    vb.customize [
      "modifyvm", :id,
      # => enable use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
      "--hwvirtex" ,"on",
      # => enable nested virtualization
      "--nested-hw-virt", "on",
      # => bidirectional clipboard sync between host and guest
      "--clipboard", "bidirectional",
      # => bidriectional drag and drop between host and guest
      "--draganddrop", "bidirectional",
      # => use 256 mb memory for graphics
      "--vram", "256",
      # => disable 3d acceleration. This fixes the issue with slow VSCode
      "--accelerate3d", "off",
    ]
    vb.gui = "on"
    vb.check_guest_additions = true
    override.vm.synced_folder ".", "#{synced_folder}",disabled: false,
      auto_correct:true, owner: "vagrant",group: "vagrant",type: "virtualbox"
  end
  forwarded_ports.each do |port|
    config.vm.network "forwarded_port",
      guest: port,
      host: port,
      auto_correct: true
  end
end
