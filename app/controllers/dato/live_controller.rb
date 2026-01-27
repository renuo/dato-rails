module Dato
  class LiveController < ActionController::Base
    def create
      @data = Hashie::Mash.new(JSON.parse(params[:data], symbolize_names: true).dig(:response, :data))
      # Ensure HTML format is available for ViewComponent template resolution
      # ViewComponent 4 requires explicit format matching
      lookup_context.formats |= [:html]
    end
  end
end
