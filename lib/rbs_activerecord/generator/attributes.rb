# frozen_string_literal: true

module RbsActiverecord
  class Generator
    class Attributes
      include Utils

      attr_reader :model #: RbsActiverecord::Model

      # @rbs model: RbsActiverecord::Model
      def initialize(model) #: void
        @model = model
      end

      def generate #: String
        <<~RBS
          module GeneratedAttributeMethods
            #{model.columns.map { |c| column(c) }.join("\n")}
            #{attributes.map { |name, type| attribute(name, type) }.join("\n")}
            #{model.attribute_aliases.map { |from, to| alias_method(from, to) }.join("\n")}
          end
        RBS
      end

      private

      def column(col) #: String  # rubocop:disable Metrics/AbcSize
        type = sql_type_to_class(col.type)
        optional = "#{type}?"
        column_type = col.null ? optional : type

        <<~RBS
          def #{col.name}: () -> #{column_type}
          def #{col.name}=: (#{column_type}) -> #{column_type}
          def #{col.name}?: () -> bool
          def #{col.name}_changed?: () -> bool
          def #{col.name}_change: () -> [#{optional}, #{optional}]
          def #{col.name}_will_change!: () -> void
          def #{col.name}_was: () -> #{optional}
          def #{col.name}_previously_changed?: () -> bool
          def #{col.name}_previous_change: () -> ::Array[#{optional}]?
          def #{col.name}_previously_was: () -> #{optional}
          def #{col.name}_before_last_save: () -> #{optional}
          def #{col.name}_change_to_be_saved: () -> ::Array[#{optional}]?
          def #{col.name}_in_database: () -> #{optional}
          def saved_change_to_#{col.name}: () -> ::Array[#{optional}]?
          def saved_change_to_#{col.name}?: () -> bool
          def will_save_change_to_#{col.name}?: () -> bool
          def restore_#{col.name}!: () -> void
          def clear_#{col.name}_change: () -> void
        RBS
      end

      def attributes #: Hash[String, untyped]
        model.attribute_types.filter_map do |name, type|
          [name, type] if model.columns.none? { |col| col.name == name }
        end.to_h
      end

      # @rbs name: String
      # @rbs type: untyped
      def attribute(name, type) #: String
        column_type = sql_type_to_class(type.type)

        <<~RBS
          def #{name}: () -> #{column_type}
          def #{name}=: (#{column_type}) -> #{column_type}
        RBS
      end

      def alias_method(from, to) #: String
        <<~RBS
          alias #{from} #{to}
          alias #{from}= #{to}=
          alias #{from}? #{to}?
          alias #{from}_changed? #{to}_changed?
          alias #{from}_change #{to}_change
          alias #{from}_will_change! #{to}_will_change!
          alias #{from}_was #{to}_was
          alias #{from}_previously_changed? #{to}_previously_changed?
          alias #{from}_previous_change #{to}_previous_change
          alias #{from}_previously_was #{to}_previously_was
          alias #{from}_before_last_save #{to}_before_last_save
          alias #{from}_change_to_be_saved #{to}_change_to_be_saved
          alias #{from}_in_database #{to}_in_database
          alias saved_change_to_#{from} saved_change_to_#{to}
          alias saved_change_to_#{from}? saved_change_to_#{to}?
          alias will_save_change_to_#{from}? will_save_change_to_#{to}?
          alias restore_#{from}! restore_#{to}!
          alias clear_#{from}_change clear_#{to}_change
        RBS
      end
    end
  end
end
