# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be
# available to Rake.

require_relative 'config/application'

if Gem.loaded_specs.has_key?('rubocop-rspec')
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

Rails.application.load_tasks

task default: [:rubocop, :spec] if Gem.loaded_specs.has_key?('rubocop-rspec')
