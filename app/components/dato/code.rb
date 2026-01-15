# frozen_string_literal: true

class Dato::Code < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "code", root, parent)
  end

  def generated_tag
    "pre"
  end
end
