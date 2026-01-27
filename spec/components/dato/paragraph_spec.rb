require "rails_helper"

RSpec.describe Dato::Paragraph, type: :component do
  let(:dast_node) { {type: "paragraph"} }
  let(:root_node) { OpenStruct.new({overrides: {}}) }
  subject(:rendered) { render_inline(described_class.new(Hashie::Mash.new(dast_node), root_node)) }

  it "can render a paragraph" do
    is_expected.to have_selector("div.dato-cms-paragraph")
  end

  context "when it has content" do
    let(:dast_node) {
      {
        type: "paragraph",
        children: [
          {type: "span", value: "Bold Text "},
          {
            type: "link",
            url: "https://www.example.com/",
            children: [{type: "span", value: "Example Link"}]
          },
          {type: "span", value: " Underlined Text"}
        ]
      }
    }

    it "strips whitespaces" do
      expect(rendered.to_html).to eq("<div class=\"dato-cms-paragraph\"><span class=\"dato-cms-span\">Bold Text </span><a href=\"https://www.example.com/\" class=\"dato-cms-link\"><span class=\"dato-cms-span\">Example Link</span></a><span class=\"dato-cms-span\"> Underlined Text</span></div>")
    end
  end
end
