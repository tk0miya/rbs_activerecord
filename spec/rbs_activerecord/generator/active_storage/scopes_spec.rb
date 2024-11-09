# frozen_string_literal: true

require "spec_helper"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::ActiveStorage::Scopes do
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
          module GeneratedActiveStorageScopeMethods[Relation]
          end
        RBS
      end
    end

    context "When the model has an attachment" do
      let(:klass) do
        Class.new(ActiveRecord::Base) do
          has_one_attached :avatar
        end
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedActiveStorageScopeMethods[Relation]
            def with_attached_avatar: () -> Relation
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
          module GeneratedActiveStorageScopeMethods[Relation]
            def with_attached_avatars: () -> Relation
          end
        RBS
      end
    end
  end
end
