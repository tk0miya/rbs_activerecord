# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator do
  describe "#generate" do
    subject { described_class.new(klass).generate }

    attr_reader :tempdir

    before do
      stub_const "Bar", Class.new(::ActiveRecord::Base)
      allow(Rails).to receive(:root).and_return(Pathname.new("spec/fixtures/"))

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
      ActiveRecord::Base.connection.create_table :foos do |t|
        t.string :name
      end
      ActiveRecord::Base.connection.create_table :bars, id: :string

      # Load the model after the database initialization
      require_relative "../fixtures/app/models/foo"
    end

    let(:klass) { Foo } # see ../fixtures/app/models/foo.rb

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

            def status: () -> ::Integer

            def status=: (::Integer) -> ::Integer
          end

          module GeneratedAssociationMethods
            def bars: () -> Bar::ActiveRecord_Associations_CollectionProxy

            def bars=: (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar]) -> (Bar::ActiveRecord_Associations_CollectionProxy | Array[::Bar])

            def bar_ids: () -> Array[::String]

            def bar_ids=: (Array[::String]) -> Array[::String]

            def entryable: () -> untyped

            def entryable=: (untyped?) -> untyped?

            def reload_entryable: () -> untyped?

            def build_entryable: (untyped) -> untyped

            def create_entryable: (untyped) -> untyped

            def create_entryable!: (untyped) -> untyped
          end
          module GeneratedSecurePasswordMethods
            attr_reader password: String?

            attr_accessor password_confirmation: String

            attr_accessor password_challenge: String

            def password=: (String) -> String

            def password_salt: () -> String

            def authenticate_password: (String) -> (instance | false)

            alias authenticate authenticate_password
          end

          module GeneratedDelegatedTypeInstanceMethods
            def entryable_class: () -> (Message | Comment)

            def entryable_name: () -> String

            def message?: () -> bool

            def message: () -> Message?

            def message_id: () -> ::Integer?

            def comment?: () -> bool

            def comment: () -> Comment?

            def comment_id: () -> ::Integer?
          end
          module GeneratedDelegatedTypeScopeMethods[Relation]
            def messages: () -> Relation

            def comments: () -> Relation
          end
          module GeneratedEnumInstanceMethods
            def active!: () -> void

            def active?: () -> bool

            def archived!: () -> void

            def archived?: () -> bool
          end
          module GeneratedEnumScopeMethods[Relation]
            def active: () -> Relation

            def not_active: () -> Relation

            def archived: () -> Relation

            def not_archived: () -> Relation
          end
          module GeneratedScopeMethods[Relation]
            def active: () -> Relation
          end

          class ActiveRecord_Relation < ::ActiveRecord::Relation
            include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
            include GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
            include GeneratedEnumScopeMethods[ActiveRecord_Relation]
            include GeneratedScopeMethods[ActiveRecord_Relation]
            include ::Enumerable[Foo]
          end

          class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
            include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
            include GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
            include GeneratedEnumScopeMethods[ActiveRecord_Relation]
            include GeneratedScopeMethods[ActiveRecord_Relation]
            include ::Enumerable[Foo]
          end

          extend GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
          extend GeneratedEnumScopeMethods[ActiveRecord_Relation]
          extend GeneratedScopeMethods[ActiveRecord_Relation]

          include GeneratedAttributeMethods
          include GeneratedAssociationMethods
          include GeneratedDelegatedTypeInstanceMethods
          include GeneratedEnumInstanceMethods
          include GeneratedSecurePasswordMethods
        end
      RBS
    end
  end
end
