require_relative "boot"

require "action_controller/railtie"
require "action_view/railtie"
require "active_support/core_ext"

Bundler.require(*Rails.groups)

require "turbo-rails"
require "dato"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    config.action_controller.include_all_helpers = false

    # Register markdown as a valid MIME type for template resolution
    config.after_initialize do
      Mime::Type.register "text/markdown", :md
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
