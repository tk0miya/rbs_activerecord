# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module ActiveStorage
      class Scopes
        attr_reader :model #: RbsActiverecord::Model

        # @rbs model: RbsActiverecord::Model
        def initialize(model) #: void
          @model = model
        end

        def generate #: String
          <<~RBS.strip
            module GeneratedActiveStorageScopeMethods[Relation]
              #{attachments.map { |name, _| attachment(name) }.join("\n")}
            end
          RBS
        end

        private

        def attachments #: Hash[Symbol, untyped]
          if model.klass.respond_to?(:attachment_reflections)
            model.klass.attachment_reflections # steep:ignore
          else
            {}
          end
        end

        # @rbs name: Symbol
        def attachment(name) #: String
          "def with_attached_#{name}: () -> Relation"
        end
      end
    end
  end
end
