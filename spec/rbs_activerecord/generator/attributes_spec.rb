# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Attributes do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model, pure_accessors:).generate }

    before do
      stub_const "Foo", klass

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    end

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(ActiveRecord::Base) }

    context "when pure_accessors is false" do
      let(:pure_accessors) { false }

      context "with a standard model" do
        before do
          ActiveRecord::Base.connection.create_table :foos, id: false do |t|
            t.string :name
          end
        end

        it "generates RBS" do # rubocop:disable RSpec/ExampleLength
          expect(subject).to eq(<<~RBS)
            module GeneratedAttributeMethods
              def name: () -> ::String?

              def name=: (::String?) -> ::String?

              def name?: () -> bool

              def name_changed?: () -> bool

              def name_change: () -> [ ::String?, ::String? ]

              def name_will_change!: () -> void

              def name_was: () -> ::String?

              def name_previously_changed?: () -> bool

              def name_previous_change: () -> ::Array[::String?]?

              def name_previously_was: () -> ::String?

              def name_before_last_save: () -> ::String?

              def name_change_to_be_saved: () -> ::Array[::String?]?

              def name_in_database: () -> ::String?

              def saved_change_to_name: () -> ::Array[::String?]?

              def saved_change_to_name?: () -> bool

              def will_save_change_to_name?: () -> bool

              def restore_name!: () -> void

              def clear_name_change: () -> void
            end
          RBS
        end
      end

      context "with a model having a non-nullable column" do
        before do
          ActiveRecord::Base.connection.create_table :foos, id: false do |t|
            t.string :name, null: false
          end
        end

        it "generates RBS" do # rubocop:disable RSpec/ExampleLength
          expect(subject).to eq(<<~RBS)
            module GeneratedAttributeMethods
              def name: () -> ::String

              def name=: (::String) -> ::String

              def name?: () -> bool

              def name_changed?: () -> bool

              def name_change: () -> [ ::String?, ::String? ]

              def name_will_change!: () -> void

              def name_was: () -> ::String?

              def name_previously_changed?: () -> bool

              def name_previous_change: () -> ::Array[::String?]?

              def name_previously_was: () -> ::String?

              def name_before_last_save: () -> ::String?

              def name_change_to_be_saved: () -> ::Array[::String?]?

              def name_in_database: () -> ::String?

              def saved_change_to_name: () -> ::Array[::String?]?

              def saved_change_to_name?: () -> bool

              def will_save_change_to_name?: () -> bool

              def restore_name!: () -> void

              def clear_name_change: () -> void
            end
          RBS
        end
      end

      context "with a model having many kinds of columns" do
        before do
          ActiveRecord::Base.connection.create_table :foos, id: false do |t|
            t.integer  :attr1
            t.float    :attr2
            t.decimal  :attr3
            t.string   :attr4
            t.text     :attr5
            t.binary   :attr6
            t.datetime :attr7
            t.date     :attr8
            t.time     :attr9
            t.boolean  :attr10
          end
        end

        it "generates RBS" do
          expect(subject).to include("def attr1: () -> ::Integer?")
          expect(subject).to include("def attr2: () -> ::Float?")
          expect(subject).to include("def attr3: () -> ::BigDecimal?")
          expect(subject).to include("def attr4: () -> ::String?")
          expect(subject).to include("def attr5: () -> ::String?")
          expect(subject).to include("def attr6: () -> ::String?")
          expect(subject).to include("def attr7: () -> ::ActiveSupport::TimeWithZone?")
          expect(subject).to include("def attr8: () -> ::Date?")
          expect(subject).to include("def attr9: () -> ::Time?")
          expect(subject).to include("def attr10: () -> bool")
        end
      end

      context "with a model having attributes via ActiveRecord::Attributes" do
        before do
          ActiveRecord::Base.connection.create_table :foos

          klass.instance_eval do
            attribute :name, :string
            attribute :age, :integer
          end
        end

        it "generates RBS" do # rubocop:disable RSpec/ExampleLength
          expect(subject).to eq(<<~RBS)
            module GeneratedAttributeMethods
              def id: () -> ::Integer

              def id=: (::Integer) -> ::Integer

              def id?: () -> bool

              def id_changed?: () -> bool

              def id_change: () -> [ ::Integer?, ::Integer? ]

              def id_will_change!: () -> void

              def id_was: () -> ::Integer?

              def id_previously_changed?: () -> bool

              def id_previous_change: () -> ::Array[::Integer?]?

              def id_previously_was: () -> ::Integer?

              def id_before_last_save: () -> ::Integer?

              def id_change_to_be_saved: () -> ::Array[::Integer?]?

              def id_in_database: () -> ::Integer?

              def saved_change_to_id: () -> ::Array[::Integer?]?

              def saved_change_to_id?: () -> bool

              def will_save_change_to_id?: () -> bool

              def restore_id!: () -> void

              def clear_id_change: () -> void

              def name: () -> ::String

              def name=: (::String) -> ::String

              def age: () -> ::Integer

              def age=: (::Integer) -> ::Integer
            end
          RBS
        end
      end

      context "with a model having aliases" do
        before do
          ActiveRecord::Base.connection.create_table :foos

          klass.instance_eval do
            alias_attribute :new_id, :id
          end
        end

        it "generates RBS" do # rubocop:disable RSpec/ExampleLength
          expect(subject).to eq(<<~RBS)
            module GeneratedAttributeMethods
              def id: () -> ::Integer

              def id=: (::Integer) -> ::Integer

              def id?: () -> bool

              def id_changed?: () -> bool

              def id_change: () -> [ ::Integer?, ::Integer? ]

              def id_will_change!: () -> void

              def id_was: () -> ::Integer?

              def id_previously_changed?: () -> bool

              def id_previous_change: () -> ::Array[::Integer?]?

              def id_previously_was: () -> ::Integer?

              def id_before_last_save: () -> ::Integer?

              def id_change_to_be_saved: () -> ::Array[::Integer?]?

              def id_in_database: () -> ::Integer?

              def saved_change_to_id: () -> ::Array[::Integer?]?

              def saved_change_to_id?: () -> bool

              def will_save_change_to_id?: () -> bool

              def restore_id!: () -> void

              def clear_id_change: () -> void

              alias new_id id

              alias new_id= id=

              alias new_id? id?

              alias new_id_changed? id_changed?

              alias new_id_change id_change

              alias new_id_will_change! id_will_change!

              alias new_id_was id_was

              alias new_id_previously_changed? id_previously_changed?

              alias new_id_previous_change id_previous_change

              alias new_id_previously_was id_previously_was

              alias new_id_before_last_save id_before_last_save

              alias new_id_change_to_be_saved id_change_to_be_saved

              alias new_id_in_database id_in_database

              alias saved_change_to_new_id saved_change_to_id

              alias saved_change_to_new_id? saved_change_to_id?

              alias will_save_change_to_new_id? will_save_change_to_id?

              alias restore_new_id! restore_id!

              alias clear_new_id_change clear_id_change
            end
          RBS
        end
      end
    end

    context "when pure_accessors is true" do
      let(:pure_accessors) { true }

      context "with a standard model" do
        before do
          ActiveRecord::Base.connection.create_table :foos, id: false do |t|
            t.string :name
          end
        end

        it "generates RBS" do # rubocop:disable RSpec/ExampleLength
          expect(subject).to eq(<<~RBS)
            module GeneratedAttributeMethods
              %a{pure}
              def name: () -> ::String?

              def name=: (::String?) -> ::String?

              def name?: () -> bool

              def name_changed?: () -> bool

              def name_change: () -> [ ::String?, ::String? ]

              def name_will_change!: () -> void

              def name_was: () -> ::String?

              def name_previously_changed?: () -> bool

              def name_previous_change: () -> ::Array[::String?]?

              def name_previously_was: () -> ::String?

              def name_before_last_save: () -> ::String?

              def name_change_to_be_saved: () -> ::Array[::String?]?

              def name_in_database: () -> ::String?

              def saved_change_to_name: () -> ::Array[::String?]?

              def saved_change_to_name?: () -> bool

              def will_save_change_to_name?: () -> bool

              def restore_name!: () -> void

              def clear_name_change: () -> void
            end
          RBS
        end
      end
    end
  end
end
