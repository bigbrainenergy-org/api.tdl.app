source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

################
## Base Rails ##
################

# moving to ruby 3.1.3 starts bugging me about this
gem 'net-smtp'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

##########################
## Application Specific ##
##########################

# API Documentation via OpenAPI 3.0
gem 'rswag-api'
gem 'rswag-ui'

# Authentication via Sorcery
gem 'sorcery-core',
  github: 'Sorcery/sorcery-rework',
  glob:   'sorcery-core/sorcery-core.gemspec'
gem 'sorcery-jwt',
  github: 'Sorcery/sorcery-rework',
  glob:   'sorcery-jwt/sorcery-jwt.gemspec'

# Authorization via Pundit
gem 'pundit'

# Password Hashing
gem 'sorcery-argon2'

# Bot prevention
gem 'recaptcha'

##########################
## Environment Specific ##
##########################

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker' # So faker can be used for both test data and development seeds
  gem 'i18n-tasks'
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop-athix'
  gem 'rubocop-i18n'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'

  # Prevent parser from yelling at us about mismatched ruby versions
  gem 'parser', '~> 3.2.1.0'
end

group :development do
  gem 'listen'
  gem 'spring'
end

group :test do
  gem 'pundit-matchers'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'validator-matchers'
end
