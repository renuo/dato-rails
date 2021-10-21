module Dato
  class Config
    include ActiveSupport::Configurable

    config_accessor(:overrides) { {} }
    config_accessor(:blocks) { {} }
  end
end
