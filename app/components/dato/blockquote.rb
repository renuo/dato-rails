# frozen_string_literal: true

class Dato::Blockquote < Dato::DastNode
  def initialize(node, root)
    super(node, "blockquote", root)
  end
end
