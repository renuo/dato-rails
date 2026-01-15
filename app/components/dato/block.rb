# frozen_string_literal: true

class Dato::Block < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "block", root, parent)
  end
end
