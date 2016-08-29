override['apt']['compile_time_update'] = true


default['myface']['user'] = 'myface'
default['myface']['group'] = 'myface'
  
default['myface']['name'] = 'myface'
default['myface']['config'] = 'myface.conf'
default['myface']['document_root'] = '/srv/apache/myface' 
  
  
default['myface']['database']['name'] = 'myface'
default['myface']['database']['host'] = '127.0.0.1'
default['myface']['database']['username'] = 'root'
default['myface']['database']['password'] = node['mysql']['server_root_password']
default['myface']['database']['dbname'] = 'myface'
  
default['myface']['database']['app']['username'] = 'myface_app'
default['myface']['database']['app']['password'] = 'supersecret'
  

  
  
default['myface']['database']['seed_file'] = '/tmp/myface-create.sql'   
  
default['myface']['install']['php']='/tmp/InstallPHP.sh'   