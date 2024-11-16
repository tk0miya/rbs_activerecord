# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module Enum
      class Mappings < Base
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
            module GeneratedEnumMappingMethods
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
          name, = parse_arguments(node)

          return "" unless name

          "def #{name.to_s.pluralize}: () -> ActiveSupport::HashWithIndifferentAccess[Symbol, untyped]"
        end
      end
    end
  end
end
