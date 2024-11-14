# frozen_string_literal: true

module RbsActiverecord
  class Generator
    class PluckOverloads
      include Utils

      attr_reader :model #: RbsActiverecord::Model

      # @rbs model: RbsActiverecord::Model
      def initialize(model) #: void
        @model = model
      end

      def generate #: String
        <<~RBS.strip
          module GeneratedPluckOverloads
            def pluck: #{overloads.join(" | ")}
                     | (::Symbol | ::String | ::Arel::Nodes::t column) -> ::Array[untyped]
                     | (*::Symbol | ::String | ::Arel::Nodes::t columns) -> ::Array[::Array[untyped]]
          end
        RBS
      end

      private

      def overloads #: Array[String]
        model.columns.map do |col|
          base_type = enum?(col) ? "::String" : sql_type_to_class(col.type)
          column_type = col.null ? "#{base_type}?" : base_type
          "(:#{col.name} | \"#{col.name}\") -> ::Array[#{column_type}]"
        end
      end

      # @rbs column: untyped
      def enum?(column) #: bool
        model.defined_enums.key? column.name
      end
    end
  end
end
