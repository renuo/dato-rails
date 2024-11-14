# frozen_string_literal: true

class Dato::ResponsiveImage < Dato::Node
  def initialize(node, root = nil, custom_css_classes: [], custom_img_css_classes: [])
    super(node, root)
    @custom_css_classes = custom_css_classes.is_a?(Array) ? custom_css_classes.join(" ") : custom_css_classes
    @custom_img_css_classes = custom_img_css_classes.is_a?(Array) ? custom_img_css_classes.join(" ") : custom_img_css_classes
  end
end
