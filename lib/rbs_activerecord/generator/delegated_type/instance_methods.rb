# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module DelegatedType
      class InstanceMethods
        include Utils

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
            module GeneratedDelegatedTypeInstanceMethods
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

          types = options[:types]
          role_methods = <<~RBS
            def #{name}_class: () -> (#{types.map { "::#{_1}" }.join(" | ")})
            def #{name}_name: () -> ::String
          RBS

          type_methods = types.map do |type|
            <<~RBS
              def #{type.underscore}?: () -> bool
              def #{type.underscore}: () -> ::#{type}?
              def #{type.underscore}_id: () -> #{primary_key_type_for(type)}?
            RBS
          end.join("\n")

          role_methods + type_methods
        end

        # @rbs klass_name: String
        def primary_key_type_for(klass_name) #: String
          klass = Object.const_get(klass_name)
          super(klass)
        rescue NameError
          "::Integer"
        end
      end
    end
  end
end
