source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'devise'
gem 'omniauth', '~> 1.0'
gem 'omniauth-att', github: 'att-innovate/omniauth-att'
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

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  # gem 'bootstrap-sass', '~> 2.3.2.0'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-datatables-rails'
gem 'classy_enum'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

gem 'sippy_cup', github: "mojolingo/sippy_cup", branch: "develop"
gem 'net-ssh'

group :development do
  # To use debugger
  # gem 'debugger'
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
end
