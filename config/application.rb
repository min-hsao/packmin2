require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Packmin2
  class Application < Rails::Application
    config.load_defaults 7.1
    
    # Auto-load lib directory
    config.autoload_lib(ignore: %w(assets tasks))
    
    # Time zone
    config.time_zone = "Pacific Time (US & Canada)"
    
    # Generators
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
