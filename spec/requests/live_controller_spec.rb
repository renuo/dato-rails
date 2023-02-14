require "rails_helper"

RSpec.describe Dato::LiveController, type: :request do
  it "renders a component with the data in the params" do
    expect_any_instance_of(ActionView::Base).to receive(:turbo_frame_tag) do |_, id, &block|
      block.call
    end
    get dato.live_path, params: {component: "HomepageComponent",
                                 data: {response: {data: {homepage: {id: 123, content: {
                                   value: {schema: "dast", document: {children: []}}
                                 }}}}}.to_json}
    expect(response.body).to include("id: 123")
  end
end
