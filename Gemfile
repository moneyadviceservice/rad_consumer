source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 4.2.10'

gem 'active_model_serializers', '~> 0.10.7'
gem 'activerecord-session_store'
gem 'algoliasearch'
gem 'autoprefixer-rails'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that the CDN version
# is the same as the Gem version.
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    tag: 'v5.30.5.327'
gem 'geocoder', '~> 1.4.7'
gem 'httpclient', '~> 2.8.3'
gem 'kaminari'
gem 'language_list', '~> 1.2.1'
gem 'opening_hours'
gem 'pg', '~> 0.20.0'
gem 'redis', '~> 3.3.5'
gem 'rollbar', '~> 2.15.5'
gem 'uglifier', '>= 1.3.0'
gem 'uk_phone_numbers', '~> 0.1.1'
gem 'unicorn'

group :assets do
  gem 'jquery-rails'
  gem 'sass-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '0.62.0'
  gem 'spring', '1.3.6'
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
