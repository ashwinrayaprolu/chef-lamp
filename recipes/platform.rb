include_recipe 'apt::default'
version_checker = Chef::VersionConstraint.new("~> 14.0")

log 'Verson Check' do
  message "OS Platform  #{node[:platform]}  and OS Version == #{node['platform_version']} "
  level :info
end

log 'Verson Check Condition' do
  message "#{node[:platform].include?("ubuntu") and version_checker.include?(node['platform_version'])}"
  level :info
end

execute "Updating Archive HostName" do
  if node[:platform].include?("ubuntu") and version_checker.include?(node['platform_version'])
    command "sudo sed -i -e 's/archive.ubuntu.com\\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list"
  else
    command "echo 'No modification needed'"
  end
end


package "language-pack-en-base" do 
  action :install
end


# Write schema seed file to filesystem
cookbook_file node['myface']['install']['php'] do
  source 'InstallPHP.sh'
  owner 'root'
  group 'root'
  mode '0655'
end


#add-apt-repository -y ppa:ondrej/php5-5.6 &&
#apt install php5.6 

execute "InstallPHP" do
  user "root"
  cwd "/tmp"
  command "sh InstallPHP.sh"
end




#package ['php5.6','libapache2-mod-php5.6','php5.6-curl','php5.6-gd','php5.6-mbstring','php5.6-mcrypt','php5.6-mysql','php5.6-xml','php5.6-xmlrpc'] do
package ['php7.0','php-pear','libapache2-mod-php7.0','php7.0-mysql','php7.0-curl','php7.0-json','php7.0-cgi'] do
  action :install
end


execute "apt-get-update" do
 # command "sudo add-apt-repository ppa:ondrej/php"
  command "apt-get update"
  ignore_failure true
  action :nothing
end


execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
   File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
   File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end





execute "Install Docker Environment" do
  user "root"
  cwd "/usr/devenv/share/docker/"
  command "sh Install.sh"
  not_if 'service --status-all | grep "docker"' # Run the above command if docker is not installed
end
