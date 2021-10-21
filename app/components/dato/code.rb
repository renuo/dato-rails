# frozen_string_literal: true

class Dato::Code < Dato::DastNode
  def initialize(node, root)
    super(node, "code", root)
  end

  def generated_tag
    "pre"
  end
end
