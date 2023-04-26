module Dato
  class Client
    delegate :live!, to: :@gql_client
    delegate :execute!, to: :@gql_client
    attr_reader :items

    def initialize(api_token = Dato::Config.api_token, validate_query: false, preview: false, live: false)
      @api_token = api_token
      @gql_client = Dato::Gql.new(api_token, validate_query, preview, live)
      @items = Dato::Items.new(api_token)
    end
  end
end
