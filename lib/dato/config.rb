module Dato
  class Config
    class_attribute :overrides, default: {}
    class_attribute :links_mapping, default: {}
    class_attribute :blocks, default: {}
    class_attribute :cache, default: false
    class_attribute :cache_namespace, default: "dato-rails"
    class_attribute :api_token, default: ENV.fetch("DATO_API_TOKEN", Rails.application.credentials.dig(:dato, :api_token))
    class_attribute :publish_key, default: ENV.fetch("DATO_PUBLISH_KEY", Rails.application.credentials.dig(:dato, :publish_key))
    class_attribute :build_trigger_id, default: ENV.fetch("DATO_BUILD_TRIGGER_ID", Rails.application.credentials.dig(:dato, :build_trigger_id))
    class_attribute :base_editing_url, default: ENV.fetch("DATO_BASE_EDITING_URL", Rails.application.credentials.dig(:dato, :base_editing_url))
    class_attribute :mount_path, default: "/dato"

    def self.configure
      yield self
    end
  end
end
