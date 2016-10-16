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

rescue StandardError => e
  log "-------Errror- while installing zookeeper------------" + e.message
end  