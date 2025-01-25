module Dato
  class Wrapper < ViewComponent::Base
    attr_reader :component_klass, :query, :data, :preview, :live

    def initialize(component_klass, query, preview: false, live: false)
      @component_klass = component_klass
      @query = query
      @preview = preview
      @live = live
    end

    def live? = @live

    def render_in(view_context)
      if live?
        LiveStream.new(component_klass, query, preview: preview).render_in(view_context)
      else
        super
      end
    end

    def data
      @data ||= dato_fetch(query, preview: preview)
    end

    def cache_key
      @cache_key ||= Digest::MD5.hexdigest(query.to_gql)
    end

    private

    def dato_fetch(query, preview: false)
      client = Dato::Client.new(preview: preview)
      response = client.execute!(query)
      response.data
    end
  end
end
