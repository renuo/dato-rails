module Dato
  class Engine < ::Rails::Engine
    isolate_namespace Dato

    initializer "dato_rails.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include Dato::Railties::ControllerRuntime
      end

      ActiveSupport::Notifications.subscribe("dato.query_execution") do |_, start, finish, _, _payload|
        Dato::CurrentRequest.dato_runtime ||= 0
        Dato::CurrentRequest.dato_runtime += (finish - start) * 1000
      end
    end

    initializer "dato_rails.configuration" do |app|
      if Dato::Config.mount_path
        app.routes.append do
          mount Dato::Engine => Dato::Config.mount_path
        end
      end
    end
  end
end
