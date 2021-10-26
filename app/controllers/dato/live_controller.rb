module Dato
  class LiveController < ActionController::Base
    def show
      @data = Hashie::Mash.new(JSON.parse(params[:data], symbolize_names: true).dig(:response, :data))
    end
  end
end
