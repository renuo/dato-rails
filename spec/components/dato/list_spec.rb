require "rails_helper"

RSpec.describe Dato::List, type: :component do
  let(:root_node) { OpenStruct.new({overrides: {}}) }
  subject(:rendered) { render_inline(described_class.new(Hashie::Mash.new(dast_node), root_node)) }

  context "with bulleted list" do
    let(:dast_node) { {type: "list", style: "bulleted"} }

    it "renders as ul in HTML format" do
      is_expected.to have_selector("ul.dato-cms-list")
    end
  end

  context "with numbered list" do
    let(:dast_node) { {type: "list", style: "numbered"} }

    it "renders as ol in HTML format" do
      is_expected.to have_selector("ol.dato-cms-list")
    end
  end

  context "when rendering in markdown format" do
    let(:dast_node) do
      {
        type: "list",
        style: style,
        children: [
          {type: "listItem", children: [{type: "span", value: "First item"}]},
          {type: "listItem", children: [{type: "span", value: "Second item"}]},
          {type: "listItem", children: [{type: "span", value: "Third item"}]}
        ]
      }
    end
    before do
      vc_test_controller.request.format = :md
    end

    context "with bulleted list" do
      let(:style) { "bulleted" }


      it "renders list items with asterisks" do
        output = rendered.to_s
        expect(output).to include("* First item")
        expect(output).to include("* Second item")
        expect(output).to include("* Third item")
      end

      it "adds two newlines at the end of the list" do
        expect(rendered.to_s).to end_with("\n\n")
      end
    end

    context "with numbered list" do
      let(:style) { "numbered" }

      it "renders list items with numbers" do
        output = rendered.to_s
        expect(output).to include("1. First item")
        expect(output).to include("1. Second item")
        expect(output).to include("1. Third item")
      end

      it "adds two newlines at the end of the list" do
        expect(rendered.to_s).to end_with("\n\n")
      end
    end
  end
end
