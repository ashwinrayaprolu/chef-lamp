sudo rm -rf /usr/local/hadoop* &&
sudo tar -xvzf /tmp/hadoop-2.7.3.tar.gz -C /usr/local/ &&
cd /usr/local/ &&
sudo ln -s /usr/local/hadoop-2.7.3 /usr/local/hadoop &&
sudo chown -R hduser:hadoop /usr/local/hadoop &&
apt-get -y install liblzo2-2 liblzo2-dev &&
apt-get -y install rsync ssh
