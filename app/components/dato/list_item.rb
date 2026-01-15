# frozen_string_literal: true

class Dato::ListItem < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "listItem", root, parent)
  end

  def generated_tag
    "li"
  end
end
