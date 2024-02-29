source 'https://rubygems.org'

# force Bundler to use HTTPS for github repos
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

ruby File.read('.ruby-version').chomp

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 6.1.7'

gem 'active_model_serializers'
gem 'activerecord-session_store'
gem 'algoliasearch'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that the CDN version
# is the same as the Gem version.
gem 'dough-ruby', github: 'moneyadviceservice/dough', branch: 'html-options-fix', ref: 'd59e150'
gem 'geocoder', '~> 1.6.3'
gem 'httpclient', '~> 2.8.3'
gem 'jquery-rails'
gem 'kaminari', '>= 1.2.1'
gem 'language_list', '~> 1.2.1'
gem 'mimemagic', '~> 0.3'
gem 'net-http'
gem 'nokogiri'
gem 'opening_hours'
gem 'pg'
gem 'puma'
gem 'redis', '~> 3.3.5'
gem 'rollbar'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'uk_phone_numbers', '~> 0.1.1'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'spring'
end

group :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'danger', require: false
  gem 'danger-rubocop', require: false
  gem 'faker'
  gem 'poltergeist'
  gem 'site_prism'
  gem 'tzinfo-data'
  gem 'vcr'
  gem 'webmock'
end
