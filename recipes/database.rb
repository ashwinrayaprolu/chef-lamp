#
# Cookbook Name:: myface
# Recipe:: database
#
# Copyright (C) 2012 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#



# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service "#{node['myface']['database']['name']}" do
  #version '5.5'
  bind_address '0.0.0.0'
  port '3306'  
  initial_root_password "#{node['myface']['database']['password']}"
  action [:create, :start]
end

#mysql2_chef_gem 'default' do
#  action :install
#end

package "libmysqlclient-dev" do
  action :install
end

mysql2_chef_gem 'default' do
  action :install
end

#/var/run/mysql-myface/mysqld.sock
# Externalize conection info in a ruby hash
mysql_root_connection_info = {
  #:host     => node['myface']['database']['host'],
  :socket   => "/run/mysql-#{node['myface']['database']['name']}/mysqld.sock",  
  :username => node['myface']['database']['username'],
  :password => node['myface']['database']['password']
}

# Same create commands, connection info as an external hash
mysql_database node['myface']['database']['dbname'] do
  connection mysql_root_connection_info
  action :create
end






mysql_database_user node['myface']['database']['app']['username'] do
  connection mysql_root_connection_info
  password node['myface']['database']['app']['password']
  database_name node['myface']['database']['dbname']
  #host node['myface']['database']['host']
    host '%'
  action [:create, :grant]
end



# Write schema seed file to filesystem
cookbook_file node['myface']['database']['seed_file'] do
  source 'myface-create.sql'
  owner 'root'
  group 'root'
  mode '0600'
end


# Seed database with test data
execute 'initialize myface database' do
  command "mysql -S /run/mysql-#{node['myface']['database']['name']}/mysqld.sock -u#{node['myface']['database']['app']['username']} -p#{node['myface']['database']['app']['password']} -D #{node['myface']['database']['dbname']} < #{node['myface']['database']['seed_file']}"
  not_if  "mysql -S /run/mysql-#{node['myface']['database']['name']}/mysqld.sock -u#{node['myface']['database']['app']['username']} -p#{node['myface']['database']['app']['password']} -D #{node['myface']['database']['dbname']} -e 'describe users;'"
end