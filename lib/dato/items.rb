module Dato
  class Items
    BASE_ITEM_URL = "https://site-api.datocms.com/items"

    def initialize(api_token)
      @http_headers = HTTP.headers({"Authorization" => "Bearer #{api_token}",
                                     "Accept" => "application/json",
                                     "X-Api-Version" => 3})
    end

    def find(item_id:)
      @http_headers.get("#{BASE_ITEM_URL}/#{item_id}")
    end

    def all(item_type_id:)
      @http_headers.get("#{BASE_ITEM_URL}?filter[type]=#{item_type_id}")
    end

    def create(item_type_id:, attributes:, meta: nil)
      data = create_attributes(attributes, item_type_id)
      data[:meta] = meta if meta
      @http_headers.post(BASE_ITEM_URL, json: {data: data})
    end

    def update(attributes:, item_id:)
      data = {type: "item", attributes: attributes, id: item_id}
      @http_headers.put("#{BASE_ITEM_URL}/#{item_id}", json: {data: data})
    end

    def destroy(item_id:)
      @http_headers.delete("#{BASE_ITEM_URL}/#{item_id}")
    end

    private

    def create_attributes(attributes, item_type_id)
      {
        type: "item",
        attributes: attributes,
        relationships: {
          item_type: {data: {type: "item_type", id: item_type_id}}
        }
      }
    end
  end
end
