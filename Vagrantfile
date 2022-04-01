# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yml")
urls           = configs['configs']['urls']
puppet_base_url     = urls['puppet_base_url']
puppet_deb     = urls['puppet_deb']
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
  config.vm.box = "hashicorp/bionic64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 80, host: 8080

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
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   echo Updating...
  #   apt-get -qq update
  #   echo Updated.
  #   echo Downloading #{puppet_deb} from #{puppet_base_url}
  #   curl -sSo /tmp/#{puppet_deb}  "#{puppet_base_url}#{puppet_deb}"  
  #   echo Downloaded.
  #   echo Installing #{puppet_deb}
  #   sudo dpkg -i /tmp/#{puppet_deb}
  #   echo Updating...
  #   apt-get -qq update
  #   echo Updated.
  #   apt-get install puppet-agent
  #   source /etc/profile.d/puppet-agent.sh
  #   export PATH=/opt/puppetlabs/bin:$PATH
  #   echo "Puppet version: `puppet --version`"
  #   
  # SHELL
  config.vm.provision :shell do |shell|
    shell.inline = "
                    # export LANGUAGE=en_US.UTF-8;
                    # export LANG=en_US.UTF-8;
                    # export LC_ALL=en_US.UTF-8;
                    # locale-gen en_US.UTF-8;
                    # dpkg-reconfigure locales;
                    echo Updating...;
                    apt-get -qq update;
                    echo Updated.;
                    echo Downloading #{puppet_deb} from #{puppet_base_url};
                    curl -sSo /tmp/#{puppet_deb}  \"#{puppet_base_url}#{puppet_deb}\";
                    echo Downloaded.;
                    echo Installing #{puppet_deb};
                    sudo dpkg -i /tmp/#{puppet_deb};
                    echo Updating...;
                    apt-get -qq update;
                    echo Updated.;
                    apt-get install puppet-agent;
                    source /etc/profile.d/puppet-agent.sh;
                    export PATH=/opt/puppetlabs/bin:$PATH;
                    echo \"Puppet version: `puppet --version`\";
                    mkdir -p /etc/puppet/modules;
                    puppet module install puppetlabs/mysql;
                    puppet module install puppet-archive;
                    puppet module install puppetlabs/apache;"
  end
  
  config.vm.provision "puppet" do | puppet | 
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "main.pp"
  end
end
