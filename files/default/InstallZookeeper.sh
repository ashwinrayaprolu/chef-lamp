sed -i "s/#\!\/usr\/bin\/env bash/#\!\/bin\/bash/g" /usr/local/zookeeper/bin/zkEnv.sh
sudo chown -R hduser:hadoop /usr/local/zookeeper/
sudo chown -R hduser:hadoop /var/lib/zookeeper/