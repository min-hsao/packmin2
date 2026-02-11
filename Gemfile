source "https://rubygems.org"

ruby "3.3.0"

# Rails
gem "rails", "~> 7.1.3"
gem "pg", "~> 1.5"           # PostgreSQL
gem "puma", "~> 6.4"         # Web server
gem "sprockets-rails"        # Asset pipeline
gem "importmap-rails"        # JavaScript with ESM
gem "turbo-rails"            # Hotwire Turbo
gem "stimulus-rails"         # Hotwire Stimulus
gem "tailwindcss-rails"      # Tailwind CSS
gem "jbuilder"               # JSON APIs

# Authentication
gem "devise", "~> 4.9"
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-rails_csrf_protection"

# Security
gem "bcrypt", "~> 3.1"

# HTTP client for AI APIs
gem "faraday", "~> 2.9"
gem "faraday-retry"

# Environment variables
gem "dotenv-rails", groups: [:development, :test]

# Boot speed
gem "bootsnap", require: false

# Timezone data for Windows
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
