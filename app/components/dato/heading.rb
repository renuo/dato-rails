# frozen_string_literal: true

class Dato::Heading < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "heading", root, parent)
  end

  def level
    @node.level
  end

  def generated_tag
    "h#{level}"
  end
end
