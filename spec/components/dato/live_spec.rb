require "rails_helper"

RSpec.describe Dato::Live, type: :component, vcr: true do
  include ActiveSupport::Testing::TimeHelpers

  let(:dato_client) { Dato::Client.new }

  def render
    render_inline(Dato::Live.new(HomepageComponent, homepage_query))
  end

  before do
    Rails.cache.clear(namespace: "dato-cms")
    Dato::Config.cache = true
    allow(Dato::Client).to receive(:new).and_return(dato_client)
  end

  it "can render a simple component and caches it" do
    expect(dato_client).to receive(:execute!).once.and_call_original
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
  end

  it "can clear the cache via namespace" do
    expect(dato_client).to receive(:execute!).twice.and_call_original
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
    Rails.cache.clear(namespace: "dato-cms")
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
  end

  it "is much faster to render the second time" do
    expect(dato_client).to receive(:execute!).once.and_call_original
    first_time = Benchmark.realtime { render }
    second_time = Benchmark.realtime { render }
    expect(second_time * 4).to be < first_time
  end
end
