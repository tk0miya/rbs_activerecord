# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Attributes do
  describe "#generate" do
    subject { described_class.new(model).generate }

    before do
      stub_const "Foo", klass

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    end

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(::ActiveRecord::Base) }

    context "with a standard model" do
      before do
        ActiveRecord::Base.connection.create_table :foos, id: false do |t|
          t.string :name
        end
      end

      it "generates RBS" do
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

      it "generates RBS" do
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
  end
end