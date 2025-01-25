module Dato
  class Config
    include ActiveSupport::Configurable

    config_accessor(:overrides) { {} }
    config_accessor(:blocks) { {} }
    config_accessor(:cache) { false }
    config_accessor(:cache_namespace) { "dato-rails" }
    config_accessor(:api_token) { ENV.fetch("DATO_API_TOKEN", Rails.application.credentials.dig(:dato, :api_token)) }
    config_accessor(:publish_key) { ENV.fetch("DATO_PUBLISH_KEY", Rails.application.credentials.dig(:dato, :publish_key)) }
    config_accessor(:build_trigger_id) { ENV.fetch("DATO_BUILD_TRIGGER_ID", Rails.application.credentials.dig(:dato, :build_trigger_id)) }
    config_accessor(:mount_path) { "/dato" }
  end
end
