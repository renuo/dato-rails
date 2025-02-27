# frozen_string_literal: true

class Dato::StructuredText < Dato::Node
  def initialize(structured_text_node, overrides: {})
    unless structured_text_node.is_a?(Hashie::Mash)
      raise ArgumentError.new("The parameter is not an instance of Hashie::Mash")
    end

    unless structured_text_node.value.schema == "dast"
      raise ArgumentError.new("The node schema is '#{structured_text_node.value.schema}' instead of 'dast'")
    end

    @overrides = overrides.with_indifferent_access
    @structured_text_node = structured_text_node
    @blocks = structured_text_node.blocks
    @links = structured_text_node.links
  end

  def root
    self
  end

  attr_reader :blocks
  attr_reader :links

  attr_reader :overrides
end
