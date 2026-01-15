require "rails_helper"

RSpec.describe Dato::StructuredText, :vcr, type: :component do
  it "can render without errors" do
    client = Dato::Client.new
    response = client.execute!(homepage_query)
    component = Dato::StructuredText.new(response.data.homepage.content)

    rendered = render_inline(component).to_s

    expect(rendered).to include('<a href="https://renuo.ch"')
    expect(rendered).to include("to see if they are all properly managed.")
  end

  it "renders paragraph nodes in markdown format when using md template", vcr: {cassette_name: "Dato_StructuredText/can_render_without_errors"} do
    client = Dato::Client.new
    response = client.execute!(homepage_query)
    component = Dato::StructuredText.new(response.data.homepage.content)

    # Set the controller's request format to markdown
    vc_test_controller.request.format = :md

    rendered = render_inline(component).to_s

    # In markdown format, paragraphs should NOT be wrapped in HTML tags like <div> or <p>
    # They should just be plain text with newlines
    expect(rendered).not_to include("<div class=\"dato-cms-paragraph\">")
    expect(rendered).not_to include("<p class=\"dato-cms-paragraph\">")

    # The content should be there as plain text
    expect(rendered).to include("Here is a paragraph with some content to be tested")

    # In markdown format, links should be rendered as [text](url) not <a> tags
    expect(rendered).to match(/\[[\s\S]*to see if they are all properly managed\.[\s\S]*\]\(https:\/\/renuo\.ch\)/)
    expect(rendered).not_to include('<a href="https://renuo.ch"')
  end

  describe "multiple spans in a paragraph" do
    let(:root) do
      double("root", overrides: {}, blocks: [], links: [])
    end

    let(:paragraph_with_spans) do
      Hashie::Mash.new({
        type: "paragraph",
        children: [
          {type: "span", value: "First"},
          {type: "span", value: "Second"},
          {type: "span", value: "Third"}
        ]
      })
    end

    it "concatenates spans without automatic whitespace in markdown format" do
      vc_test_controller.request.format = :md
      component = Dato::Paragraph.new(paragraph_with_spans, root)
      rendered = render_inline(component).to_s

      expect(rendered).to include("First")
      expect(rendered).to include("Second")
      expect(rendered).to include("Third")
      # Spans are concatenated without automatic whitespace
      expect(rendered).to eq("FirstSecondThird\n\n")
    end

    it "renders spans with whitespace-only values in markdown format" do
      paragraph_with_whitespace_span = Hashie::Mash.new({
        type: "paragraph",
        children: [
          {type: "span", value: "Hello"},
          {type: "span", value: " "},
          {type: "span", value: "World"}
        ]
      })

      vc_test_controller.request.format = :md
      component = Dato::Paragraph.new(paragraph_with_whitespace_span, root)
      rendered = render_inline(component).to_s

      # The whitespace span should be preserved
      expect(rendered).to eq("Hello World\n\n")
    end

    it "does not escape special characters" do
      paragraph_with_whitespace_span = Hashie::Mash.new({
                                                          type: "paragraph",
                                                          children: [
                                                            {type: "span", value: "\"Wrapped\""},
                                                            {type: "span", value: "don't"},
                                                            {type: "span", value: "what?"}
                                                          ]
                                                        })

      vc_test_controller.request.format = :md
      component = Dato::Paragraph.new(paragraph_with_whitespace_span, root)
      rendered = render_inline(component).to_s

      expect(rendered).to eq("\"Wrapped\"don'twhat?\n\n")
    end
  end
end
