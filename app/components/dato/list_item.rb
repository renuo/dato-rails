# frozen_string_literal: true

class Dato::ListItem < Dato::DastNode
  def initialize(node, root)
    super(node, "listItem", root)
  end

  def generated_tag
    "li"
  end
end
