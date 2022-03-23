require "spec_helper"

RSpec.describe "fetch all posts" do
  it "can fetch a list of posts" do
    client = Dato::Client.new
    response = client.execute!(posts_query)
    expect(response.data.allPosts.length).to eq(2)
  end
end
