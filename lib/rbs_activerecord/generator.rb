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

    def generate #: String  # rubocop:disable Metrics/AbcSize
      format <<~RBS
        #{header}
          #{Attributes.new(model).generate}
          #{Associations.new(model).generate}
          #{SecurePassword.new(model).generate}

          class ActiveRecord_Relation < ::ActiveRecord::Relation
            include ::ActiveRecord::Relation::Methods[#{klass_name}, #{primary_key_type}]
            include ::Enumerable[#{klass_name}]
          end

          class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
            include ::ActiveRecord::Relation::Methods[#{klass_name}, #{primary_key_type}]
            include ::Enumerable[#{klass_name}]
          end

          include GeneratedAttributeMethods
          include GeneratedAssociationMethods
          include GeneratedSecurePasswordMethods
        #{footer}
      RBS
    end

    private

    def primary_key_type #: String
      primary_key_type_for(klass)
    end

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