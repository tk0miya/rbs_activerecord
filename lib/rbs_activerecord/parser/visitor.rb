# frozen_string_literal: true

module RbsActiverecord
  module Parser
    class Visitor < Prism::Visitor
      attr_reader :context #: Array[Prism::ClassNode | Prism::ModuleNode]
      attr_reader :decls   #: Hash[String, Array[Prism::CallNode]]

      def initialize #: void
        super

        @context = []
        @decls = {}
      end

      def current_namespace #: String
        context.flat_map do |node|
          namespace = [] #: Array[Symbol?]
          path = node.constant_path #: Prism::Node?
          loop do
            case path
            when Prism::ConstantPathNode
              namespace << path.name
              path = path.parent
            when Prism::ConstantReadNode
              namespace << path.name
              break
            end
          end

          namespace.compact.reverse
        end.join("::")
      end

      # @rbs override
      def visit_module_node(node)
        context << node
        begin
          super
        ensure
          context.pop
        end
      end

      # @rbs override
      def visit_class_node(node)
        context << node
        begin
          super
        ensure
          context.pop
        end
      end

      # @rbs override
      def visit_call_node(node)
        decls[current_namespace] ||= []
        decls[current_namespace] << node
      end

      # @rbs override
      def visit_def_node(node)
        # ignore
      end
    end
  end
end
