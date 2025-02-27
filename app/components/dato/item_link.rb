# frozen_string_literal: true

class Dato::ItemLink < Dato::DastNode
  def initialize(node, root)
    super(node, "itemLink", root)
  end

  def inline_item
    links.find { |b| b.id == @node.item }
  end

  def link_attributes
    attr = {
      "href" => path_for_inline_item(inline_item),
      "class" => "dato-cms-#{@node.type}"
    }
    %w[rel target].each { |type| attr[type] = extract_meta(type) }
    attr
  end
end
