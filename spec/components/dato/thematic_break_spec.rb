require "rails_helper"

RSpec.describe Dato::ThematicBreak, type: :component do
  let(:dast_node) { {type: "thematicBreak"} }
  let(:root_node) { OpenStruct.new({overrides: {}}) }
  subject(:rendered) { render_inline(described_class.new(Hashie::Mash.new(dast_node), root_node)) }

  it "can render a thematic break" do
    is_expected.to have_selector("hr")
  end

  context "when rendering in markdown format" do
    it "renders a divider line with a blank line before and one after" do
      result = render_inline_md(described_class.new(Hashie::Mash.new(dast_node), root_node))
      expect(result).to eq("\n---\n\n")
    end
  end
end
