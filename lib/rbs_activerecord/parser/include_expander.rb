# frozen_string_literal: true

module RbsActiverecord
  module Parser
    class IncludeExpander
      # @rbs model: RbsActiverecord::Model
      # @rbs declarations: Hash[String, Array[Prism::CallNode]]
      def self.expand(model, declarations) #: void
        new(model, declarations).expand
      end

      attr_reader :model #: RbsActiverecord::Model
      attr_reader :declarations #: Hash[String, Array[Prism::CallNode]]

      # @rbs model: RbsActiverecord::Model
      # @rbs declarations: Hash[String, Array[Prism::CallNode]]
      def initialize(model, declarations) #: void
        @model = model
        @declarations = declarations
      end

      def expand #: void
        declarations.each_value do |decls|
          loop do
            index = decls.index { |node| node.name == :include }
            break unless index

            included_module = decls.delete_at(index)
            included_blocks = included_blocks_for(included_module)
            included_blocks.reverse_each do |included|
              decls.insert(index, *block_body_of(included))
            end
          end
        end
      end

      private

      # @rbs node: Prism::CallNode
      def included_blocks_for(node) #: Array[Prism::CallNode]
        modules = node.arguments&.arguments.to_a
                      .map { |arg| Parser.eval_node(arg) }
                      .select { |mod| mod.is_a?(String) }
        modules.flat_map do |modname|
          mod = const_get(modname)
          next [] unless mod

          Module.new(mod, modname).included_blocks
        end
      end

      # @rbs name: String
      def const_get(name) #: ::Module?
        path = model.klass.name.to_s.split("::")

        loop do
          modname = (path + [name]).join("::")
          return Object.const_get(modname) if Object.const_defined?(modname)
          break if path.empty?

          path.pop
        end
      end

      # @rbs node: Prism::CallNode
      def block_body_of(node) #: Array[Prism::CallNode]
        case node.block
        when Prism::BlockNode
          case node.block.body
          when Prism::StatementsNode
            body = node.block.body.body #: Array[Prism::CallNode]
            body.select { |n| n.is_a?(Prism::CallNode) }
          else
            []
          end
        else
          []
        end
      end
    end
  end
end
