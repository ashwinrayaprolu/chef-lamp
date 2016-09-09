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


