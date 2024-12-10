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
        context.map { |node| Parser.eval_node(node.constant_path) }.join("::")
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
        decls.fetch(current_namespace) << node
      end

      # @rbs override
      def visit_def_node(node)
        # ignore
      end
    end
  end
end
