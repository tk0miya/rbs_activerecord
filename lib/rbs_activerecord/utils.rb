# frozen_string_literal: true

require "rbs"

module RbsActiverecord
  module Utils
    # @rbs str: String
    def format(str) #: String
      parsed = RBS::Parser.parse_signature(str)
      StringIO.new.tap do |out|
        RBS::Writer.new(out:).write(parsed[1] + parsed[2])
      end.string
    end

    # @rbs klass: singleton(Object)
    def klass_to_names(klass) #: Array[RBS::TypeName]
      type_name = RBS::TypeName.parse("::#{klass.name}")

      names = [type_name] #: Array[RBS::TypeName]
      namespace = type_name.namespace
      until namespace.empty?
        names << namespace.to_type_name
        namespace = namespace.parent
      end
      names.reverse
    end

    # @rbs klass: singleton(ActiveRecord::Base)
    def primary_key_type_for(klass) #: String
      case klass.primary_key
      when Array
        primary_keys = klass.primary_key.map(&:to_s)
        types = klass.columns
                     .select { primary_keys.include?(_1.name) }
                     .map { sql_type_to_class(_1.type) }
        "[#{types.join(" | ")}]"
      else
        primary_key = klass.columns.find { _1.name == klass.primary_key }
        sql_type_to_class(primary_key.type)
      end
    end

    # @rbs type: Symbol
    def sql_type_to_class(type) #: String  # rubocop:disable Metrics/CyclomaticComplexity
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
      else # rubocop:disable Lint/DuplicateBranch
        "untyped"
      end
    end
  end
end
