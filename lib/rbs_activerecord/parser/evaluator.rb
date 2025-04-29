# frozen_string_literal: true

module RbsActiverecord
  module Parser
    module Evaluator
      # @rbs node: Prism::Node
      def eval_node(node) #: untyped # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
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
          node.elements.map { |e| eval_node(e) }
        when Prism::HashNode, Prism::KeywordHashNode
          node.elements.filter_map do |assoc|
            case assoc
            when Prism::AssocNode
              key = eval_node(assoc.key)
              value = eval_node(assoc.value)
              [key, value]
            end
          end.to_h
        when Prism::ConstantReadNode
          node.name.to_s
        when Prism::ConstantPathNode
          parent = node.parent ? eval_node(node.parent) : nil
          "#{parent}::#{node.name}"
        end
      end
      module_function :eval_node
    end
  end
end
