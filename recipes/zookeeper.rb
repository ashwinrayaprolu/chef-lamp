# This recipe will be used to install zookeeper

begin

  # Fetch the tarball if it's not a local file
  remote_file '/usr/devenv/share/downloads/zookeeper-3.4.9.tar.gz' do
    source 'http://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.9.tar.gz'
  end

  tar_extract '/usr/devenv/share/downloads/zookeeper-3.4.9.tar.gz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/zookeeper-3.4.9/bin'
  end

  link '/usr/local/zookeeper' do
    to '/usr/local/zookeeper-3.4.9'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end

  execute "chown-zookeeper" do
    command "chown -R hduser:hadoop /usr/local/zookeeper/"
    user "root"
    action :nothing
  end

  # Create directory to store zookeeper data
  directory "/var/lib/zookeeper" do
    owner 'hduser'
    group 'hadoop'
  end
  
  
  directory "/usr/local/zookeeper/logs/" do
    owner 'hduser'
    group 'hadoop'
  end
  
  
  file '/usr/local/zookeeper/conf/zoo.cfg' do
    action :delete
    only_if { File.exist? '/usr/local/zookeeper/conf/zoo.cfg' }
  end
  
  # Write pho shell script file to filesystem
  cookbook_file '/usr/local/zookeeper/conf/zoo.cfg' do
    source 'zoo.cfg'
    owner 'hduser'
    group 'hadoop'
    mode '0644'
  end  
  
  
  # Write Install shell script file to filesystem
  cookbook_file "/tmp/InstallZookeeper.sh" do
    source 'InstallZookeeper.sh'
    owner 'root'
    group 'root'
    mode '0655'
  end
    
  
  
  execute "Changing SHEBANG on ZooKeeper Fix for Ubuntu" do
    user "root"
    cwd "/tmp"
    command "sh InstallZookeeper.sh"
    #not_if 'test -d /usr/local/cassandra', user: 'root'
  end  
  
    
  
=begin

  # Sample code to append to file and delete old content in each run
  execute "Clean up monitrc from earlier runs" do
    user "root"
    command "sed '/#---FLOWDOCK-START/,/#---FLOWDOCK-END/d' > /etc/monitrc"
  end
  
  template "/tmp/monitrc_append.conf" do
    source "monitrc_append.erb"
  end
  
  execute "Setup monit to push notifications into flowdock" do
    user "root"
    command "cat /tmp/monitrc_append.conf >> /etc/monitrc"
  end
  
  execute "Remove monitrc_append" do
    command "rm /tmp/monitrc_append.conf"
  end

=end
  
  
  
  

rescue StandardError => e
  log "-------Errror- while installing zookeeper------------" + e.message
end  