sudo rm -rf /usr/local/cassandra* &&
sudo tar -xvzf /usr/devenv/share/downloads/apache-cassandra-3.7-bin.tar.gz -C /usr/local/ &&
cd /usr/local/ &&
sudo mv apache-cassandra-3.7 cassandra-3.7 &&
sudo ln -s /usr/local/cassandra-3.7 /usr/local/cassandra &&
sudo chown -R cassandra:cassandra /usr/local/cassandra
