module Dato
  module Railties
    module ControllerRuntime
      extend ActiveSupport::Concern

      def execute_dato_query(query, preview: false)
        client = Dato::Client.new(preview: preview)
        if preview
          return client.execute!(query)
        end

        key = "#{Digest::MD5.hexdigest(query.to_gql)}-query"
        Dato::Cache.fetch(key) do
          client.execute!(query)
        end
      end

      module ClassMethods # :nodoc:
        def log_process_action(payload)
          messages = super
          Dato::CurrentRequest.dato_runtime ||= 0
          messages << ("Dato: %.1fms" % Dato::CurrentRequest.dato_runtime)
          messages
        end
      end
    end
  end
end