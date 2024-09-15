# frozen_string_literal: true

require "prism"

module RbsActiverecord
  module Parser
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
