# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.4.3'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.5', '>= 7.1.5.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
gem 'pg_partition_manager'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'aasm'
gem 'dotenv-rails'
gem 'money-rails'
gem 'oj'
gem 'prime'
gem 'sidekiq'

group :development, :test do
  gem 'awesome_print'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'

  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec-sidekiq', require: false

  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-thread_safety', require: false
end

group :test do
  gem 'json_matchers'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers', require: false
  gem 'super_diff'
end
