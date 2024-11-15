# frozen_string_literal: true

require "active_record"
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
    let(:declarations) { RbsActiverecord::Parser.parse(code) }

    let(:code) do
      <<~RUBY
        class User < ActiveRecord::Base
          scope :labeled, :method
          scope :noargs, -> { all }
          scope :posargs, ->(user, age = 18, *attrs) { all }
          scope :kwargs, -> (user:, age: 18, **attrs) { all }
          scope :proc, proc { |user, *attrs, age:, **kwargs| all}
          scope :lambda, lambda { |user, *attrs, age:, **kwargs| all}
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

          def proc: (untyped user, *untyped attrs, age: untyped, **untyped kwargs) -> Relation

          def lambda: (untyped user, *untyped attrs, age: untyped, **untyped kwargs) -> Relation
        end
      RBS
    end
  end
end
