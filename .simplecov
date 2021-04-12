SimpleCov.start do
  # Paths to be ignored
  add_filter '/config/'
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/lib/'
  add_filter '/vender/'

  # Groups to be tested
  add_group 'Channels',    'app/channels'
  add_group 'Controllers', 'app/controllers'
  # add_group 'Helpers',     'app/helpers' # TODO: Unused, remove?
  add_group 'Jobs',        'app/jobs'
  add_group 'Mailers',     'app/mailers'
  add_group 'Models',      'app/models'
  add_group 'Policies',    'app/policies'
  add_group 'Validators',  'app/validators'
  # add_group 'Views',       'app/views' # TODO: Does testing views make sense?

  # File types to be covered
  track_files '{app}/**/*.{rb}'

  # Require 100% code coverage. (Get rekt scrub)
  SimpleCov.minimum_coverage 100
end
