# frozen_string_literal: true

class Dato::Paragraph < Dato::DastNode
  def initialize(node, root, parent = nil)
    super(node, "paragraph", root, parent)
  end

  def generated_tag
    "div"
  end
end
