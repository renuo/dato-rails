# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dato::Client, :vcr do
  let(:preview) { false }
  let(:live) { false }
  let(:client) { described_class.new(preview:, live:) }
  let(:item_type_id) { ENV["TEST_MODEL_TYPE_ID"] }

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
    it "can create, update and delete an item" do
      response = client.items.create(attributes: {name: "Hello world"}, item_type_id: item_type_id)
      item_id = response.parse["data"]["id"]
      expect(response.code).to eq(201)

      response = client.items.all(item_type_id: item_type_id)
      expect(response.parse["data"].first["attributes"]["name"]).to eq("Hello world")
      expect(response.code).to eq(200)

      response = client.items.find(item_id: item_id)
      expect(response.parse["data"]["id"]).to eq(item_id)
      expect(response.parse["data"]["attributes"]["name"]).to eq("Hello world")
      expect(response.code).to eq(200)

      response = client.items.update(attributes: {name: "Hello world 2"}, item_id: item_id)
      expect(response.code).to eq(200)

      response = client.items.find(item_id: item_id)
      expect(response.parse["data"]["attributes"]["name"]).to eq("Hello world 2")
      expect(response.code).to eq(200)

      response = client.items.destroy(item_id: item_id)
      expect(response.code).to eq(202)

      response = client.items.find(item_id: item_id)
      expect(response.code).to eq(404)
    end
  end

  describe "upload" do
    it "can upload image from url" do
      result = client.uploads.create_from_url("https://picsum.photos/seed/picsum/200/300", filename: "picsum.png")
      expect(result).to eq({job_id: "bbe064102bf8fa9ecb528a9c"})
    end

    it "can upload image from local file" do
      file_path = Rails.root.join("images", "renuo.svg")
      result = client.uploads.create_from_file(file_path, filename: "renuo.svg")
      expect(result).to eq({job_id: "0b432c23e0afca0f666e93c8"})
    end

    it "can upload image to a cms model" do
      file_path = Rails.root.join("images", "renuo.svg")
      job_id = client.uploads.create_from_file(file_path, filename: "renuo.svg")[:job_id]

      response = nil

      10.times do
        response = client.uploads.retrieve_job_result(job_id).parse
        break if response["data"]["attributes"].present?
        sleep 1
      end

      upload_id = response["data"]["attributes"]["payload"]["data"]["id"]

      response = client.items.create(attributes: {name: "Hello world", picture: {upload_id:}}, item_type_id:)
      expect(response.code).to eq(201)
      item_id = response.parse["data"]["id"]
      response = client.items.find(item_id:)

      expect(response.code).to eq(200)
      expect(response.parse["data"]["attributes"]["picture"]["upload_id"]).to eq(upload_id)
    end
  end
end
