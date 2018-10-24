$script = <<-SCRIPT
echo "install dependencies"
sudo sed -i 's/nameserver 10.0.2.3/nameserver 8.8.8.8/g' /etc/resolv.conf
sudo yum install -y xz libcgroup
sudo rpm -Uvh https://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm 
sudo service docker start
sudo service docker start
echo "jenkins repository"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install java git -y
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos6.6"
  config.vm.provision "shell", inline: $script

  config.vm.define "development" do |development|
    config.vm.provider "virtualbox" do |vb|
      vb.name = "dev"
      vb.memory = "1024"
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

end
