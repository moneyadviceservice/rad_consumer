source 'https://rubygems.org'

ruby '2.2.2'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 4.2'

gem 'active_model_serializers'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    ref: 'cf08913'
gem 'geocoder'
gem 'kaminari'
gem 'mas-rad_core', '0.0.89'
gem 'pg'
gem 'rollbar'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'autoprefixer-rails'

group :assets do
  gem 'jquery-rails'
  gem 'sass-rails'
end

group :development, :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'site_prism'
  gem 'spring'
  gem 'dotenv-rails'
end

group :test do
  gem 'faker'
  gem 'vcr'
  gem 'webmock'
end
