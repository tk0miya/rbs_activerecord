# frozen_string_literal: true

require "rbs"

module RbsActiverecord
  module Utils
    # @rbs str: String
    def format(str) #: String
      parsed = RBS::Parser.parse_signature(str)
      StringIO.new.tap do |out|
        RBS::Writer.new(out: out).write(parsed[1] + parsed[2])
      end.string
    end

    # @rbs klass: singleton(ActiveRecord::Base)
    def primary_key_type_for(klass) #: String
      primary_key = klass.columns.find { |column| column.name == klass.primary_key }

      sql_type_to_class(primary_key.type)
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
