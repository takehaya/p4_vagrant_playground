# -*- mode: ruby -*-
Vagrant.configure("2") do |config|
    # config.vm.box = "bento/ubuntu-19.10"
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 4
    end
    config.vm.provision "shell", path: "./env_init.sh"
    config.vm.synced_folder "../../Workspace/gop4d", "/home/vagrant/workspace"
end
