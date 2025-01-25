# frozen_string_literal: true

module Dato
  class Node < ViewComponent::Base
    attr_reader :root

    def initialize(node, root = nil)
      @node = node
      @root = root
    end

    def render_node(node)
      render class_for_node(node).new(node, root)
    end

    def blocks
      root.blocks
    end

    def overrides
      root.overrides
    end

    def debug_node
      content_tag("pre", JSON.pretty_generate(@node))
    end

    private

    def class_for_block(block)
      class_name = overrides[block.__typename] || Dato::Config.overrides[block.__typename]
      if class_name.is_a?(String)
        class_name = class_name.constantize
      end
      begin
        class_name || class_by_type(block.__typename).constantize
      rescue
        Dato::UnknownBlock
      end
    end

    def class_for_node(node)
      class_name = overrides[node.type] || Dato::Config.overrides[node.type]
      if class_name.is_a?(String)
        class_name = class_name.constantize
      end
      begin
        class_name || class_by_type(node.type).constantize
      rescue
        Dato::UnknownNode
      end
    end

    def class_by_type(type)
      "Dato::#{type.classify}"
    end
  end
end
