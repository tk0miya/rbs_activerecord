# frozen_string_literal: true

require "rails"

module RbsActiverecord
  class Generator # rubocop:disable Metrics/ClassLength
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

    def generate #: String  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      format <<~RBS
        # resolve-type-names: false

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
          #{Enum::Mappings.new(model, declarations).generate}
          #{Enum::Scopes.new(model, declarations).generate}
          #{Scopes.new(model, declarations).generate}

          module GeneratedCollectionProxyInstanceMethods[Model, PrimaryKey]
            def build: (?::ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                     | (::Array[::ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> ::Array[Model]
            def create: (?::ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                      | (::Array[::ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> ::Array[Model]
            def create!: (?::ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                       | (::Array[::ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> ::Array[Model]
            def reload: () -> ::Array[Model]
            def replace: (::Array[Model]) -> void
            def delete: (*Model | PrimaryKey) -> ::Array[Model]
            def destroy: (*Model | PrimaryKey) -> ::Array[Model]
            def <<: (*Model | ::Array[Model]) -> self
            def prepend: (*Model | ::Array[Model]) -> self
          end

          class ActiveRecord_Relation < ::ActiveRecord::Relation
            include ::Enumerable[::#{klass_name}]
            include ::ActiveRecord::Relation::Methods[::#{klass_name}, #{primary_key_type}]
            #{relation_methods}
            include ::#{klass_name}::GeneratedPluckOverloads
          end

          class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
            include ::Enumerable[::#{klass_name}]
            include ::ActiveRecord::Relation::Methods[::#{klass_name}, #{primary_key_type}]
            #{relation_methods}
            include ::#{klass_name}::GeneratedPluckOverloads
            include ::#{klass_name}::GeneratedCollectionProxyInstanceMethods[::#{klass_name}, #{primary_key_type}]
          end

          extend ::ActiveRecord::Base::ClassMethods[::#{klass_name}, ::#{klass_name}::ActiveRecord_Relation, #{primary_key_type}]
          #{scope_class_methods}
          extend ::#{klass_name}::GeneratedEnumMappingMethods
          extend ::#{klass_name}::GeneratedPluckOverloads

          include ::#{klass_name}::GeneratedActiveStorageInstanceMethods
          include ::#{klass_name}::GeneratedAttributeMethods
          include ::#{klass_name}::GeneratedAssociationMethods
          include ::#{klass_name}::GeneratedDelegatedTypeInstanceMethods
          include ::#{klass_name}::GeneratedEnumInstanceMethods
          include ::#{klass_name}::GeneratedSecurePasswordMethods
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
          Parser.parse_file(filename.to_s).tap do |decls|
            Parser::IncludeExpander.expand(model, decls)
          end
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
          superclass_name = superclass&.name || "::Object"

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

    def relation_methods #: String  # rubocop:disable Metrics/AbcSize
      methods = <<~RBS
        include ::#{klass_name}::GeneratedActiveStorageScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        include ::#{klass_name}::GeneratedDelegatedTypeScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        include ::#{klass_name}::GeneratedEnumScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        include ::#{klass_name}::GeneratedScopeMethods[::#{klass_name}::ActiveRecord_Relation]
      RBS
      model.parents.each do |cls|
        methods += <<~RBS.strip
          include ::#{cls.name}::GeneratedActiveStorageScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedDelegatedTypeScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedEnumScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          include ::#{cls.name}::GeneratedScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        RBS
      end
      methods
    end

    def scope_class_methods #: String  # rubocop:disable Metrics/AbcSize
      methods = <<~RBS
        extend ::#{klass_name}::GeneratedActiveStorageScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        extend ::#{klass_name}::GeneratedDelegatedTypeScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        extend ::#{klass_name}::GeneratedEnumScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        extend ::#{klass_name}::GeneratedScopeMethods[::#{klass_name}::ActiveRecord_Relation]
      RBS
      model.parents.each do |cls|
        methods += <<~RBS.strip
          extend ::#{cls.name}::GeneratedActiveStorageScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedDelegatedTypeScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedEnumScopeMethods[::#{klass_name}::ActiveRecord_Relation]
          extend ::#{cls.name}::GeneratedScopeMethods[::#{klass_name}::ActiveRecord_Relation]
        RBS
      end
      methods
    end
  end
end
