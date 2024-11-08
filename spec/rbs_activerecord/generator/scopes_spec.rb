# frozen_string_literal: true

require "active_record"
require "tempfile"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Scopes do
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
    let(:content) do
      <<~RUBY
        class User < ActiveRecord::Base
          scope :labeled, :method
          scope :noargs, -> { all }
          scope :posargs, ->(user, age = 18, *attrs) { all }
          scope :kwargs, -> (user:, age: 18, **attrs) { all }
        end
      RUBY
    end

    it "generates RBS" do
      expect(subject).to eq <<~RBS
        module GeneratedScopeMethods[Relation]
          def labeled: (?) -> Relation

          def noargs: () -> Relation

          def posargs: (untyped user, ?untyped age, *untyped attrs) -> Relation

          def kwargs: (user: untyped, ?age: untyped, **untyped attrs) -> Relation
        end
      RBS
    end
  end
end
