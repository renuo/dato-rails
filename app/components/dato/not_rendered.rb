# frozen_string_literal: true

module Dato
  class NotRendered < DastNode
    def initialize(node, root, parent = nil)
      super(node, node.type, root, parent)
    end

    def render?
      false
    end
  end
end
