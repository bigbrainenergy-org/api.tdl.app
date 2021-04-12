ENV['RAILS_ENV'] ||= 'test'

require 'byebug'
require 'faker'
require 'simplecov' # Automatically requires .simplecov

# TODO: Remove all instances of `:nocov:`

RSpec.configure do |config|
  ######################
  ## RSpec 4 Defaults ##
  ######################
  # (remove once upgrade to RSpec 4)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  ###################
  ## Setting Flags ##
  ###################

  # Find and reproduce load order dependencies.
  # `rspec --seed <seed>`
  config.order = :random
  Kernel.srand config.seed

  # Allows you to pass the `--only-failures` flag to RSpec.
  config.example_status_persistence_file_path = 'tmp/rspec_example_status.txt'

  # Identify the slowest tests for later optimization.
  # `PROFILING=true rspec`
  # `PROFILING=true PROFILING_COUNT=15 rspec`
  if ENV['PROFILING'] == 'true'
    config.profile_examples =
      if ENV['PROFILING_COUNT'].to_i > 0
        ENV['PROFILING_COUNT'].to_i
      else
        5
      end
  end

  ####################
  ## CI/CD Specific ##
  ####################

  if ENV['CI']
    config.before(:example, :focus) do
      raise 'This example was committed with `:focus` and should not have been'
    end
  end

  #####################
  ## Common Settings ##
  #####################
  # Use color in STDOUT and in pagers and files
  config.color = true
  config.tty = true

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with:
  # `focus: true`
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended.
  config.disable_monkey_patching!

  # Use the verbose formatter by default if you're running only one file.
  config.default_formatter = 'doc' if config.files_to_run.one?
end
