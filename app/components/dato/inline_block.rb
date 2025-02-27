# frozen_string_literal: true

class Dato::InlineBlock < Dato::DastNode
  def initialize(node, root)
    super(node, "inlineBlock", root)
  end
end
