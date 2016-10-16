# This recipe will be used to install kafka

begin

  # Fetch the tarball if it's not a local file
  remote_file '/usr/devenv/share/downloads/kafka_2.11-0.10.0.0.tgz' do
    source 'http://mirrors.ibiblio.org/apache/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz'
  end

  
  tar_extract '/usr/devenv/share/downloads/kafka_2.11-0.10.0.0.tgz' do
    action :extract_local
    target_dir '/usr/local'
    creates '/usr/local/kafka_2.11-0.10.0.0/bin'
  end
  
  link '/usr/local/kafka' do
    to '/usr/local/kafka_2.11-0.10.0.0'
    link_type :symbolic
    owner 'hduser'
    group 'hadoop'
  end

  
  execute "chown-kafka" do
    command "chown -R hduser:hadoop /usr/local/kafka"
    user "root"
    action :nothing
  end
  



rescue StandardError => e
  log "-------Errror- while installing kafka------------" + e.message
end  