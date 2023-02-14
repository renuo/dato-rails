require "rails_helper"

RSpec.describe Dato::Client, :vcr do
  let(:preview) { false }
  let(:live) { false }
  let(:client) { described_class.new(preview: preview, live: live) }

  it "can execute a query without errors" do
    response = client.execute!(homepage_query)
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
end
