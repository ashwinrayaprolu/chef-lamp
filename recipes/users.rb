

users_manage 'cassandra' do
  group_id 3000
  action [:create]
  data_bag 'cassandra'
end


users_manage 'hadoop' do
  group_id 3002
  action [:create]
  data_bag 'hdfs'
end


# Copy Precooked encryption keys
cookbook_file node['myface']['host_key']['cassandra']['path'] do
  source 'keys/lamp-server'
  owner 'cassandra'
  group 'cassandra'
  mode '0400'
  #chmod 400 ~/.ssh/id_rsa
  # 600 appears to be fine as well 
end
#runuser -l hduser -c "rm -rf /home/hduser/.ssh/id_rsa*" &&
#runuser -l hduser -c "ssh-keygen -t rsa -f /home/hduser/.ssh/id_rsa -P ''" &&
#runuser -l hduser -c "touch /home/hduser/.ssh/known_hosts" &&
#runuser -l hduser -c "ssh-keygen -R localhost" &&
#runuser -l hduser -c "cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys" &&
#runuser -l hduser -c "chmod og-wx /home/hduser/.ssh/authorized_keys" &&





cookbook_file node['myface']['host_key']['hduser']['path'] do
  source 'keys/lamp-server'
  owner 'hduser'
  group 'hduser'
  mode '0400'
  #chmod 400 ~/.ssh/id_rsa
  # 600 appears to be fine as well 
end