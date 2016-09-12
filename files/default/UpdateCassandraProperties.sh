sudo chown -R cassandra:cassandra /usr/local/cassandra/ &&
sh /home/cassandra/.bash_profile &&
sudo sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'MRCCluster'/g" /usr/local/cassandra/conf/cassandra.yaml &&
sudo sed -i 's/- seeds: "127.0.0.1"/- seeds: "'"$CASSANDRA_SEEDS"'"/g' /usr/local/cassandra/conf/cassandra.yaml &&
sudo sed -i 's/rpc_address: localhost/rpc_address: '"$CASSANDRA_HOST"'/g' /usr/local/cassandra/conf/cassandra.yaml &&
sudo sed -i 's/listen_address: localhost/listen_address: '"$CASSANDRA_HOST"'/g' /usr/local/cassandra/conf/cassandra.yaml
