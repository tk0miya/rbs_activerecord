# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module Enum
      class Base
        private

        # @rbs node: Prism::CallNode
        def parse_arguments(node) #: [String?, Array[String | Symbol], Hash[Symbol, untyped]] # rubocop:disable Metrics/CyclomaticComplexity
          arguments = node.arguments&.arguments || []
          args = arguments.map { |arg| Parser.eval_node(arg) }
          return nil, [], {} if args.empty?

          name = args[0] #: String?

          case args[1]
          when Array
            values = args[1]
            options = args[2] || {}
          when Hash
            values = args[1].keys
            options = {}
          else
            values = []
            options = {}
          end

          [name, values, options]
        end

        # @rbs name: String
        # @rbs value: untyped
        # @rbs options: Hash[Symbol, untyped]
        def enum_method_name(name, value, options) #: String
          components = [] #: Array[String | Symbol]

          case options[:prefix]
          when true
            components << name
          when String, Symbol
            components << options[:prefix]
          end

          components << value

          case options[:suffix]
          when true
            components << name
          when String, Symbol
            components << options[:suffix]
          end

          components.join("_")
        end
      end
    end
  end
end
