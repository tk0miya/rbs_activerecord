# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module DelegatedType
      class Scopes
        attr_reader :model #: RbsActiverecord::Model
        attr_reader :declarations #: Array[Prism::CallNode]

        # @rbs model: RbsActiverecord::Model
        # @rbs declarations: Hash[String, Array[Prism::CallNode]]
        def initialize(model, declarations) #: void
          @model = model
          @declarations = declarations.fetch(model.klass.name.to_s, [])
        end

        def generate #: String
          <<~RBS.strip
            module GeneratedDelegatedTypeScopeMethods[Relation]
              #{delegated_types.map { delegated_type(_1) }.join("\n")}
            end
          RBS
        end

        private

        def delegated_types #: Array[Prism::CallNode]
          declarations.select { _1.name == :delegated_type }
        end

        # @rbs node: Prism::CallNode
        def delegated_type(node) #: String
          arguments = node.arguments&.arguments || []
          name, options = arguments.map { Parser.eval_node(_1) } #: [String?, Hash[Symbol, untyped]]
          return "" unless name

          options[:types].map do |type|
            "def #{type.tableize}: () -> Relation"
          end.join("\n")
        end
      end
    end
  end
end
