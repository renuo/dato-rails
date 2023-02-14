module Dato
  class Config
    include ActiveSupport::Configurable

    config_accessor(:overrides) { {} }
    config_accessor(:blocks) { {} }
    config_accessor(:cache) { false }
    config_accessor(:cache_namespace) { "dato-rails" }
    config_accessor(:publish_key) { ENV["DATO_PUBLISH_KEY"] }
    config_accessor(:build_triggger_id) { ENV["DATO_BUILD_TRIGGER_ID"] }
  end
end
