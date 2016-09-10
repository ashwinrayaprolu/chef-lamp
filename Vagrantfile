# -*- mode: ruby -*-
# vi: set ft=ruby :

require './modules/Nodemanager.rb'

include Nodemanager
IpAddressList = Nodemanager.convertIPrange('192.168.1.105', '192.168.1.125')

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'myface-berkshelf'
  # Create Share for us to Share some files
  config.vm.synced_folder "share/", "/usr/devenv/share/", disabled: false
  # Disable Default Vagrant Share
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  # Setup resource requirements
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
  
  # vagrant plugin install vagrant-hostmanager
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true


  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = '12.13.37'
  end

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'bento/ubuntu-16.04'


  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: 'dhcp'
  #config.vm.network :private_network, ip: "33.33.33.10"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.



  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  # vagrant plugin install vagrant-berkshelf
  config.berkshelf.enabled = true


  
  # Assumes that the Vagrantfile is in the root of our
  # Chef repository.
  root_dir = File.dirname(File.expand_path(__FILE__))

  # Assumes that the node definitions are in the nodes
  # subfolder
  nodetypes = Dir[File.join(root_dir,'nodes','*.json')]

  # Iterate over each of the JSON files
  nodetypes.each do |file|
    puts "parsing #{file}"
    node_json = JSON.parse(File.read(file))

    # Only process the node if it has a vagrant section
    if(node_json["vagrant"])
      
      
      1.upto(node_json["NumberOfNodes"]) do |nodeIndex| 

        # Allow us to remove certain items from the run_list if we're
        # using vagrant. Useful for things like networking configuration
        # which may not apply.
        if exclusions = node_json["vagrant"]["exclusions"]
          exclusions.each do |exclusion|
            if node_json["run_list"].delete(exclusion)
              puts "removed #{exclusion} from the run list"
            end
          end
        end
  
        vagrant_name = node_json["vagrant"]["name"] + ".#{nodeIndex}"
        #vagrant_ip = node_json["vagrant"]["ip"]
        vagrant_ip = IpAddressList[nodeIndex]
        config.vm.define vagrant_name do |vagrant|
         
          #vagrant.hostmanager.aliases = %w(example-box.localdomain example-box-alias)
          # change the network card hardware for better performance
          #vagrant.vm.customize ["modifyvm", :id, "--nictype1", "virtio" ]
          #vagrant.vm.customize ["modifyvm", :id, "--nictype2", "virtio" ]
      
          # suggested fix for slow network performance
          # see https://github.com/mitchellh/vagrant/issues/1807
          #vagrant.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          #vagrant.vm.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          
          vagrant.vm.hostname = vagrant_name 
          puts  "Working with host #{vagrant_name} with IP : #{vagrant_ip}" 
  
          # Only use private networking if we specified an
          # IP. Otherwise fallback to DHCP
          if vagrant_ip
            vagrant.vm.network :private_network, ip: vagrant_ip
          end
  
          # hostmanager provisioner
          config.vm.provision :hostmanager
          
          vagrant.vm.provision :chef_solo do |chef|
            #config.vm.network "forwarded_port", guest: 80, host: 8080
            # Instead of using add_recipe and add_role, just
            # assign the node definition json, this will take
            # care of populating the run_list.
            chef.data_bags_path = "data_bags"
            chef.json = node_json          
          end        
          
        end  # End of VM Config
        
      end # End of node interation on count
    end  #End of vagrant found
  end # End of each node type file
  
  
  
  
  
  
  
  
  
  
  
  
end
