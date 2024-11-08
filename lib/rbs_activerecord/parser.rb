# frozen_string_literal: true

require "prism"

module RbsActiverecord
  module Parser
    # NOTE: rbs-inline-0.9.0 does not support module_function yet.
    #       refs: https://github.com/soutaro/rbs-inline/pull/118
    #
    # @rbs!
    #   def self.parse: (String filename) -> Hash[String, Array[Prism::CallNode]]
    #   def self.eval_node: (Prism::Node node) -> untyped

    # @rbs filename: String
    def parse(filename) #: Hash[String, Array[Prism::CallNode]]
      result = Prism.parse_file(filename)

      visitor = Visitor.new
      visitor.visit(result.value)
      visitor.decls
    end
    module_function :parse

    # @rbs node: Prism::Node
    def eval_node(node) #: untyped
      Evaluator.eval_node(node)
    end
    module_function :eval_node
  end
end
