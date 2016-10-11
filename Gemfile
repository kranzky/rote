source 'https://rubygems.org'

# Language
ruby '2.3.1'
gem 'require_all', '~> 1.3.3'

# Rack Server
gem 'puma', '~> 3.6.0'

# HTTP Framework
gem 'sinatra', '~> 2.0.0.beta2'
gem 'sinatra-contrib', '~> 2.0.0.beta2'
#gem 'request_store', '~> 1.3.1'

# ORM
gem 'sequel', '~> 4.39.0'

# Database
gem 'pg', '~> 0.19.0'
gem 'sequel_pg', '~> 1.6.17', require: false

# Authentication
#gem 'omniauth', '~> 1.3.1'

# Authorisation
gem 'pundit', '~> 1.1.0'

# Email
#gem 'sendgrid', '~> 1.2.4'

# Background Jobs
#gem 'sidekiq', '~> 4.2.2'

# Logging
gem 'semantic_logger', '~> 3.3.0'

# Templating Engine
gem 'hamlit', '~> 2.7.2'

# JSON Rendering
gem 'jbuilder', '~> 2.6.0'
gem 'yajl-ruby', '~> 1.2.1'
gem 'tilt-jbuilder', '~> 0.7.1', require: 'sinatra/jbuilder'

group :development do
  gem 'github_changelog_generator', '~> 1.13.2'
  gem 'gemfile_updater', '~> 0.1.0'
end

group :test do
  gem 'rspec', '~> 3.5.0'
end

group :development, :test do
  gem 'awesome_print', '~> 1.7.0'
  gem 'byebug', '~> 9.0.6'
end

group :production do
end
