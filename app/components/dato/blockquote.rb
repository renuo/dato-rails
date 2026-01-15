# frozen_string_literal: true

class Dato::Blockquote < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "blockquote", root, parent)
  end
end
