# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Associations do
  describe "#generate" do
    subject { described_class.new(model).generate }

    before do
      stub_const "Foo", klass

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    end

    let(:model) { RbsActiverecord::Model.new(klass) }

    context "When the model has no associations" do
      let(:klass) { Class.new(::ActiveRecord::Base) }

      it { is_expected.to eq "module GeneratedAssociationMethods\nend\n" }
    end

    context "When the model has a has_many association" do
      before do
        stub_const "Bar", Class.new(::ActiveRecord::Base)

        ActiveRecord::Base.connection.create_table :foos
        ActiveRecord::Base.connection.create_table :bars, id: :string
      end

      let(:klass) do
        Class.new(::ActiveRecord::Base) do
          has_many :bars
        end
      end

      it "generates RBS" do
        expect(subject).to eq(<<~RBS)
          module GeneratedAssociationMethods
            def bars: () -> Bar::ActiveRecord_Associations_CollectionProxy

            def bars=: (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar]) -> (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar])

            def bar_ids: () -> Array[::String]

            def bar_ids=: (Array[::String]) -> Array[::String]
          end
        RBS
      end
    end

    context "When the model has a has_one association" do
      before do
        stub_const "Bar", Class.new(::ActiveRecord::Base)

        ActiveRecord::Base.connection.create_table :foos
        ActiveRecord::Base.connection.create_table :bars
      end

      let(:klass) do
        Class.new(::ActiveRecord::Base) do
          has_one :bar
        end
      end

      it "generates RBS" do
        expect(subject).to eq(<<~RBS)
          module GeneratedAssociationMethods
            def bar: () -> Bar?

            def bar=: (Bar?) -> Bar?

            def build_bar: (?untyped) -> Bar

            def create_bar: (untyped) -> Bar

            def create_bar!: (untyped) -> Bar

            def reload_bar: () -> Bar?
          end
        RBS
      end
    end

    context "When the model has a belongs_to association" do
      before do
        stub_const "Bar", Class.new(::ActiveRecord::Base)

        ActiveRecord::Base.connection.create_table :foos
        ActiveRecord::Base.connection.create_table :bars
      end

      context "When the association is default" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            belongs_to :bar
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedAssociationMethods
              def bar: () -> Bar

              def bar=: (Bar?) -> Bar?

              def reload_bar: () -> Bar?
            end
          RBS
        end
      end

      context "When the association is optional" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            belongs_to :bar, optional: true
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedAssociationMethods
              def bar: () -> Bar?

              def bar=: (Bar?) -> Bar?

              def reload_bar: () -> Bar?
            end
          RBS
        end
      end

      context "When the association is polymorphic" do
        let(:klass) do
          Class.new(::ActiveRecord::Base) do
            belongs_to :bar, polymorphic: true
          end
        end

        it "generates RBS" do
          expect(subject).to eq(<<~RBS)
            module GeneratedAssociationMethods
              def bar: () -> untyped

              def bar=: (untyped?) -> untyped?

              def reload_bar: () -> untyped?

              def build_bar: (untyped) -> untyped

              def create_bar: (untyped) -> untyped

              def create_bar!: (untyped) -> untyped
            end
          RBS
        end
      end
    end
  end
end
