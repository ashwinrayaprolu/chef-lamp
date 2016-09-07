# -*- mode: ruby -*-
# vi: set ft=ruby :

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


  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = 'latest'
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
  config.berkshelf.enabled = true


  
  # Assumes that the Vagrantfile is in the root of our
  # Chef repository.
  root_dir = File.dirname(File.expand_path(__FILE__))

  # Assumes that the node definitions are in the nodes
  # subfolder
  nodes = Dir[File.join(root_dir,'nodes','*.json')]

  # Iterate over each of the JSON files
  nodes.each do |file|
    puts "parsing #{file}"
    node_json = JSON.parse(File.read(file))

    # Only process the node if it has a vagrant section
    if(node_json["vagrant"])

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

      vagrant_name = node_json["vagrant"]["name"] 
      vagrant_ip = node_json["vagrant"]["ip"]

      config.vm.define vagrant_name do |vagrant|
        vagrant.vm.hostname = vagrant_name

        # Only use private networking if we specified an
        # IP. Otherwise fallback to DHCP
        if vagrant_ip
          vagrant.vm.network :private_network, ip: vagrant_ip
        end

        
        vagrant.vm.provision :chef_solo do |chef|
          #config.vm.network "forwarded_port", guest: 80, host: 8080
      
          #chef.run_list = [
          #  'recipe[myface::default]'
          #]
          
          # Use berks-cookbooks not cookbooks and remember
          # to explicitly vendor berkshelf cookbooks
          #chef.cookbooks_path = ["site-cookbooks"]
          #chef.data_bags_path = "data_bags"
          #chef.roles_path = "roles"

          # Instead of using add_recipe and add_role, just
          # assign the node definition json, this will take
          # care of populating the run_list.
          chef.json = node_json          
          
          
          
        end        
        
        
      end
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
end
