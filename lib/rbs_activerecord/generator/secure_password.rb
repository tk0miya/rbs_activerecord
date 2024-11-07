# frozen_string_literal: true

module RbsActiverecord
  class Generator
    class SecurePassword
      include Utils

      attr_reader :model #: RbsActiverecord::Model

      # @rbs model: RbsActiverecord::Model
      def initialize(model) #: void
        @model = model
      end

      def generate #: String
        format <<~RBS
          module GeneratedSecurePasswordMethods
            #{methods}
          end
        RBS
      end

      private

      def methods #: String
        secure_password_attributes.map do |name|
          <<~RBS
            attr_reader #{name}: String?
            attr_accessor #{name}_confirmation: String
            attr_accessor #{name}_challenge: String

            def #{name}=: (String) -> String
            def #{name}_salt: () -> String
            def authenticate_#{name}: (String) -> (instance | false)

            #{"alias authenticate authenticate_password" if name == "password"}
          RBS
        end.join("\n")
      end

      def secure_password_attributes #: Array[String]
        return [] unless secure_password?

        model.klass.instance_methods.grep(/authenticate_/).filter_map do |method|
          next if model.klass.instance_methods.include?(:"#{method}_confirmation")

          method.to_s.split("_", 2).last
        end
      end

      def secure_password? #: bool
        model.klass.ancestors.any?(::ActiveModel::SecurePassword::InstanceMethodsOnActivation)
      end
    end
  end
end
