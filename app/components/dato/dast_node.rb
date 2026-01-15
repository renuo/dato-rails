# frozen_string_literal: true

module Dato
  class DastNode < Node
    def initialize(node, type, root = nil, parent = nil)
      super(node, root, parent)
      unless node.type == type
        raise ArgumentError.new("The node type is '#{node.type}' instead of '#{type}'")
      end
      @type = type
    end

    def generated_tag
      @type
    end

    private

    def extract_meta(type)
      @node.meta&.find { |m| m.id == type }&.value
    end
  end
end
