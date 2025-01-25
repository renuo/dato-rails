module Dato
  class Client
    delegate :live!, to: :@gql
    attr_reader :items, :uploads, :gql

    def initialize(api_token = Dato::Config.api_token, validate_query: false, preview: false, live: false)
      @api_token = api_token
      @gql = Dato::Gql.new(api_token, validate_query, preview, live)
      @items = Dato::Items.new(api_token)
      @uploads = Dato::Uploads.new(api_token)
    end

    def execute!(query)
      ActiveSupport::Notifications.instrument("dato.query_execution") do
        @gql.execute!(query)
      end
    end

    def execute(query)
      @gql.execute(query)
    end
  end
end
