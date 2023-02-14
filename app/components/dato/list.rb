# frozen_string_literal: true

class Dato::List < Dato::DastNode
  def initialize(node, root)
    super(node, "list", root)
  end

  def generated_tag
    (@node.style == "bulleted") ? "ul" : "ol"
  end
end
