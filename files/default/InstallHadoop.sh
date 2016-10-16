sudo rm -rf /usr/local/hadoop* &&
sudo tar -xvzf /usr/devenv/share/downloads/hadoop-2.7.3.tar.gz -C /usr/local/ &&
cd /usr/local/ &&
sudo ln -s /usr/local/hadoop-2.7.3 /usr/local/hadoop &&
sudo chown -R hduser:hadoop /usr/local/hadoop/ &&
apt-get -y install liblzo2-2 liblzo2-dev &&
apt-get -y install rsync ssh &&
runuser -l hduser -c "mkdir -p /home/hduser/hadoopinfra/hdfs/datanode" &&
runuser -l hduser -c "mkdir -p /home/hduser/hadoopinfra/hdfs/namenode" &&
sed -i "s/\${JAVA_HOME}/\/usr\/lib\/jvm\/java-8-oracle-amd64/g" /usr/local/hadoop/etc/hadoop/hadoop-env.sh &&
chown  hduser:hadoop /usr/local/hadoop/etc/hadoop/hadoop-env.sh