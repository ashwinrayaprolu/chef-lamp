include_recipe 'tarball::default'

#begin
  
  
  
  # Fetch the tarball if it's not a local file
  remote_file '/tmp/apache-cassandra-3.7-bin.tar.gz' do
    source 'http://www-us.apache.org/dist/cassandra/3.7/apache-cassandra-3.7-bin.tar.gz'
  end
  
  
  # Write pho shell script file to filesystem
  cookbook_file node['myface']['install']['cassandra'] do
    source 'InstallCassandra.sh'
    owner 'cassandra'
    group 'cassandra'
    mode '0655'
  end
  
  # Write pho shell script file to filesystem
  cookbook_file '/home/cassandra/.bash_profile' do
    source 'cassandra_profile'
    owner 'cassandra'
    group 'cassandra'
    mode '0644'
  end  
  
  cookbook_file node['myface']['update']['cassandra'] do
    source 'UpdateCassandraProperties.sh'
    owner 'cassandra'
    group 'cassandra'
    mode '0655'
  end  
  
  execute "Enable SUDO to cassandra" do
    user "root"
    command "adduser cassandra sudo"
  end
  
  execute "InstallCassandra" do
    user "root"
    cwd "/tmp"
    command "sh InstallCassandra.sh"
    #not_if 'test -d /usr/local/cassandra', user: 'root'
  end
 
  
  #execute "UpdateCassandraProperties" do
  #  user "root"
  #  cwd "/tmp"
  #  command "sh UpdateCassandraProperties.sh"
  #  #not_if 'test -d /usr/local/cassandra', user: 'root'
  #end  
  
  script 'Update Permissions' do
    interpreter "bash"
    user "root"
    code <<-EOH
      chown cassandra:cassandra /home/cassandra/.bash_profile
      chown -R cassandra:cassandra /usr/local/cassandra
      chmod -R 744 /usr/local/cassandra
EOH
  end 
     
  execute "Update Permissions from command" do
      user "root"
      cwd "/usr/local/"  
      command "chown cassandra:cassandra /home/cassandra/.bash_profile && chown -R cassandra:cassandra /usr/local/cassandra && chmod -R 744 /usr/local/cassandra"
  end
  
  
  

  
  
  # I can also use tarball_x "file" do ...
  <<-DOC
    tarball_x '/tmp/apache-cassandra-3.7-bin.tar.gz' do
      destination '/opt/local/apache-cassandra-3.7'    # Will be created if missing
      owner 'cassandra'
      group 'cassandra'
      umask 002             # Will be applied to perms in archive
      action :extract
    end
  DOC
  

  
  
#rescue StandardError => e
#  log e.message
#end  