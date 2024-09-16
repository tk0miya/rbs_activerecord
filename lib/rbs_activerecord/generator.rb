# frozen_string_literal: true

module RbsActiverecord
  class Generator
    include Utils

    attr_reader :klass #: singleton(ActiveRecord::Base)
    attr_reader :klass_name #: String
    attr_reader :model #: RbsActiverecord::Model

    # @rbs klass: singleton(ActiveRecord::Base)
    def initialize(klass) #: void
      @klass = klass
      @klass_name = klass.name || ""
      @model = Model.new(klass)
    end

    def generate #: String
      format <<~RBS
        #{header}
          #{Attributes.new(model).generate}

          include GeneratedAttributeMethods
        #{footer}
      RBS
    end

    private

    def header #: String
      namespace = +""
      klass_name.split("::").map do |mod_name|
        namespace += "::#{mod_name}"
        mod_object = Object.const_get(namespace)
        case mod_object
        when Class
          superclass = mod_object.superclass
          superclass_name = superclass&.name || "Object"

          "class #{mod_name} < ::#{superclass_name}"
        when Module
          "module #{mod_name}"
        else
          raise "unreachable"
        end
      end.join("\n")
    end

    def footer #: String
      "end\n" * klass.module_parents.size
    end
  end
end
