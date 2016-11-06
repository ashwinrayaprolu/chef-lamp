# -*- mode: ruby -*-
# vi: set ft=ruby :
# On vagrant up check that we have the latest repo changes
if ARGV[0] == "up" && ARGV.join(" ") != "up --no-provision"
  gs = `git status` # command to check repo status
  gs.scan(/.*Your branch is behind.*/m) { |mtch| # check for out of date message
    puts "Your Vagrant files are out of date... fetching..."
    `git pull origin master` # command to fetch newest files.
    exec "vagrant up --no-provision;vagrant provision" # Re-run vagrant up and provision
  }
end


require 'open3'
require './modules/Nodemanager.rb'
#require './modules/LocalCommand.rb'


=begin

cmd = "/opt/chefdk/bin/chef-client --local -c "+File.absolute_path(File.dirname(__FILE__))+"solo.rb -j "+File.absolute_path(File.dirname(__FILE__))+"solo.json"

cmd = "sh hostProvision.sh"

output `sh hostProvision.sh`
p output

puts "--------------------------Running Local Provisioner-------------" 
Open3.popen3(cmd) do |stdin,stdout,stderr,wait_thr|
  puts "stdout is " + stdout.read
  puts "stderr is " + stderr.read
end

puts "----------------------End Running Local Provisioner-------------" 
=end

include Nodemanager
IpAddressList = Nodemanager.convertIPrange('192.168.1.105', '192.168.1.125')

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  
  #And via the command line like this:
  #vagrant provision --provision-with list-files
  
  #config.vm.provision "DownloadFiles", type: "local_shell", command: "/opt/chefdk/bin/chef-client --local -c solo.rb -j solo.json"
  
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
  
  #Setup Proxy
  # vagrant plugin install vagrant-proxyconf
  config.proxy.http     = "http://10.0.0.175:3128/"
  config.proxy.https    = "http://10.0.0.175:3128/"
  
  # exclude your internal networks, including the Vagrant ones
  config.proxy.no_proxy = "localhost,127.0.0.1,192.168.1.*"
  
  
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

  ipindex = 0
  # Iterate over each of the JSON files
  nodetypes.each do |file|
    puts "parsing #{file}"
    node_json = JSON.parse(File.read(file))

    # Only process the node if it has a vagrant section
    if(node_json["vagrant"])
      
      
      1.upto(node_json["NumberOfNodes"]) do |nodeIndex| 
        
        ipindex = ipindex + 1

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
  
        vagrant_name = node_json["vagrant"]["name"] + "-#{nodeIndex}"
        if(nodeIndex == 1)  
          alias_name = "HadoopMaster"
        else
          alias_name = "HadoopSlave" + "#{nodeIndex-1}"
        end
        is_public = node_json["vagrant"]["is_public"]
        #vagrant_ip = node_json["vagrant"]["ip"]
        vagrant_ip = IpAddressList[ipindex-1]
        config.vm.define vagrant_name, autostart: true  do |vagrant|
         
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
          if vagrant_ip && is_public
            # Assumption is we would never cross more than 15 hosts per machine
            # We are assuming CIDR of /28 for ip address for given host
            vagrant_ip = IpAddressList[15]
            vagrant.vm.network :private_network, ip: vagrant_ip,  :netmask => "255.255.0.0"
          end
          
          if vagrant_ip && !is_public
            vagrant.vm.network :private_network, ip: vagrant_ip,  :netmask => "255.255.0.0"
          end
          
          if is_public
            puts "--------------------Configuring Public Network----------------"
            vagrant.vm.network "public_network", type: "dhcp", bridge: "em1"
            vagrant.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "2048"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
            end
          else
            # Public network is used for gateway so not used
            vagrant.hostmanager.aliases = alias_name
            vagrant.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "6048"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
            end
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
          
          # Below code is run for Nodes that are based on Cassandra/Hadoop/Kafka.
          # Mostly adding relative properties and known hosts
          if node_json["vagrant"]["cassandra_node"] 
            vagrant.vm.provision "shell", preserve_order: true,inline: <<-HDCONF
                runuser -l hduser -c 'rm -rf /usr/local/hadoop/etc/hadoop/masters'
                runuser -l hduser -c 'rm -rf /usr/local/hadoop/etc/hadoop/slaves'
