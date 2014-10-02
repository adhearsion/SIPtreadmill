ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
include_recipe "openssl"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

connection_info = {
  :host => "127.0.0.1",
  :port => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user 'sip_treadmill' do
  connection connection_info
  password 'super_secret'
  action :create
end

postgresql_database "template1" do
  connection connection_info
  sql "ALTER USER sip_treadmill CREATEDB;"
  action :query
end
