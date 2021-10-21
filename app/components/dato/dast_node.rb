# frozen_string_literal: true

module Dato
  class DastNode < Node
    def initialize(node, type, root = nil)
      super(node, root)
      unless node.type == type
        raise ArgumentError.new("The node type is '#{node.type}' instead of '#{type}'")
      end
      @type = type
    end

    def generated_tag
      @type
    end
  end
end
