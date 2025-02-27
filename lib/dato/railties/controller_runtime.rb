module Dato
  module Railties
    module ControllerRuntime
      extend ActiveSupport::Concern

      def execute_dato_query(query, preview: false)
        client = Dato::Client.new(preview: preview)
        return client.execute!(query) if preview

        key = "#{Digest::MD5.hexdigest(query.to_gql)}-query-#{preview}"
        Dato::Cache.fetch(key) do
          client.execute!(query)
        end
      end

      def execute_dato_query!(query, preview: false)
        response = execute_dato_query(query, preview: preview)
        raise(InvalidGraphqlQuery, response.errors.first.message) if response.errors&.any?

        response
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
