#
# Cookbook Name:: myface
# Recipe:: webserver
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

group node['myface']['group']

user node['myface']['user'] do
  group node['myface']['group']
  system true
  shell '/bin/bash'
end



include_recipe 'apache2'
#include_recipe 'apache2::mod_php5'

# For Ubuntu 16.04 and higher php7.0-mysql else php-mysql
package 'php7.0-mysql' do
  action :install
  notifies :restart, 'service[apache2]'
end


execute "Disable MPM Event and Enable Prefork" do
  command "sudo a2dismod mpm_event && sudo a2enmod mpm_prefork && cp /etc/apache2/mods-available/php* /etc/apache2/mods-enabled/ "
  notifies :restart, 'service[apache2]'
end



# disable default site
apache_site '000-default' do
  enable false
end


template "#{node['apache']['dir']}/sites-enabled/myface.conf" do
  source 'apache2.conf.erb'
end

# create apache config
template "#{node['apache']['dir']}/sites-available/myface.conf" do
  source 'apache2.conf.erb'
  notifies :restart, 'service[apache2]'
end

# create document root
directory "#{node['myface']['document_root']}" do
  action :create
  recursive true
end

# write site
cookbook_file "#{node['myface']['document_root']}/index.html" do
  mode '0655' # forget me to create debugging exercise
end

# write site
template "#{node['myface']['document_root']}/index.php" do
  source 'index.php.erb'
  mode '0644'
end

# write site
template "#{node['myface']['document_root']}/phpinfo.php" do
  source 'phpinfo.php.erb'
  mode '0644'
end

# enable myface
apache_site "#{node['myface']['config']}" do
  enable true
end

#Enable PHP 7.0 Module
#apache_module "php7.0" do
#      conf true
#end
apache_mod "php7.0"
