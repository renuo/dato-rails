# frozen_string_literal: true

class Dato::Paragraph < Dato::DastNode
  def initialize(node, root)
    super(node, "paragraph", root)
  end

  def generated_tag
    "p"
  end
end
