# frozen_string_literal: true

require "rbs"

module RbsActiverecord
  module Utils
    # @rbs str: String
    def format(str) #: String
      parsed = RBS::Parser.parse_signature(str)
      StringIO.new.tap do |out|
        RBS::Writer.new(out: out).write(parsed[1] + parsed[2])
      end.string
    end
  end
end
