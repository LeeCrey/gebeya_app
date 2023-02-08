# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "rails", "~> 7.0.4"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "pg", "~> 1.4"

gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "redis", "~> 4.0"
gem "devise"
gem "devise-jwt"
gem "active_storage_validations"
gem "active_model_serializers", "~> 0.10.13"
gem "activeadmin"
# gem "ransack"
gem "acts_as_votable"
gem "fx", "~> 0.7.0"
gem "quick_random_records"

gem "aws-sdk"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "sassc-rails"
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "bullet"
end

group :development do
  gem "letter_opener", "~> 1.8", ">= 1.8.1"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
