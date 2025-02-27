# frozen_string_literal: true

require "forwardable"

module RbsActiverecord
  class Model
    extend Forwardable

    attr_reader :klass #: singleton(ActiveRecord::Base)

    # @rbs!
    #   def attribute_types: () -> Hash[String, untyped]
    #   def attribute_aliases: () -> Hash[String, String]
    #   def columns: () -> Array[untyped]
    #   def defined_enums: () -> Hash[String, untyped]
    #   def reflect_on_all_associations: (Symbol) -> Array[untyped]
    def_delegators :klass, :attribute_aliases, :attribute_types, :columns, :defined_enums, :reflect_on_all_associations

    # @rbs klass: singleton(ActiveRecord::Base)
    def initialize(klass) #: void
      @klass = klass
    end

    def filename #: String
      "app/models/#{klass.name.to_s.underscore}.rb"
    end

    def parents #: Array[singleton(ActiveRecord::Base)]
      ancestors = klass.ancestors #: Array[singleton(ActiveRecord::Base)]
      ancestors.select { |cls| cls < ActiveRecord::Base && cls != klass && !cls.abstract_class? }
    end
  end
end
