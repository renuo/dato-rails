require "rails_helper"

RSpec.describe Dato::Link, type: :component do
  let(:meta) { [
    { "id": "rel", "value": "nofollow" },
    { "id": "target", "value": "_blank" }
  ] }
  let(:dast_node) { {
    "type": "link",
    "url": "https://renuo.ch/",
    "meta": meta,
    "children": [{ "type": "span", "value": "The best company!", }]
  } }
  let(:root_node) { OpenStruct.new({ overrides: {} }) }

  subject(:rendered) { render_inline(Dato::Link.new(Hashie::Mash.new(dast_node), root_node)) }

  it "can render a span" do
    is_expected.to have_selector("a.dato-cms-link[href='https://renuo.ch/']")
    is_expected.to have_selector("a.dato-cms-link[rel='nofollow']")
    is_expected.to have_selector("a.dato-cms-link[target='_blank']")
    is_expected.to have_selector("a.dato-cms-link span.dato-cms-span", text: "The best company!")
  end

  context "when link has no meta" do
    let(:meta) { [] }

    it "does not render meta" do
      is_expected.to have_selector("a.dato-cms-link[href='https://renuo.ch/']")
      is_expected.not_to have_selector("a.dato-cms-link[rel='nofollow']")
      is_expected.not_to have_selector("a.dato-cms-link[target='_blank']")
    end
  end
end
