source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false

gem 'acts_as_list'
gem 'bcrypt'
gem 'cancancan'
gem 'carrierwave'
gem 'jwt'
gem 'mini_magick'
gem 'apipie-rails'
gem 'active_model_serializers'
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'ffaker'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'simplecov-lcov'
  gem 'shoulda-matchers'
  gem 'undercover'
  gem 'json_matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'brakeman'
  gem 'fasterer'
  gem 'overcommit'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
