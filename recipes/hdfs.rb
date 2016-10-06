include_recipe 'tarball::default'

begin
  
  # Fetch the tarball if it's not a local file
  remote_file '/tmp/hadoop-2.7.3.tar.gz' do
    source 'http://www-us.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz'
  end
  
  # Write Install shell script file to filesystem
  cookbook_file node['myface']['install']['hdfs'] do
    source 'InstallHadoop.sh'
    owner 'hduser'
    group 'hadoop'
    mode '0655'
  end
  

  # Copy the bash profile to target user directory
  cookbook_file '/home/hduser/.bash_profile' do
    source 'hduser_profile'
    owner 'hduser'
    group 'hadoop'
    mode '0644'
  end  
  
  
  execute "Enable SUDO to HDUser" do
    user "root"
    command "adduser hduser sudo"
  end
  
  execute "InstallHDFS" do
    user "root"
    cwd "/tmp"
    command "sh InstallHadoop.sh"
    #not_if 'test -d /usr/local/cassandra', user: 'root'
  end
  
  # Copy all hadoop config files from cookbook to target machine
  remote_directory '/usr/local/hadoop/etc/hadoop/' do
    source 'hadoop/master'
    owner 'hduser'
    group 'hadoop'
    mode '0755'
    action :create
  end  

  
    
rescue StandardError => e
  log "-------Errror-------------" + e.message
end  