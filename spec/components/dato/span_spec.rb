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

    it "strips whitespaces" do
      expect(rendered.to_html).to eq("<span class=\"dato-cms-span\">Hello</span>")
    end
  end

  context 'when it has "underline" mark' do
    let(:dast_node) { {type: "span", value: "Hello", marks: ["underline"]} }

    it "adds a text-decoration" do
      expect(rendered.css("span").attr("style").value).to eq("text-decoration: underline")
    end

    it "strips whitespaces" do
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

  context "when rendering in markdown format" do
    def build_span(node)
      Dato::Span.new(Hashie::Mash.new(node))
    end

    context "with plain text" do
      let(:dast_node) { {type: "span", value: "Hello"} }

      it "renders plain text without HTML tags" do
        expect(render_inline_md(build_span(dast_node))).to eq("Hello")
      end

      it "does not add extra newlines" do
        expect(render_inline_md(build_span(dast_node))).not_to end_with("\n")
      end
    end

    context "with quotes" do
      let(:dast_node) { {type: "span", marks: ["strong"], value: "\"Hello\""} }

      it "renders plain text without HTML tags" do
        expect(render_inline_md(build_span(dast_node))).to eq("**\"Hello\"**")
      end
    end

    context "with apostrophe" do
      let(:dast_node) { {type: "span", value: "don't"} }

      it "renders plain text without HTML tags" do
        expect(render_inline_md(build_span(dast_node))).to eq("don't")
      end
    end

    context "with empty value" do
      let(:dast_node) { {type: "span", value: ""} }

      it "renders nothing" do
        expect(render_inline_md(build_span(dast_node))).to eq("")
      end
    end

    context "with no value" do
      let(:dast_node) { {type: "span"} }

      it "renders nothing" do
        expect(render_inline_md(build_span(dast_node))).to eq("")
      end
    end

    context 'with "strong" mark' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["strong"]} }

      it "wraps text with ** for markdown bold" do
        expect(render_inline_md(build_span(dast_node))).to eq("**Hello**")
      end

      it "does not include HTML tags" do
        expect(render_inline_md(build_span(dast_node))).not_to include("<span")
        expect(render_inline_md(build_span(dast_node))).not_to include("</span>")
      end
    end

    context 'with "emphasis" mark' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["emphasis"]} }

      it "wraps text with _ for markdown italic" do
        expect(render_inline_md(build_span(dast_node))).to eq("_Hello_")
      end

      it "does not include HTML tags" do
        expect(render_inline_md(build_span(dast_node))).not_to include("<span")
      end
    end

    context 'with "code" mark' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["code"]} }

      it "wraps text with backticks for markdown code" do
        expect(render_inline_md(build_span(dast_node))).to eq("`Hello`")
      end

      it "does not include HTML tags" do
        expect(render_inline_md(build_span(dast_node))).not_to include("<code")
        expect(render_inline_md(build_span(dast_node))).not_to include("<span")
      end
    end

    context 'with "strong" and "emphasis" marks' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["strong", "emphasis"]} }

      it "wraps text with combined markdown syntax" do
        expect(render_inline_md(build_span(dast_node))).to eq("**_Hello_**")
      end
    end

    context 'with "strong" and "code" marks' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["strong", "code"]} }

      it "wraps text with combined markdown syntax" do
        expect(render_inline_md(build_span(dast_node))).to eq("**`Hello`**")
      end
    end

    context 'with all marks' do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["strong", "code", "emphasis"]} }

      it "wraps text with all markdown symbols" do
        expect(render_inline_md(build_span(dast_node))).to eq("**`_Hello_`**")
      end
    end

    context "with marks that don't have markdown equivalents" do
      let(:dast_node) { {type: "span", value: "Hello", marks: ["underline"]} }

      it "renders plain text" do
        expect(render_inline_md(build_span(dast_node))).to eq("Hello")
      end

      it "does not include HTML tags or styles" do
        expect(render_inline_md(build_span(dast_node))).not_to include("<span")
        expect(render_inline_md(build_span(dast_node))).not_to include("style=")
      end
    end

    context "with whitespace-only value" do
      let(:dast_node) { {type: "span", value: " "} }

      it "renders the whitespace" do
        expect(render_inline_md(build_span(dast_node))).to eq(" ")
      end
    end
  end
end
