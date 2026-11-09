# frozen_string_literal: true

class Dato::InlineBlock < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "inlineBlock", root, parent)
  end
end
