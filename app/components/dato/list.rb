# frozen_string_literal: true

class Dato::List < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "list", root, parent)
  end

  def generated_tag
    (@node.style == "bulleted") ? "ul" : "ol"
  end
end
