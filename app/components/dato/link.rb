# frozen_string_literal: true

class Dato::Link < Dato::DastNode
  def initialize(node, root)
    super(node, "link", root)
  end

  def generated_tag
    "a"
  end
end
