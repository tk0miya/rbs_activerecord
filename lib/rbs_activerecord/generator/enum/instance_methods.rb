# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module Enum
      class InstanceMethods < Base
        include Utils

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

          type = column_type(name)
          name_methods = <<~RBS
            def #{name}: () -> String
            def #{name}=: (String) -> String
                        | (#{type}) -> #{type}
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

        # @rbs name: String
        def column_type(name) #: String
          col = model.columns.find { |c| c.name == name.to_s }
          if col
            sql_type_to_class(col.type)
          else
            "::Integer"
          end
        end
      end
    end
  end
end