HDCONF


         #Add local host to hduser ssh known hosts
        vagrant.vm.provision "shell", preserve_order: true,inline: <<-NEWDOC
            runuser -l hduser -c 'ssh-keygen -R localhost'
            runuser -l hduser -c 'ssh-keyscan -H localhost | grep "ssh-rsa" >> ~/.ssh/known_hosts'
            runuser -l hduser -c 'ssh-keyscan -H localhost | grep "sha2-nistp256" >> ~/.ssh/known_hosts'
NEWDOC

            zookeeperServers = "";
            # Iterate over all nodes
            1.upto(node_json["NumberOfNodes"]) do |myNodeIndex|
              
              if(myNodeIndex == 1) 
                alias_name = "HadoopMaster";
                nodeFileName = "/usr/local/hadoop/etc/hadoop/masters";
                zookeeperServers = alias_name + ":2181";
              else
                nodeFileName = "/usr/local/hadoop/etc/hadoop/slaves";
                alias_name = "HadoopSlave" + "#{myNodeIndex-1}";
                zookeeperServers = zookeeperServers + ",#{alias_name}:2181";
              end
              
              
              
             # puts "Adding Hadoop Config for #{nodeFileName}"
                
              vagrant.vm.provision "shell", preserve_order: true,inline: <<-HDCONF
                  runuser -l hduser -c 'touch #{nodeFileName}'
                  runuser -l hduser -c 'echo  "#{alias_name}">> #{nodeFileName}'
                  runuser -l hduser -c 'echo "server.#{myNodeIndex}=#{alias_name}:2888:3888">>/usr/local/zookeeper/conf/zoo.cfg'
HDCONF
          

              # Add host files for all hadoop nodes. We know last node is gateway node to ignore that
             # if(is_public == false) 
                if(myNodeIndex == 1)  
                  alias_name = "HadoopMaster"
                else
                  alias_name = "HadoopSlave" + "#{myNodeIndex-1}"
                end
                #puts "Working with node #{alias_name}"
                vagrant.vm.provision "shell", preserve_order: true,inline: <<-NEWDOC
                  runuser -l hduser -c 'ssh-keygen -R #{alias_name}'
                  runuser -l hduser -c 'ssh-keyscan -H #{alias_name} | grep "ssh-rsa" >> ~/.ssh/known_hosts'
                  runuser -l hduser -c 'ssh-keyscan -H #{alias_name} | grep "sha2-nistp256" >> ~/.ssh/known_hosts'
NEWDOC


              if myNodeIndex != nodeIndex
                # Now add shell provisioner to add known hosts
                # To Find sudo /sbin/ifconfig | grep "inet addr" | grep "192\.168" | awk '{ split($2,a , ":"); print a[2] }'
                targetHostName = node_json["vagrant"]["name"] + "-#{myNodeIndex}"
                vagrant.vm.provision "shell", preserve_order: true,inline: <<-SHELL
                    runuser -l cassandra -c 'ssh-keygen -R #{targetHostName}'
                    runuser -l cassandra -c 'ssh-keyscan -H #{targetHostName} | grep "ssh-rsa" >> ~/.ssh/known_hosts'
                    runuser -l cassandra -c 'ssh-keyscan -H #{targetHostName} | grep "sha2-nistp256" >> ~/.ssh/known_hosts'
                    runuser -l cassandra -c 'sh /tmp/UpdateCassandraProperties.sh'
                    apt -y install python-pip
                    pip install cassandra-driver
SHELL
                
                   
               # end 
              else
                vagrant.vm.provision "shell", preserve_order: true,inline: <<-ZKMYID
                  runuser -l hduser -c 'rm -rf /var/lib/zookeeper/myid'
                  runuser -l hduser -c 'touch /var/lib/zookeeper/myid'
                  runuser -l hduser -c 'echo #{myNodeIndex} > /var/lib/zookeeper/myid'
ZKMYID
              end 
            end 
            # End of Iteration of all Nodes
            # Configure Zookeeper servers in Kafka
            puts "Adding #{zookeeperServers} to kafka";
            vagrant.vm.provision "shell", preserve_order: true,inline: <<-KAFKACONFIG
              chown -R hduser:hadoop /usr/local/kafka/
              runuser -l hduser -c  "sed -i 's/broker\.id=0/broker\.id=#{nodeIndex-1}/g' /usr/local/kafka/config/server.properties"
              runuser -l hduser -c  "sed -i 's/localhost:2181/#{zookeeperServers}/g' /usr/local/kafka/config/server.properties"
KAFKACONFIG
            
            
            
          end
          
        end  # End of VM Config
        
      end # End of node interation on count
    end  #End of vagrant found
  end # End of each node type file
  
  
  
  
  
  
  
  
  
  
  
  
end
