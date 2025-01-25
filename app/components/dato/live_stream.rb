# This component can bring to life your dato components allowing previews and live updates.
# Given that you have a ViewComponent "MyComponent" that renders your page, you can render your page with:
# render(MyComponent.new(data_result_from_dato_query))
# you can now use this wrapper component to do:
# render(Dato::LiveStream.new(MyComponent, query, preview: true)
module Dato
  class LiveStream < ViewComponent::Base
    delegate :turbo_frame_tag, to: :helpers

    attr_reader :component_klass, :query, :preview

    def initialize(component_klass, query, preview: false)
      super()
      @component_klass = component_klass
      @query = query
      @preview = preview
    end

    def data
      @data ||= dato_fetch(query, preview: preview)
    end

    def frame_id
      @frame_id ||= SecureRandom.hex(10)
    end

    private

    def dato_fetch(query, preview: false)
      client = Dato::Client.new(preview: preview, live: true)
      response = client.live!(query)
      response.data
    end
  end
end
