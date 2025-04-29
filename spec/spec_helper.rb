# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    require "active_record"
    require "active_storage"
    require "active_storage/attached"
    require "active_storage/reflection"

    ActiveRecord::Base.class_eval do
      include ActiveStorage::Attached::Model
      include ActiveStorage::Reflection::ActiveRecordExtensions
      ActiveRecord::Reflection.singleton_class.prepend(ActiveStorage::Reflection::ReflectionExtension)
    end
  end

  config.before do
    stub_const("ActiveStorage::Blob", Class.new(ActiveRecord::Base) do
      def self.validate_service_configuration(*)
        # dummy method for testing
      end
    end)
    stub_const("ActiveStorage::Attachment", Class.new(ActiveRecord::Base))
  end
end
