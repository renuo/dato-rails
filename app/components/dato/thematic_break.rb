# frozen_string_literal: true

class Dato::ThematicBreak < Dato::DastNode
  def initialize(node, root)
    super(node, "thematicBreak", root)
  end

  def generated_tag
    "hr"
  end
end
