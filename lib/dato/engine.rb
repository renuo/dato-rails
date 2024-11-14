module Dato
  class Engine < ::Rails::Engine
    isolate_namespace Dato

    initializer 'dato_rails.action_controller' do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.class_eval do
          def execute_query(query, preview: false)
            client = Dato::Client.new(preview: preview)
            if preview
              return client.execute!(query)
            end

            key = "#{Digest::MD5.hexdigest(query.to_gql)}-query"
            Dato::Cache.fetch(key) do
              client.execute!(query)
            end
          end
        end
      end
    end
  end
end
