require "rails_helper"

RSpec.describe Dato::LiveController, type: :request do
  it "renders a component with the data in the params" do
    post dato.live_path, params: {component: "HomepageComponent",
                                  data: {response: {data: {homepage: {id: 123, content: {
                                    value: {schema: "dast", document: {children: []}}
                                  }}}}}.to_json},
      headers: {"Accept" => "text/vnd.turbo-stream.html"}
    expect(response.body).to include("turbo-stream")
    expect(response.body).to include("homepage id: 123")
  end
end
