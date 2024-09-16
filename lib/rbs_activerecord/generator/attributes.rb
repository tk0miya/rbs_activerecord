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
        format <<~RBS
          module GeneratedAttributeMethods
            #{model.columns.map { |c| column(c) }.join("\n")}
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

      # @rbs type: Symbol
      def sql_type_to_class(type) #: String  # rubocop:disable Metris/CyclomaticComplexity
        case type
        when :integer
          "::Integer"
        when :float
          "::Float"
        when :decimal
          "::BigDecimal"
        when :string, :text, :citext, :uuid, :binary
          "::String"
        when :datetime
          "::ActiveSupport::TimeWithZone"
        when :date
          "::Date"
        when :time
          "::Time"
        when :boolean
          "bool"
        when :jsonb, :json
          "untyped"
        when :inet
          "::IPAddr"
        else
          "untyped"
        end
      end
    end
  end
end
