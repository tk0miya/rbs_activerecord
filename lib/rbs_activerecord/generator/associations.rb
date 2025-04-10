# frozen_string_literal: true

module RbsActiverecord
  class Generator
    class Associations
      include Utils

      attr_reader :model #: RbsActiverecord::Model

      # @rbs model: RbsActiverecord::Model
      def initialize(model) #: void
        @model = model
      end

      def generate #: String
        <<~RBS.strip
          module GeneratedAssociationMethods
            #{has_many}
            #{has_one}
            #{belongs_to}
            #{has_and_belongs_to_many}
          end
        RBS
      end

      private

      def has_many #: String  # rubocop:disable Naming/PredicateName
        model.reflect_on_all_associations(:has_many).map do |assoc|
          assoc_name = assoc.name.to_s
          klass_name = "::#{assoc.klass.name}"
          collection = "#{klass_name}::ActiveRecord_Associations_CollectionProxy"
          primary_key_type = primary_key_type_for(assoc.klass)

          <<~RBS
            def #{assoc_name}: () -> #{collection}
            def #{assoc_name}=: (#{collection} | ::Array[#{klass_name}]) -> (#{collection} | ::Array[#{klass_name}])
            def #{assoc_name.singularize}_ids: () -> ::Array[#{primary_key_type}]
            def #{assoc_name.singularize}_ids=: (::Array[#{primary_key_type}]) -> ::Array[#{primary_key_type}]
          RBS
        end.join("\n")
      end

      def has_one #: String  # rubocop:disable Naming/PredicateName
        model.reflect_on_all_associations(:has_one).map do |assoc|
          type = "::#{assoc.klass.name}"
          optional = "#{type}?"

          <<~RBS
            def #{assoc.name}: () -> #{optional}
            def #{assoc.name}=: (#{optional}) -> #{optional}
            def build_#{assoc.name}: (?untyped) -> #{type}
            def create_#{assoc.name}: (untyped) -> #{type}
            def create_#{assoc.name}!: (untyped) -> #{type}
            def reload_#{assoc.name}: () -> #{optional}
            def reset_#{assoc.name}: () -> void
            def #{assoc.name}_changed?: () -> bool
            def #{assoc.name}_previously_changed?: () -> bool
          RBS
        end.join("\n")
      end

      def belongs_to #: String  # rubocop:disable Metrics/AbcSize
        model.reflect_on_all_associations(:belongs_to).map do |assoc|
          is_optional = assoc.options[:optional]
          type = assoc.polymorphic? ? polymorphic_owner_types(assoc) : "::#{assoc.klass.name}"
          optional = "#{type}?"

          # @type var methods: Array[String]
          methods = []
          methods << "def #{assoc.name}: () -> #{is_optional ? optional : type}"
          methods << "def #{assoc.name}=: (#{optional}) -> #{optional}"
          unless assoc.polymorphic?
            methods << "def build_#{assoc.name}: (untyped) -> #{type}"
            methods << "def create_#{assoc.name}: (untyped) -> #{type}"
            methods << "def create_#{assoc.name}!: (untyped) -> #{type}"
          end
          methods << "def reload_#{assoc.name}: () -> #{optional}"
          methods << "def reset_#{assoc.name}: () -> void"
          methods.join("\n")
        end.join("\n")
      end

      # @rbs assoc: untyped
      def polymorphic_owner_types(assoc) #: String  # rubocop:disable Metrics/AbcSize
        table_name = model.klass.name.to_s.tableize.to_sym
        owners = ActiveRecord::Base.descendants.select do |klass|
          klass.reflect_on_all_associations.any? { |a| a.name == table_name && a.options[:as] == assoc.name }
        end

        if owners.empty?
          "untyped"
        elsif owners.size == 1
          owners.first.name
        else
          names = owners.map(&:name).sort.join(" | ")
          "(#{names})"
        end
      end

      def has_and_belongs_to_many #: String  # rubocop:disable Naming/PredicateName
        model.reflect_on_all_associations(:has_and_belongs_to_many).map do |assoc|
          assoc_name = assoc.name.to_s
          klass_name = assoc.klass.name
          collection = "#{klass_name}::ActiveRecord_Associations_CollectionProxy"
          primary_key_type = primary_key_type_for(assoc.klass)

          <<~RBS
            def #{assoc_name}: () -> #{collection}
            def #{assoc_name}=: (#{collection} | Array[::#{klass_name}]) -> (#{collection} | Array[::#{klass_name}])
            def #{assoc_name.singularize}_ids: () -> Array[#{primary_key_type}]
            def #{assoc_name.singularize}_ids=: (Array[#{primary_key_type}]) -> Array[#{primary_key_type}]
          RBS
        end.join("\n")
      end
    end
  end
end
