# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::DelegatedType::InstanceMethods do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model, declarations).generate }

    before do
      stub_const("User", klass)
    end

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(ActiveRecord::Base) }
    let(:declarations) { RbsActiverecord::Parser.parse(code) }

    context "When the model has no delegated_types" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
          end
        RUBY
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedDelegatedTypeInstanceMethods
          end
        RBS
      end
    end

    context "When the model has an delegated_type" do
      before do
        stub_const "Message", message
        stub_const "Comment", comment

        ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
        ActiveRecord::Base.connection.create_table :users
        ActiveRecord::Base.connection.create_table :messages
        ActiveRecord::Base.connection.create_table :comments, id: :string
      end

      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
            delegated_type :entryable, types: %w[Message Comment]
          end
        RUBY
      end
      let(:message) { Class.new(ActiveRecord::Base) }
      let(:comment) { Class.new(ActiveRecord::Base) }

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedDelegatedTypeInstanceMethods
            def entryable_class: () -> (::Message | ::Comment)

            def entryable_name: () -> ::String

            def message?: () -> bool

            def message: () -> ::Message?

            def message_id: () -> ::Integer?

            def comment?: () -> bool

            def comment: () -> ::Comment?

            def comment_id: () -> ::String?
          end
        RBS
      end
    end
  end
end
