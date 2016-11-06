# This recipe will be used to install kafka

begin

  # Fetch the tarball if it's not a local file
  remote_file '/usr/devenv/share/downloads/pig-0.16.0.tar.gz' do
    source 'http://www-us.apache.org/dist/pig/pig-0.16.0/pig-0.16.0.tar.gz'
  end
  
  remote_file '/usr/devenv/share/downloads/mysql-connector-java-5.1.40.tar.gz' do
    source 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz'
  end
  
  
  tar_extract '/usr/devenv/share/downloads/mysql-connector-java-5.1.40.tar.gz' do
    action :extract_local
    target_dir '/usr/local/lib'
    creates '/usr/local/lib/mysql-connector-java-5.1.40'
  end

  
  tar_extract '/usr/devenv/share/downloads/pig-0.16.0.tar.gz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/pig-0.16.0'
  end
  
  
  remote_file "Copy MySQLConnector file" do 
    path "/usr/local/hadoop/lib/mysql-connector-java-5.1.40-bin.jar" 
    source "file:///usr/local/lib/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar"
    owner 'hduser'
    group 'hadoop'
    mode 0755
  end
  
  link '/usr/local/pig' do
    to '/usr/local/pig-0.16.0'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end

  
  execute "chown-pig" do
    command "chown -R hduser:hadoop /usr/local/pig"
    user "root"
    action :nothing
  end
  



rescue StandardError => e
  log "-------Errror- while installing pig------------" + e.message
end  