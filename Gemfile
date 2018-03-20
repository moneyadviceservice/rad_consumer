source 'https://rubygems.org'

ruby '2.2.2'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 4.2.10'

gem 'active_model_serializers', '~> 0.10.7'
gem 'activerecord-session_store'
gem 'autoprefixer-rails'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that the CDN version
# is the same as the Gem version.
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    tag: 'v5.25.3.296'
gem 'geocoder'
gem 'kaminari'
gem 'mas-rad_core', '~> 0.1.5'
gem 'pg', '< 1.0'
gem 'rollbar', '~> 2.15.5'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

group :assets do
  gem 'jquery-rails'
  gem 'sass-rails'
end

group :development, :test do
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rspec-rails', '3.6.0'
  gem 'rubocop'
  gem 'site_prism'
  gem 'spring', '1.3.6'
end

group :test do
  gem 'faker'
  gem 'vcr'
  gem 'webmock'
end
