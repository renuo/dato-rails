# frozen_string_literal: true

module Dato
  class UnknownNode < DastNode
    def initialize(node, root)
      super(node, node.type, root)
    end
  end
end
