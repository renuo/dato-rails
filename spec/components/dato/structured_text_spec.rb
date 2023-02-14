require "rails_helper"

RSpec.describe Dato::StructuredText, :vcr do
  it "can render without errors" do
    client = Dato::Client.new
    response = client.execute!(homepage_query)
    expect { Dato::StructuredText.new(response.data.homepage.content) }.not_to raise_error
  end
end
