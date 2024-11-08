# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module Enum
      class Scopes < Base
        attr_reader :model #: RbsActiverecord::Model
        attr_reader :declarations #: Array[Prism::CallNode]

        # @rbs model: RbsActiverecord::Model
        # @rbs delarations: Hash[String, Array[Prism::CallNode]]
        def initialize(model, declarations) #: void
          @model = model
          @declarations = declarations.fetch(model.klass.name, [])

          super()
        end

        def generate #: String
          <<~RBS.strip
            module GeneratedEnumScopeMethods[Relation]
              #{enums.map { |node| enum(node) }.join("\n")}
            end
          RBS
        end

        private

        def enums #: Array[Prism::CallNode]
          declarations.select { |node| node.name == :enum }
        end

        # @rbs node: Prism::CallNode
        def enum(node) #: String
          name, values, options = parse_arguments(node)

          return "" unless name
          return "" unless options.fetch(:scopes, true)

          values.map do |value|
            method_name = enum_method_name(name, value, options)
            <<~RBS
              def #{method_name}: () -> Relation
              def not_#{method_name}: () -> Relation
            RBS
          end.join("\n")
        end
      end
    end
  end
end
