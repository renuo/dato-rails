# frozen_string_literal: true

module Dato
  class Node < ViewComponent::Base
    attr_reader :root, :node, :parent

    def initialize(node, root = nil, parent = nil)
      @node = node
      @root = root
      @parent = parent
    end

    def render_node(node)
      render class_for_node(node).new(node, root, self)
    end

    # Find the first ancestor of a specific type
    # @param type [String] the type to search for (e.g., "list", "structuredText")
    # @return [Node, nil] the first ancestor matching the type or nil
    def find_ancestor(type)
      current = parent
      while current
        return current if current.node_type == type
        current = current.parent
      end
      nil
    end

    # Get the type of the immediate parent node
    # @return [String, nil] the parent's type or nil if no parent
    def node_type = node&.type
    def parent_type = parent&.node_type

    def blocks
      root.blocks
    end

    def links
      root.links
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

    def class_for_inline_item(inline_item)
      class_name = overrides[inline_item.__typename] || Dato::Config.overrides[inline_item.__typename]
      if class_name.is_a?(String)
        class_name = class_name.constantize
      end
      begin
        class_name || class_by_type(inline_item.__typename).constantize
      rescue NameError
        nil
      end
    end

    def path_for_inline_item(inline_item)
      lambda = Dato::Config.links_mapping[inline_item.__typename]
      if lambda
        instance_exec(inline_item, &lambda)
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

    def error_block(&block)
      content = capture(&block)
      content_tag(:div, content, style: "border: 3px dotted limegreen; display: inline-block; padding: 5px;font-weight: bold")
    end
  end
end
