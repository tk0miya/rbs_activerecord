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
              #{delegated_types.map { |node| delegated_type(node) }.join("\n")}
            end
          RBS
        end

        private

        def delegated_types #: Array[Prism::CallNode]
          declarations.select { |node| node.name == :delegated_type }
        end

        # @rbs node: Prism::CallNode
        def delegated_type(node) #: String
          arguments = node.arguments&.arguments || []
          name, options = arguments.map { |arg| Parser.eval_node(arg) } #: [String?, Hash[Symbol, untyped]]
          return "" unless name

          options[:types].map do |type|
            "def #{type.tableize}: () -> Relation"
          end.join("\n")
        end
      end
    end
  end
end
