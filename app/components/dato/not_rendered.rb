# frozen_string_literal: true

module Dato
  class NotRendered < DastNode
    def initialize(node, root)
      super(node, node.type, root)
    end

    def render?
      false
    end
  end
end
