# frozen_string_literal: true

module RbsActiverecord
  module Unparser
    # @rbs! def self.unparse: (Prism::Node | Array[Prism::Node] | nil node) -> untyped

    # @rbs node: Prism::Node
    def unparse(node) #: untyped # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      case node
      when Prism::NilNode
        nil
      when Prism::TrueNode
        true
      when Prism::FalseNode
        false
      when Prism::SymbolNode
        node.value.to_s.to_sym
      when Prism::IntegerNode
        node.value
      when Prism::StringNode
        node.unescaped
      when Prism::ArrayNode
        node.elements.map { |e| unparse(e) }
      when Prism::HashNode
        node.elements.filter_map do |assoc|
          case assoc
          when Prism::AssocNode
            key = unparse(assoc.key)
            value = unparse(assoc.value)
            [key, value]
          end
        end.to_h
      when Prism::KeywordHashNode
        node.elements.filter_map do |assoc|
          case assoc
          when Prism::AssocNode
            key = unparse(assoc.key)
            value = unparse(assoc.value)
            [key, value]
          end
        end.to_h
      end
    end
    module_function :unparse
  end
end
