# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
echo "install dependencies"
sudo sed -i 's/nameserver 10.0.2.3/nameserver 8.8.8.8/g' /etc/resolv.conf
sudo yum install -y xz libcgroup
sudo rpm -Uvh https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm 
sudo service docker start
sudo wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install java git -y
echo "registry config"
sudo echo "192.168.100.100 development" >> /etc/hosts
sudo echo "192.168.100.101 production" >> /etc/hosts
sudo mkdir -p /myregistry/registry/certs
sudo mkdir -p /etc/docker/certs.d/development:443
sudo wget -O /myregistry/registry/certs/registry.crt https://raw.githubusercontent.com/JasonYLong/testweb/master/certs/registry.crt 
sudo wget -O /myregistry/registry/certs/registry.key https://raw.githubusercontent.com/JasonYLong/testweb/master/certs/registry.key
sudo cp /myregistry/registry/certs/registry.crt /etc/docker/certs.d/development:443/ca.crt
echo "generate public key"
sudo ssh-keygen -t rsa -b 4096 -P '' -f /root/.ssh/id_rsa
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos6.6"
  config.vm.provision "shell", inline: $script

  config.vm.define "development" do |development|
    config.vm.provider "virtualbox" do |vb|
      vb.name = "dev"
      vb.memory = "2048"
    end  
    development.vm.network "public_network"
    development.vm.network "private_network", ip:"192.168.100.100"
    development.vm.hostname = "dev"
    development.vm.synced_folder "development", "/vagrant", create:true
  end

  config.vm.define "production" do |production|
    config.vm.provider "virtualbox" do |vb|
      vb.name = "prod"
      vb.memory = "1024"
    end  
    production.vm.network "public_network"
    production.vm.network "private_network", ip:"192.168.100.101"
    production.vm.hostname = "prod"
    production.vm.synced_folder "production", "/vagrant", create:true
  end 

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
