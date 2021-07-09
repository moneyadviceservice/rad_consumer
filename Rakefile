# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake/file_utils'

KARMA_COMMAND = 'node_modules/.bin/karma'.freeze
JSHINT_COMMAND = 'node_modules/.bin/jshint'.freeze

task :npm_test do
  puts 'Running npm test'
  raise 'ERROR: karma is not installed' unless File.exist? KARMA_COMMAND
  raise 'ERROR: JSHint is not installed' unless File.exist? JSHINT_COMMAND
  sh 'npm test'
  puts
end

if Rails.env.production?
  task :default
else
  require 'rubocop/rake_task'
  require 'cucumber/rake/task'

  RuboCop::RakeTask.new
  Cucumber::Rake::Task.new

  task default: %i[cucumber spec rubocop npm_test]
end
