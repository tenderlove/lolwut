source 'https://rubygems.org'

gem 'rails',     github: 'rails/rails'
gem 'journey',   github: 'rails/journey'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'sqlite3'
gem 'puma'
gem 'redis'
gem 'tusk'
gem 'listen'
gem 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
gem 'rb-fsevent' if RUBY_PLATFORM.downcase.include?("darwin")
gem 'turbolinks', github: 'collin/turbolinks', branch: 'patch-1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',   github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Puts a simple HTTP cache in front of your app.
# For large-scale production use, consider using a caching reverse proxy like nginx, varnish, or squid.
gem 'rack-cache', '~> 1.2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
# gem 'debugger'
