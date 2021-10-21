# frozen_string_literal: true

class Dato::Heading < Dato::DastNode
  def initialize(node, root)
    super(node, "heading", root)
  end

  def generated_tag
    "h#{@node.level}"
  end
end
