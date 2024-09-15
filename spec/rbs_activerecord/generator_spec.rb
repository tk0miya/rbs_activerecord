# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator do
  describe "#generate" do
    subject { described_class.new(klass).generate }

    before do
      stub_const("Foo", klass)
      stub_const "Bar", Class.new(::ActiveRecord::Base)

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
      ActiveRecord::Base.connection.create_table :foos do |t|
        t.string :name
      end
      ActiveRecord::Base.connection.create_table :bars, id: :string
    end

    let(:klass) do
      Class.new(ActiveRecord::Base) do
        has_many :bars
      end
    end

    it "generates RBS" do
      expect(subject).to eq <<~RBS
        class Foo < ::ActiveRecord::Base
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

          module GeneratedAssociationMethods
            def bars: () -> Bar::ActiveRecord_Associations_CollectionProxy

            def bars=: (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar]) -> (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar])

            def bar_ids: () -> Array[::String]

            def bar_ids=: (Array[::String]) -> Array[::String]
          end

          class ActiveRecord_Relation < ::ActiveRecord::Relation
            include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
            include ::Enumerable[Foo]
          end

          class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
            include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
            include ::Enumerable[Foo]
          end

          include GeneratedAttributeMethods
          include GeneratedAssociationMethods
        end
      RBS
    end
  end
end
