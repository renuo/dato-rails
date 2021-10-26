# This component can bring to life your dato components allowing peviews and live updates.
# Given that you have a component MyComponent that renders your page, you can would render your page with:
# render(MyComponent.new(@data_result_from_dato_query))
# you can now use this wrapper component to do:
# render(Dato::Live.new(MyComponent, query, preview: true, live: true)
module Dato
  class Live < ViewComponent::Base
    delegate :turbo_frame_tag, to: :helpers

    def initialize(component_klass, query, preview: false, live: false)
      @data = dato_fetch(query, preview: preview, live: live)
      @component_klass = component_klass
      @live = live
      @frame_id = SecureRandom.hex(10)
    end

    private

    def dato_fetch(query, preview: false, live: false)
      client = Dato::Client.new(preview: preview, live: live)
      response = live ? client.live!(query) : client.execute!(query)
      response.data
    end
  end
end
