# frozen_string_literal: true

require "rails"

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

          #{ActiveStorage::InstanceMethods.new(model).generate}
          #{ActiveStorage::Scopes.new(model).generate}
          #{PluckOverloads.new(model).generate}
          #{SecurePassword.new(model).generate}

          #{DelegatedType::InstanceMethods.new(model, declarations).generate}
          #{DelegatedType::Scopes.new(model, declarations).generate}
          #{Enum::InstanceMethods.new(model, declarations).generate}
          #{Enum::Scopes.new(model, declarations).generate}
          #{Scopes.new(model, declarations).generate}

          class ActiveRecord_Relation < ::ActiveRecord::Relation
            include ::Enumerable[#{klass_name}]
            include ::ActiveRecord::Relation::Methods[#{klass_name}, #{primary_key_type}]
            #{relation_methods}
            include GeneratedPluckOverloads
          end

          class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
            include ::Enumerable[#{klass_name}]
            include ::ActiveRecord::Relation::Methods[#{klass_name}, #{primary_key_type}]
            #{relation_methods}
            include GeneratedPluckOverloads
          end

          extend ::ActiveRecord::Base::ClassMethods[#{klass_name}, #{klass_name}::ActiveRecord_Relation, #{primary_key_type}]
          #{scope_class_methods}
          extend GeneratedPluckOverloads

          include GeneratedActiveStorageInstanceMethods
          include GeneratedAttributeMethods
          include GeneratedAssociationMethods
          include GeneratedDelegatedTypeInstanceMethods
          include GeneratedEnumInstanceMethods
          include GeneratedSecurePasswordMethods
        #{footer}
      RBS
    end

    private

    def primary_key_type #: String
      primary_key_type_for(klass)
    end

    # @rbs @declarations: Hash[String, Array[Prism::CallNode]]

    def declarations #: Hash[String, Array[Prism::CallNode]]
      @declarations ||= begin
        filename = Rails.root.join(model.filename)
        if filename.exist?
          Parser.parse_file(filename.to_s)
        else
          {}
        end
      end
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

    def relation_methods #: String
      methods = <<~RBS
        include GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
        include GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
        include GeneratedEnumScopeMethods[ActiveRecord_Relation]
        include GeneratedScopeMethods[ActiveRecord_Relation]
      RBS
      model.parents.each do |cls|
        methods += <<~RBS.strip
          include ::#{cls.name}::GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedEnumScopeMethods[ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedScopeMethods[ActiveRecord_Relation]
        RBS
      end
      methods
    end

    def scope_class_methods #: String
      methods = <<~RBS
        extend GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
        extend GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
        extend GeneratedEnumScopeMethods[ActiveRecord_Relation]
        extend GeneratedScopeMethods[ActiveRecord_Relation]
      RBS
      model.parents.each do |cls|
        methods += <<~RBS.strip
          extend ::#{cls.name}::GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedEnumScopeMethods[ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedScopeMethods[ActiveRecord_Relation]
        RBS
      end
      methods
    end
  end
end
