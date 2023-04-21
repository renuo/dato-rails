module Dato
  class Cache
    def self.fetch(cache_key, &block)
      if active?
        Rails.cache.fetch(cache_key, expires_in: expires_in, namespace: namespace) do
          block.call
        end
      else
        block.call
      end
    end

    def self.active?
      Dato::Config.cache.present?
    end

    def self.expires_in
      Dato::Config.cache.is_a?(Integer) ? Dato::Config.cache : 60.minutes
    end

    def self.namespace
      Dato::Config.cache_namespace
    end
  end
end
