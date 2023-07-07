require "rails_helper"

RSpec.describe Dato::Span, type: :component do
  let(:dast_node) { {type: "span"} }

  subject(:rendered) { render_inline(Dato::Span.new(Hashie::Mash.new(dast_node))) }

  it "can render a span" do
    is_expected.to have_selector("span.dato-cms-span")
  end

  context "when it has content" do
    let(:dast_node) { {type: "span", value: "Hello"} }

    it "renders it inside the span" do
      is_expected.to have_selector("span.dato-cms-span", text: "Hello")
    end

    it 'strips whitespaces' do
      expect(rendered.to_html).to eq("<span class=\"dato-cms-span\">Hello</span>")
    end
  end

  context 'when it has "underline" mark' do
    let(:dast_node) { {type: "span", value: "Hello", marks: ["underline"]} }

    it "adds a text-decoration" do
      expect(rendered.css("span").attr("style").value).to eq("text-decoration: underline")
    end

    it 'strips whitespaces' do
      expect(rendered.to_html).to eq("<span class=\"dato-cms-span\" style=\"text-decoration: underline\">Hello</span>")
    end
  end

  context 'when it has "underline" and "strikethrough" marks' do
    let(:dast_node) { {type: "span", value: "Hello", marks: ["underline", "strikethrough"]} }

    it "adds a text-decoration" do
      expect(rendered.css("span").attr("style").value).to eq("text-decoration: underline line-through")
    end
  end

  context 'when it has "code" mark' do
    let(:dast_node) { {type: "span", value: "Hello", marks: ["code"]} }

    it "is wrapped" do
      is_expected.to have_selector("code.dato-cms-span-wrapper span.dato-cms-span", text: "Hello")
    end
  end
end
