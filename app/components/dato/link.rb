# frozen_string_literal: true

class Dato::Link < Dato::DastNode
  def initialize(node, root)
    super(node, "link", root)
  end

  def generated_tag
    "a"
  end

  def link_attributes
    attr = {
      "href" => @node.url,
      "class" => "dato-cms-#{@node.type}"
    }
    %w[rel target].each { |type| attr[type] = extract_meta(type) }
    attr
  end

  private

  def extract_meta(type)
    @node.meta&.find { |m| m.id == type }&.value
  end
end
