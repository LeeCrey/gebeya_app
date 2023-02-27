# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "rails", "~> 7.0.4"
gem "puma", "~> 5.0"
gem "pg", "~> 1.4"

gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "sassc-rails"

gem "active_storage_validations"
gem "active_model_serializers", "~> 0.10.13"
gem "counter_culture", "~> 3.2"

gem "redis", "~> 4.0"
gem "sidekiq", "~> 7.0"
gem "devise"
gem "devise-jwt"

gem "activeadmin"
gem "acts_as_votable"
gem "image_processing", "~> 1.2"
# gem "quick_random_records"
# gem "chartkick"
# gem "groupdate"

# gem "aws-sdk"
gem "aws-sdk-s3", require: false
gem "fx", "~> 0.7.0"
gem "sendgrid-actionmailer"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # gem "debug", platforms: %i[mri mingw x64_mingw]
  # gem "bullet"
  # gem "figaro", "~> 1.2"
end

group :development do
  gem "web-console"
end

group :test do
  gem "letter_opener"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
  gem "database_cleaner"
end
