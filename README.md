# LAMP-cookbook
```desc
This is series 1 of different developmental machine cookbook's by me
LAMP Stack for Developers.
This is based of https://github.com/misheska/myface
Misheska's tutorial got outdated with recent version's of Ruby,Chef and Berkshelf 
I've updated this code as of August 28th 2016.
Note: Upgraded almost all except mysql connectivity in php
Ideal way of connecting to any database is using mysqlli interface not not using pdo with recent improvement. 
Will add one update for that in coming weeks
```

@TODO
Need more fixes on making it idempotent. This implementation doesn't check for availability of packages and tries to install each time we provision. Need to add unless if /if check's of package availabilty

## Supported Platforms

Ubuntu Xenial (16.04)

#My Host Environment
```t
Vagrant 1.8.5
Chef Development Kit Version: 0.17.17
chef-client version: 12.13.37
delivery version: master (f68e5c5804cd7d8a76c69b926fbb261e1070751b)
berks version: 4.3.5
kitchen version: 1.11.1
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
```

Note:
With new upgrades to ruby functionality of berkshelf has broken hence we need to use berks provided by chef

Berkshelf has issues with >= Ruby 2.3.0
Or Use
/opt/chefdk/bin/berks


## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['myface']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

Goto Directory where you checkout code

vagrant up
Get the ip of vagrant machine and just browse

http://<ip>/index.php




List of some changes made to original code

-Upgrades all below versions in 
```metadata.rb
depends 'apt', '~> 2.9'
depends 'firewall', '~> 2.4'
depends 'apache2', '~> 3.2.2'
depends 'mysql', '~> 8.0'  
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 5.1' 
```
- Upgraded Ubuntu to latest version

```VagrantFile
config.vm.box = 'bento/ubuntu-16.04'
```
-Added platform.rb recipie to take care of new upgrades 


Modified/Added below content in webserver.rb

```Webserver.rb

 For Ubuntu 16.04 and higher php7.0-mysql else php-mysql
package 'php7.0-mysql' do
  action :install
  notifies :restart, 'service[apache2]'
end


execute "Disable MPM Event and Enable Prefork" do
  command "sudo a2dismod mpm_event && sudo a2enmod mpm_prefork && cp /etc/apache2/mods-available/php* /etc/apache2/mods-enabled/ "
  notifies :restart, 'service[apache2]'
end


apache_mod "php7.0"



```




- Had to install some package for mysql to work

```database.rb


package "libmysqlclient-dev" do
  action :install
end

mysql2_chef_gem 'default' do
  action :install
end

```




### myface::default

Include `myface` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[myface::default]"
  ]
}
```


### INSTALLTION Process

```Steps
1  Run sh hostProvision.sh   
	#This will download all libaries from internet and store in local
2  Run

   	 docker pull sameersbn/squid:3.3.8-19
   	   
   	 docker run --name squid -d --restart=always \
 		 --publish 3128:3128 \
  		 --volume /srv/docker/squid/cache:/var/spool/squid3 \
  			sameersbn/squid:3.3.8-19
    Above commands will setup proxy server. This would good as our VM's will start downloading
    lot of libraries over the net and it would slow the provisioning if we have to go to net for 
    each VM. Caching all of them using SQUID will help up speed up provisioning
    
3	Modify Vagrantfile
 Change below proxy configuration to suit your needs
  #Setup Proxy
  # vagrant plugin install vagrant-proxyconf
  config.proxy.http     = "http://10.0.0.175:3128/"
  config.proxy.https    = "http://10.0.0.175:3128/"
  
  # exclude your internal networks, including the Vagrant ones
  config.proxy.no_proxy = "localhost,127.0.0.1,192.168.1.*"

4  Run 
	vagrant up --no-provision     # We need to first get all machines up without provisioning
	vagrant provision            # We need all server's up to configure passwordless authentication

```


### Useful Commands

```
# To start/stop and connect to zookeeper
/usr/local/zookeeper/bin/zkServer.sh start
/usr/local/zookeeper/bin/zkServer.sh stop
/usr/local/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181



# To Start/Stop Kafka
bin/kafka-server-start.sh config/server.properties
bin/kafka-server-stop.sh config/server.properties

-- Testing some topics and data
/usr/local/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic
/usr/local/kafka/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
/usr/local/kafka/bin/kafka-topics.sh --list --zookeeper localhost:2181


# Cassandra Commands

nohup $CASSANDRA_HOME/bin/cassandra &
$CASSANDRA_HOME/bin/nodetool status

# Connect to cassandra on any node
$CASSANDRA_HOME/bin/cqlsh  d1-node-1 9042
$CASSANDRA_HOME/bin/cqlsh  d1-node-2 9042
$CASSANDRA_HOME/bin/cqlsh  d1-node-3 9042

$CASSANDRA_HOME/bin/nodetool -h d1-node-1 enablethrift ; sleep 1

# To Stop Cassandra follow below commands
$CASSANDRA_HOME/bin/nodetool -h d1-node-1 disablethrift ; sleep 1
$CASSANDRA_HOME/bin/nodetool -h d1-node-1 disablebinary ; sleep 1
$CASSANDRA_HOME/bin/nodetool -h d1-node-1 disablegossip ; sleep 20
$CASSANDRA_HOME/bin/nodetool -h d1-node-1 drain



nohup /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties &

```

## License and Authors

Author:: Ashwin Rayaprolu (ashwin.rayaprolu@gmail.com)
