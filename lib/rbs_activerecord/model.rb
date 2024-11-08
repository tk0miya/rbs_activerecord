# frozen_string_literal: true

require "forwardable"

module RbsActiverecord
  class Model
    extend Forwardable

    attr_reader :klass #: singleton(ActiveRecord::Base)

    # @rbs!
    #   def attribute_types: () -> Hash[String, untyped]
    #   def columns: () -> Array[untyped]
    #   def reflect_on_all_associations: (Symbol) -> Array[untyped]
    def_delegators :klass, :attribute_types, :columns, :reflect_on_all_associations

    # @rbs klass: singleton(ActiveRecord::Base)
    def initialize(klass) #: void
      @klass = klass
    end

    def filename #: String
      "app/models/#{klass.name.to_s.underscore}.rb"
    end
  end
end
