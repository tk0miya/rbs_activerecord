# frozen_string_literal: true

require "spec_helper"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::ActiveStorage::InstanceMethods do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model).generate }

    before do
      stub_const("User", klass)
    end

    let(:model) { RbsActiverecord::Model.new(klass) }

    context "When the model has no attachments" do
      let(:klass) { Class.new(ActiveRecord::Base) }

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedActiveStorageInstanceMethods
          end
        RBS
      end
    end

    context "When the model has one attachment" do
      let(:klass) do
        Class.new(ActiveRecord::Base) do
          has_one_attached :avatar
        end
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedActiveStorageInstanceMethods
            def avatar: () -> ::ActiveStorage::Attached::One

            def avatar=: (::ActionDispatch::Http::UploadedFile) -> ::ActionDispatch::Http::UploadedFile
                       | (::Rack::Test::UploadedFile) -> ::Rack::Test::UploadedFile
                       | (::ActiveStorage::Blob) -> ::ActiveStorage::Blob
                       | (::String) -> ::String
                       | ({ io: ::IO, filename: ::String, content_type: ::String? }) -> { io: ::IO, filename: ::String, content_type: ::String? }
                       | (nil) -> nil
          end
        RBS
      end
    end

    context "When the model has many attachments" do
      let(:klass) do
        Class.new(ActiveRecord::Base) do
          has_many_attached :avatars
        end
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedActiveStorageInstanceMethods
            def avatars: () -> ::ActiveStroage::Attached::Many

            def avatars=: (untyped) -> untyped
          end
        RBS
      end
    end
  end
end
