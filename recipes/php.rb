
# Write pho shell script file to filesystem
cookbook_file node['myface']['install']['php'] do
  source 'InstallPHP.sh'
  owner 'root'
  group 'root'
  mode '0655'
end


#add-apt-repository -y ppa:ondrej/php5-5.6 &&
#apt install php5.6 

execute "InstallPHP" do
  user "root"
  cwd "/tmp"
  command "sh InstallPHP.sh"
end




#package ['php5.6','libapache2-mod-php5.6','php5.6-curl','php5.6-gd','php5.6-mbstring','php5.6-mcrypt','php5.6-mysql','php5.6-xml','php5.6-xmlrpc'] do
package ['php7.0','php-pear','libapache2-mod-php7.0','php7.0-mysql','php7.0-curl','php7.0-json','php7.0-cgi'] do
  action :install
end
