# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Associations do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model).generate }

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
            def bars: () -> ::Bar::ActiveRecord_Associations_CollectionProxy

            def bars=: (::Bar::ActiveRecord_Associations_CollectionProxy | ::Array[::Bar]) -> (::Bar::ActiveRecord_Associations_CollectionProxy | ::Array[::Bar])

            def bar_ids: () -> ::Array[::String]

            def bar_ids=: (::Array[::String]) -> ::Array[::String]
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
            def bar: () -> ::Bar?

            def bar=: (::Bar?) -> ::Bar?

            def build_bar: (?untyped) -> ::Bar

            def create_bar: (untyped) -> ::Bar

            def create_bar!: (untyped) -> ::Bar

            def reload_bar: () -> ::Bar?

            def reset_bar: () -> void

            def bar_changed?: () -> bool

            def bar_previously_changed?: () -> bool
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
              def bar: () -> ::Bar

              def bar=: (::Bar?) -> ::Bar?

              def build_bar: (untyped) -> ::Bar

              def create_bar: (untyped) -> ::Bar

              def create_bar!: (untyped) -> ::Bar

              def reload_bar: () -> ::Bar?

              def reset_bar: () -> void
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
              def bar: () -> ::Bar?

              def bar=: (::Bar?) -> ::Bar?

              def build_bar: (untyped) -> ::Bar

              def create_bar: (untyped) -> ::Bar

              def create_bar!: (untyped) -> ::Bar

              def reload_bar: () -> ::Bar?

              def reset_bar: () -> void
            end
          RBS
        end
      end

      context "When the association is polymorphic" do
        before do
          stub_const "Foo", klass
        end

        context "When the polymorphic owners not found" do
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

                def reset_bar: () -> void
              end
            RBS
          end
        end

        context "When the polymorphic owners found (single)" do
          before do
            stub_const "Owner", owner
          end

          let(:klass) do
            Class.new(::ActiveRecord::Base) do
              belongs_to :baz, polymorphic: true
            end
          end
          let(:owner) do
            Class.new(::ActiveRecord::Base) do
              has_many :foos, as: :baz
            end
          end

          it "generates RBS" do
            expect(subject).to eq(<<~RBS)
              module GeneratedAssociationMethods
                def baz: () -> Owner

                def baz=: (Owner?) -> Owner?

                def reload_baz: () -> Owner?

                def reset_baz: () -> void
              end
            RBS
          end
        end

        context "When the polymorphic owners found (multiple)" do
          before do
            stub_const "Owner1", owner1
            stub_const "Owner2", owner2
          end

          let(:klass) do
            Class.new(::ActiveRecord::Base) do
              belongs_to :qux, polymorphic: true
            end
          end
          let(:owner1) do
            Class.new(::ActiveRecord::Base) do
              has_many :foos, as: :qux
            end
          end
          let(:owner2) do
            Class.new(::ActiveRecord::Base) do
              has_many :foos, as: :qux
            end
          end

          it "generates RBS" do
            expect(subject).to eq(<<~RBS)
              module GeneratedAssociationMethods
                def qux: () -> (Owner1 | Owner2)

                def qux=: ((Owner1 | Owner2)?) -> (Owner1 | Owner2)?

                def reload_qux: () -> (Owner1 | Owner2)?

                def reset_qux: () -> void
              end
            RBS
          end
        end
      end
    end

    context "When the model has a has_and_belongs_to_many association" do
      before do
        stub_const "Bar", Class.new(::ActiveRecord::Base)
        klass.instance_eval do
          has_and_belongs_to_many :bars
        end

        ActiveRecord::Base.connection.create_table :foos
        ActiveRecord::Base.connection.create_table :bars
      end

      let(:klass) { Class.new(::ActiveRecord::Base) }

      it "generates RBS" do
        expect(subject).to eq(<<~RBS)
          module GeneratedAssociationMethods
            def bars: () -> Bar::ActiveRecord_Associations_CollectionProxy

            def bars=: (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar]) -> (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar])

            def bar_ids: () -> Array[::Integer]

            def bar_ids=: (Array[::Integer]) -> Array[::Integer]
          end
        RBS
      end
    end
  end
end
