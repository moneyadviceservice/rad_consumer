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

gem 'rails', '~> 5.2.4'

gem 'active_model_serializers'
gem 'activerecord-session_store'
gem 'algoliasearch'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that the CDN version
# is the same as the Gem version.
gem 'dough-ruby', github: 'moneyadviceservice/dough', branch: 'PostMessages_v6.2', ref: '4a52cb8'
gem 'geocoder', '~> 1.6.3'
gem 'httpclient', '~> 2.8.3'
gem 'jquery-rails'
gem 'kaminari', '>= 1.2.1'
gem 'language_list', '~> 1.2.1'
gem 'mimemagic', '~> 0.3'
gem 'nokogiri', '1.12.5'
gem 'opening_hours'
gem 'pg', '~> 0.20.0'
gem 'redis', '~> 3.3.5'
gem 'rollbar', '~> 2.15.5'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'uk_phone_numbers', '~> 0.1.1'
gem 'unicorn'

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
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '0.62.0'
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
  gem 'site_prism', '~> 2.17'
  gem 'tzinfo-data'
  gem 'vcr'
  gem 'webmock'
end
