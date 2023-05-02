module Dato
  class Client
    delegate :live!, :execute!, :execute, to: :@gql
    attr_reader :items, :gql

    def initialize(api_token = Dato::Config.api_token, validate_query: false, preview: false, live: false)
      @api_token = api_token
      @gql = Dato::Gql.new(api_token, validate_query, preview, live)
      @items = Dato::Items.new(api_token)
    end
  end
end
