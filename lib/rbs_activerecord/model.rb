# frozen_string_literal: true

require "forwardable"

module RbsActiverecord
  class Model
    extend Forwardable

    attr_reader :klass #: singleton(ActiveRecord::Base)

    # @rbs!
    #   def columns: () -> Array[untyped]
    def_delegator :klass, :columns

    # @rbs klass: singleton(ActiveRecord::Base)
    def initialize(klass) #: void
      @klass = klass
    end
  end
end
