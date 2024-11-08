# frozen_string_literal: true

require "prism"

module RbsActiverecord
  module Parser
    # NOTE: rbs-inline-0.9.0 does not support module_function yet.
    #       refs: https://github.com/soutaro/rbs-inline/pull/118
    #
    # @rbs! def self.parse: (String filename) -> Hash[String, Array[Prism::CallNode]]

    # @rbs filename: String
    def parse(filename) #: Hash[String, Array[Prism::CallNode]]
      result = Prism.parse_file(filename)

      visitor = Visitor.new
      visitor.visit(result.value)
      visitor.decls
    end
    module_function :parse
  end
end
