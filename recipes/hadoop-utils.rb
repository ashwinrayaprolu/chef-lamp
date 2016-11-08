# This recipe will be used to install kafka

begin

  # Fetch the tarball if it's not a local file
  remote_file '/usr/devenv/share/downloads/pig-0.16.0.tar.gz' do
    source 'http://www-us.apache.org/dist/pig/pig-0.16.0/pig-0.16.0.tar.gz'
  end
  
  remote_file '/usr/devenv/share/downloads/mysql-connector-java-5.1.40.tar.gz' do
    source 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz'
  end
  
  remote_file '/usr/devenv/share/downloads/scala-2.12.0.tgz' do
    source 'http://downloads.lightbend.com/scala/2.12.0/scala-2.12.0.tgz'
  end
  
  
  remote_file '/usr/devenv/share/downloads/spark-2.0.1-bin-hadoop2.7.tgz' do
    source 'http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz'
  end  
  
  remote_file '/usr/devenv/share/downloads/solr-6.2.1.tgz' do
    source 'http://www-us.apache.org/dist/lucene/solr/6.2.1/solr-6.2.1.tgz'
  end   
  
  
  
  tar_extract '/usr/devenv/share/downloads/mysql-connector-java-5.1.40.tar.gz' do
    action :extract_local
    target_dir '/usr/local/lib'
    creates '/usr/local/lib/mysql-connector-java-5.1.40'
  end

  
  tar_extract '/usr/devenv/share/downloads/pig-0.16.0.tar.gz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/pig-0.16.0'
  end
  
  tar_extract '/usr/devenv/share/downloads/solr-6.2.1.tgz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/solr-6.2.1'
  end  
  
  
  
  
  tar_extract '/usr/devenv/share/downloads/scala-2.12.0.tgz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/scala-2.12.0'
  end
  
  
  tar_extract '/usr/devenv/share/downloads/spark-2.0.1-bin-hadoop2.7.tgz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/spark-2.0.1-bin-hadoop2.7'
  end
    
  
  remote_file "Copy MySQLConnector file" do 
    path "/usr/local/hadoop/lib/mysql-connector-java-5.1.40-bin.jar" 
    source "file:///usr/local/lib/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar"
    owner 'hduser'
    group 'hadoop'
    mode 0755
  end
  
  link '/usr/local/pig' do
    to '/usr/local/pig-0.16.0'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end
  
  link '/usr/local/scala' do
    to '/usr/local/scala-2.12.0'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end  
  
  link '/usr/local/spark' do
    to '/usr/local/spark-2.0.1-bin-hadoop2.7'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end 
  
  
  link '/usr/local/solr' do
    to '/usr/local/solr-6.2.1'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end   
  
  
  
  remote_file "Copy Spark Env file" do 
    path "/usr/local/spark/conf/spark-env.sh" 
    source "file:///usr/local/spark/conf/spark-env.sh.template"
    owner 'hduser'
    group 'hadoop'
    mode 0755
  end  
  
  
  remote_file "Copy Spark Defaults Conf file" do 
    path "/usr/local/spark/conf/spark-defaults.conf" 
    source "file:///usr/local/spark/conf/spark-defaults.conf.template"
    owner 'hduser'
    group 'hadoop'
    mode 0755
  end    
  
  
  ruby_block "insert Hadoop Spark Env" do
    block do
      file = Chef::Util::FileEdit.new("/usr/local/spark/conf/spark-env.sh")
      file.insert_line_if_no_match("/HADOOP_HOME/", "HADOOP_CONF_DIR=$HADOOP_HOME/conf")
      file.insert_line_if_no_match("/HadoopMaster/", "SPARK_MASTER_HOST=HadoopMaster")
      file.write_file
    end
  end 
  
  
  
    
  execute "chown-pig" do
    command "chown -R hduser:hadoop /usr/local/pig"
    user "root"
    action :nothing
  end
  
  

rescue StandardError => e
  log "-------Errror- while installing pig------------" + e.message
end  