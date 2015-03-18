source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '3.2.19'
gem 'devise'
gem 'omniauth', '~> 1.0'
gem 'omniauth-att', github: 'att-innovate/omniauth-att'
gem 'omniauth-github', '~> 1.1'
gem 'haml'
gem 'simple_form'
gem 'carrierwave'
gem 'fog'
gem 'airbrake'
gem 'kaminari'
gem 'bourbon'
gem 'state_machine'
gem 'cancan'

# Sidekiq and monitoring
gem 'sidekiq'
gem 'slim', '>= 1.1.0'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'pg'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'
gem 'jquery-datatables-rails'
gem 'classy_enum'

gem 'thin'

gem 'sippy_cup', '~> 0.6.0'
gem 'net-ssh'

gem 'rails_12factor'

group :development do
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner', '1.0.1'
  gem 'capybara'
  gem 'poltergeist'
  gem 'fakefs', :require => 'fakefs/safe'
  gem 'quiet_assets'
  gem 'foreman'
  gem 'countdownlatch'
end

group :test do
  gem 'webmock'
  gem 'timecop'
  gem 'minitest'
  gem 'test-unit'
end
