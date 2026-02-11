source "https://rubygems.org"

ruby "3.3.0"

# Core Rails
gem "rails", "~> 7.1.0"
gem "puma", ">= 5.0"

# Database
gem "mysql2", "~> 0.5"

# Frontend
gem "sprockets-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Authentication
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# HTTP clients for AI/Weather APIs
gem "faraday"
gem "faraday-retry"

# Environment
gem "dotenv-rails", groups: [:development, :test]

# Windows compatibility
gem "tzinfo-data", platforms: %i[windows jruby]

# Performance
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
