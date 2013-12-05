include_recipe "sudo"
include_recipe "sipp"
include_recipe "rvm::user"
include_recipe "redis::server"
include_recipe "postgresql::client"

execute "prepare database config" do
  command "cp config/database.yml.sample config/database.yml"
  cwd "/srv/treadmill/current"
  user 'vagrant'
  action :run
end

rvm_shell "install gem deps" do
  code "bundle install"
  cwd "/srv/treadmill/current"
  user 'vagrant'
  environment 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 'true'
  action :run
end

rvm_shell "setup database" do
  code "rake db:setup"
  cwd "/srv/treadmill/current"
  user 'vagrant'
  action :run
end
