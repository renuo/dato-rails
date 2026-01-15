# frozen_string_literal: true

class Dato::Link < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "link", root, parent)
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
end
