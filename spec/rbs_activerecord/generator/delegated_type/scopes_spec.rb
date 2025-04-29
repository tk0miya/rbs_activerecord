# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::DelegatedType::Scopes do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model, declarations).generate }

    before do
      stub_const("User", klass)
    end

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(ActiveRecord::Base) }
    let(:declarations) { RbsActiverecord::Parser.parse(code) }

    context "when the model has no delegated_types" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
          end
        RUBY
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedDelegatedTypeScopeMethods[Relation]
          end
        RBS
      end
    end

    context "when the model has an delegated_type" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
            delegated_type :entryable, types: %w[Message Comment]
          end
        RUBY
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedDelegatedTypeScopeMethods[Relation]
            def messages: () -> Relation

            def comments: () -> Relation
          end
        RBS
      end
    end
  end
end
