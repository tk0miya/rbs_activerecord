# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module Enum
      class InstanceMethods < Base
        attr_reader :model #: RbsActiverecord::Model
        attr_reader :declarations #: Array[Prism::CallNode]

        # @rbs model: RbsActiverecord::Model
        # @rbs declarations: Hash[String, Array[Prism::CallNode]]
        def initialize(model, declarations) #: void
          @model = model
          @declarations = declarations.fetch(model.klass.name.to_s, [])

          super()
        end

        def generate #: String
          <<~RBS.strip
            module GeneratedEnumInstanceMethods
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
          return "" unless options.fetch(:instance_methods, true)

          name_methods = <<~RBS
            def #{name}: () -> String
            def #{name}=: (String) -> String
          RBS
          value_methods = values.map do |value|
            method_name = enum_method_name(name, value, options)
            <<~RBS
              def #{method_name}!: () -> void
              def #{method_name}?: () -> bool
            RBS
          end.join("\n")

          name_methods + value_methods
        end
      end
    end
  end
end
