require "rails_helper"

RSpec.describe Dato::PublishController, type: :request, vcr: true do
  include ViewComponent::TestHelpers

  let(:dato_client) { Dato::Client.new }

  def render
    render_inline(Dato::Wrapper.new(HomepageComponent, homepage_query))
  end

  before do
    Dato::Cache.clear!
    Dato::Config.cache = true
    allow(Dato::Client).to receive(:new).and_return(dato_client)
  end

  it "expires all caches" do
    expect(dato_client).to receive(:execute!).twice.and_call_original
    render
    post dato.publish_path, headers: {"Authorization" => Dato::Config.publish_key}
    render
  end

  it "cannot be accessed with a wrong publish key" do
    Dato::Config.publish_key = "a"
    post dato.publish_path, headers: {"Authorization" => "b"}
    expect(response).to have_http_status(:unauthorized)
  end
end
