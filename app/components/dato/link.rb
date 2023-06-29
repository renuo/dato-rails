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
      "class" => "dato-cms-#{@node.type}",
    }
    %w[rel target].each do |type|
      value = extract_meta(type)
      attr[type] = value if value
    end
    attr
  end

  private

  def extract_meta(type)
    meta = @node.meta.find { |m| m.id == type }
    meta&.value
  end
end
