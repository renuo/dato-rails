# frozen_string_literal: true

class Dato::Block < Dato::DastNode
  def initialize(node, root)
    super(node, "block", root)
  end
end
