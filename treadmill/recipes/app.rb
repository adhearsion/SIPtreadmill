include_recipe "sudo"
include_recipe "sipp"

rvm_user = 'vagrant'

gnupg_dir       = "/home/#{rvm_user}/.gnupg"
gnupg_dir_user  = "chown -R #{rvm_user}:#{rvm_user} #{gnupg_dir};"
gnupg_dir_root  = "if [ -d #{gnupg_dir} ]; then chown -R root:root #{gnupg_dir}; fi;"
gnupg_cmd       = "`which gpg2 || which gpg` --keyserver hkp://keys.gnupg.net --recv-keys #{node['rvm']['gpg_key']};"

execute "Adding gpg key to #{rvm_user}" do
  environment ({"HOME" => "/home/#{rvm_user}"})
  command "#{gnupg_dir_root} #{gnupg_cmd} #{gnupg_dir_user}"
  not_if { node['rvm']['gpg_key'].empty? }
  returns 0
end

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
