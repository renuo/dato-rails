# frozen_string_literal: true

class Dato::ResponsiveImage < Dato::Node
  def initialize(node, root = nil, custom_css_classes: [])
    super(node, root)
    @custom_css_classes = custom_css_classes
  end
end
