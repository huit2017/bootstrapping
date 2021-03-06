# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos73"
  config.ssh.insert_key = false

  config.vm.define "gateway" do |node|
    node.vm.hostname = "gateway"
    node.vm.network :private_network, ip: "192.168.31.11"
    node.vm.provision :shell, :path => "provision.sh", privileged: false
    node.vm.provision "file", source: "ssh_config", destination: ".ssh/config"
  end

  config.vm.define "om" do |node|
    node.vm.hostname = "om"
    node.vm.network :private_network, ip: "192.168.31.12"
  end

  config.vm.define "elk" do |node|
    node.vm.hostname = "elk"
    node.vm.network :private_network, ip: "192.168.31.13"
  end

  config.vm.define "vuls" do |node|
    node.vm.hostname = "vuls"
    node.vm.network :private_network, ip: "192.168.31.14"
  end

  config.vm.define "bot" do |node|
    node.vm.hostname = "bot"
    node.vm.network :private_network, ip: "192.168.31.15"
  end

  config.vm.define "its" do |node|
    node.vm.hostname = "its"
    node.vm.network :private_network, ip: "192.168.31.16"
  end

  config.vm.define "scm" do |node|
    node.vm.hostname = "scm"
    node.vm.network :private_network, ip: "192.168.31.17"
  end

  config.vm.define "ci" do |node|
    node.vm.hostname = "ci"
    node.vm.network :private_network, ip: "192.168.31.18"
  end

  config.vm.define "cis1" do |node|
    node.vm.hostname = "cis1"
    node.vm.network :private_network, ip: "192.168.31.19"
  end

  config.vm.define "mail" do |node|
    node.vm.hostname = "mail"
    node.vm.network :private_network, ip: "192.168.32.10"
  end

  config.vm.define "web" do |node|
    node.vm.hostname = "web"
    node.vm.network :private_network, ip: "192.168.32.11"
  end

  config.vm.define "app" do |node|
    node.vm.hostname = "app"
    node.vm.network :private_network, ip: "192.168.32.12"
  end

  config.vm.define "batch" do |node|
    node.vm.hostname = "batch"
    node.vm.network :private_network, ip: "192.168.32.13"
  end

  config.vm.define "db" do |node|
    node.vm.hostname = "db"
    node.vm.network :private_network, ip: "192.168.32.14"
  end

  config.vm.define "dbs1" do |node|
    node.vm.hostname = "dbs1"
    node.vm.network :private_network, ip: "192.168.32.15"
  end

  config.vm.define "nosql" do |node|
    node.vm.hostname = "nosql"
    node.vm.network :private_network, ip: "192.168.32.16"
  end

  config.vm.define "nosqls1" do |node|
    node.vm.hostname = "nosqls1"
    node.vm.network :private_network, ip: "192.168.32.17"
  end

  config.vm.define "etl" do |node|
    node.vm.hostname = "etl"
    node.vm.network :private_network, ip: "192.168.32.18"
  end

  config.vm.define "local" do |node|
    node.vm.hostname = "local"
    node.vm.network :private_network, ip: "192.168.33.10"
    node.vm.provision :shell, :path => "provision.sh", privileged: false
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

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
