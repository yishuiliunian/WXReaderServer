require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WXReadServer
  class Application < Rails::Application
    config.paths.add "app/api", glob:"**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
  end
end
