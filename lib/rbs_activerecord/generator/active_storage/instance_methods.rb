# frozen_string_literal: true

module RbsActiverecord
  class Generator
    module ActiveStorage
      class InstanceMethods
        attr_reader :model #: RbsActiverecord::Model

        # @rbs model: RbsActiverecord::Model
        def initialize(model) #: void
          @model = model
        end

        def generate #: String
          <<~RBS.strip
            module GeneratedActiveStorageInstanceMethods
              #{attachments.map { |name, reflection| attachment(name, reflection) }.join("\n")}
            end
          RBS
        end

        private

        def attachments #: Hash[String, untyped]
          if model.klass.respond_to?(:attachment_reflections)
            model.klass.attachment_reflections # steep:ignore
          else
            {}
          end
        end

        # @rbs name: String
        def attachment(name, reflection) #: String
          case reflection.macro
          when :has_one_attached
            <<~RBS
              def #{name}: () -> ::ActiveStorage::Attached::One
              def #{name}=: (::ActionDispatch::Http::UploadedFile) -> ::ActionDispatch::Http::UploadedFile
                          | (::Rack::Test::UploadedFile) -> ::Rack::Test::UploadedFile
                          | (::ActiveStorage::Blob) -> ::ActiveStorage::Blob
                          | (::String) -> ::String
                          | ({ io: ::IO, filename: ::String, content_type: ::String? }) -> { io: ::IO, filename: ::String, content_type: ::String? }
                          | (nil) -> nil
            RBS
          when :has_many_attached
            <<~RBS
              def #{name}: () -> ::ActiveStroage::Attached::Many
              def #{name}=: (untyped) -> untyped
            RBS
          else
            raise "unknown macro: #{reflection.macro}"
          end
        end
      end
    end
  end
end
