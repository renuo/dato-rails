# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dato::Client, :vcr do
  let(:preview) { false }
  let(:live) { false }
  let(:client) { described_class.new(preview:, live:) }

  it "can execute a query without errors" do
    response = client.execute!(homepage_query)
    expect(response.data.homepage.id).to be_present

    response = client.execute(homepage_query)
    expect(response.data.homepage.id).to be_present

    response = client.gql.execute!(homepage_query)
    expect(response.data.homepage.id).to be_present
  end

  context "when preview is true" do
    let(:preview) { true }

    it "can execute a query without errors" do
      response = client.execute!(homepage_query)
      expect(response.data.homepage.id).to be_present
    end
  end

  context "when live is true" do
    let(:live) { true }

    it "can execute a query without errors" do
      response = client.live!(homepage_query)
      expect(response.data.url).to be_present
    end
  end

  describe "CRUD operations" do
    let(:item_type_id) { "4404" }
    it "can create, update and delete an item" do
      response = client.items.create(attributes: {title: "Hello world"}, item_type_id: item_type_id)
      item_id = response.parse["data"]["id"]
      expect(response.code).to eq(201)

      response = client.items.all(item_type_id: item_type_id)
      expect(response.parse["data"].last["attributes"]["title"]).to eq("Hello world")
      expect(response.code).to eq(200)

      response = client.items.find(item_id: item_id)
      expect(response.parse["data"]["id"]).to eq(item_id)
      expect(response.parse["data"]["attributes"]["title"]).to eq("Hello world")
      expect(response.code).to eq(200)

      response = client.items.update(attributes: {title: "Hello world 2"}, item_id: item_id)
      expect(response.code).to eq(200)

      response = client.items.find(item_id: item_id)
      expect(response.parse["data"]["attributes"]["title"]).to eq("Hello world 2")
      expect(response.code).to eq(200)

      response = client.items.destroy(item_id: item_id)
      expect(response.code).to eq(202)

      response = client.items.find(item_id: item_id)
      expect(response.code).to eq(404)
    end
  end

  describe "upload" do
    it "can upload an image" do
      response = client.uploads.create_from_url("https://upload.wikimedia.org/wikipedia/commons/4/4f/SVG_Logo.svg")
      expect(response.code).to eq(200)
    end
  end
end
