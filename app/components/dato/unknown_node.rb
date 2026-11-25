# frozen_string_literal: true

module Dato
  class UnknownNode < DastNode
    def initialize(node, root, parent = nil)
      super(node, node.type, root, parent)
    end
  end
end
