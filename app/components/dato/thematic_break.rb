# frozen_string_literal: true

class Dato::ThematicBreak < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "thematicBreak", root, parent)
  end

  def generated_tag
    "hr"
  end
end
