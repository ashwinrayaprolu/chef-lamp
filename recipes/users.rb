

users_manage 'cassandra' do
  group_id 3000
  action [:create]
  data_bag 'users'
end


# Write pho shell script file to filesystem
cookbook_file node['myface']['private_key']['path'] do
  source 'keys/lamp-server'
  owner 'cassandra'
  group 'cassandra'
  mode '0400'
  #chmod 400 ~/.ssh/id_rsa
  # 600 appears to be fine as well 
end