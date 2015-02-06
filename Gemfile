source 'https://rubygems.org'

ruby '2.2.0'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '4.2.0'

gem 'pg'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

group :assets do
  gem 'sass-rails'
  gem 'jquery-rails'
end

group :development, :test do
  gem 'guard', require: false
  gem 'guard-livereload', require: false
  gem 'guard-rails', require: false
  gem 'rack-livereload'
  gem 'spring'
end
