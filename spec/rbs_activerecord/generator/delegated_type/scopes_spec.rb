# frozen_string_literal: true

require "active_record"
require "tempfile"
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
    let(:declarations) { RbsActiverecord::Parser.parse(filename) }

    let(:filename) do
      Tempfile.open do |f|
        f.write(content)
        f.path
      end
    end

    context "When the model has no delegated_types" do
      let(:content) do
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

    context "When the model has an delegated_type" do
      let(:content) do
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
