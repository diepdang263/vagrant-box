# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.ssh.forward_agent = true
    config.vm.network "private_network", ip: "192.168.13.37"

	config.vm.provider "virtualbox" do |v, override|
        v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
        v.customize ["modifyvm", :id, "--memory", "1024"]
        v.customize ["modifyvm", :id, "--cpus", "1"]
        v.name = "WebServer"
    end

    config.vm.box = "bento/ubuntu-16.04"
    config.vm.provision :shell, :path => "bootstrap.sh"

    config.vm.synced_folder ".", "/vagrant", create: true, owner: "vagrant", group: "vagrant"
    config.vm.synced_folder "./logs", "/var/log", create: true, owner: "vagrant", group: "vagrant"
    config.vm.synced_folder "D:/Projects", "/home/vagrant/apps", create: true, owner: "vagrant", group: "vagrant"

end