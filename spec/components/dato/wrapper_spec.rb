require "rails_helper"

RSpec.describe Dato::Wrapper, type: :component, vcr: true do
  include ActiveSupport::Testing::TimeHelpers

  let(:dato_client) { Dato::Client.new }

  def render
    render_inline(described_class.new(HomepageComponent, homepage_query))
  end

  before do
    Dato::Cache.clear!
    Dato::Config.cache = true
    allow(Dato::Client).to receive(:new).and_return(dato_client)
  end

  it "can render a simple component and caches it" do
    expect(dato_client).to receive(:execute!).once.and_call_original
    rendered = render
    puts rendered
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
  end

  it "can clear the cache via namespace" do
    expect(dato_client).to receive(:execute!).twice.and_call_original
    rendered = render
    expect(rendered).to have_selector("h1", text: "This is the homepage id: 56302")
    Dato::Cache.clear!
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
