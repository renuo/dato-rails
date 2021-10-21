require "rails_helper"

# the query relies on a homepage component with a content where there are all possible things
RSpec.describe "a simple query to retrieve the homepage" do
  it "can execute a query without errors" do
    client = Dato::Client.new
    response = client.execute!(homepage_query)
    puts response.data
    expect(response.data.homepage.id).to be_present
  end
end
