# frozen_string_literal: true

class Dato::Span < Dato::DastNode
  def initialize(node, root = nil)
    super(node, "span", root)
  end

  def styles
    return unless @node.marks.present?

    mapping = {
      emphasis: "font-style: italic",
      strong: "font-weight: bold",
      highlight: "background-color: var(--dato-highlight-color, yellow)",
    }.with_indifferent_access

    text_decoration_mappings = {
      underline: "underline",
      strikethrough: "line-through"
    }.with_indifferent_access
    styles = @node.marks.map { |m| mapping[m] }.compact
    text_decorations = @node.marks.map { |m| text_decoration_mappings[m] }.compact
    if text_decorations.any?
      styles << "text-decoration: #{text_decorations.join(" ")}"
    end

    styles.join("; ")
  end

  def code_span?
    @node.marks.present? && @node.marks.include?("code")
  end

  def conditional_tag(name, condition, options = nil, &block)
    if condition
      content_tag name, capture(&block), options
    else
      capture(&block)
    end
  end
end
