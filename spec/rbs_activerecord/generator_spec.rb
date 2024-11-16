# frozen_string_literal: true

require "spec_helper"
require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator do
  describe "#generate" do
    subject { described_class.new(klass).generate }

    before do
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    end

    context "General case" do
      attr_reader :tempdir

      before do
        stub_const "Bar", Class.new(::ActiveRecord::Base)
        allow(Rails).to receive(:root).and_return(Pathname.new("spec/fixtures/"))

        ActiveRecord::Base.connection.create_table :foos
        ActiveRecord::Base.connection.create_table :bars, id: :string
        ActiveRecord::Base.connection.create_table :parents do |t|
          t.string :name
        end

        # Load the model after the database initialization
        require_relative "../fixtures/app/models/foo"
      end

      let(:klass) { Foo } # see ../fixtures/app/models/foo.rb

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          class Foo < ::Parent
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

              def avatar_attachment: () -> ActiveStorage::Attachment?

              def avatar_attachment=: (ActiveStorage::Attachment?) -> ActiveStorage::Attachment?

              def build_avatar_attachment: (?untyped) -> ActiveStorage::Attachment

              def create_avatar_attachment: (untyped) -> ActiveStorage::Attachment

              def create_avatar_attachment!: (untyped) -> ActiveStorage::Attachment

              def reload_avatar_attachment: () -> ActiveStorage::Attachment?

              def reset_avatar_attachment: () -> void

              def avatar_attachment_changed?: () -> bool

              def avatar_attachment_previously_changed?: () -> bool

              def avatar_blob: () -> ActiveStorage::Blob?

              def avatar_blob=: (ActiveStorage::Blob?) -> ActiveStorage::Blob?

              def build_avatar_blob: (?untyped) -> ActiveStorage::Blob

              def create_avatar_blob: (untyped) -> ActiveStorage::Blob

              def create_avatar_blob!: (untyped) -> ActiveStorage::Blob

              def reload_avatar_blob: () -> ActiveStorage::Blob?

              def reset_avatar_blob: () -> void

              def avatar_blob_changed?: () -> bool

              def avatar_blob_previously_changed?: () -> bool

              def entryable: () -> untyped

              def entryable=: (untyped?) -> untyped?

              def reload_entryable: () -> untyped?

              def reset_entryable: () -> void
            end

            module GeneratedActiveStorageInstanceMethods
              def avatar: () -> ::ActiveStorage::Attached::One

              def avatar=: (::ActionDispatch::Http::UploadedFile) -> ::ActionDispatch::Http::UploadedFile
                         | (::Rack::Test::UploadedFile) -> ::Rack::Test::UploadedFile
                         | (::ActiveStorage::Blob) -> ::ActiveStorage::Blob
                         | (::String) -> ::String
                         | ({ io: ::IO, filename: ::String, content_type: ::String? }) -> { io: ::IO, filename: ::String, content_type: ::String? }
                         | (nil) -> nil
            end
            module GeneratedActiveStorageScopeMethods[Relation]
              def with_attached_avatar: () -> Relation
            end
            module GeneratedPluckOverloads
              def pluck: (:id | "id") -> ::Array[::Integer]
                       | (:name | "name") -> ::Array[::String?]
                       | (::Symbol | ::String | ::Arel::Nodes::t column) -> ::Array[untyped]
                       | (*::Symbol | ::String | ::Arel::Nodes::t columns) -> ::Array[::Array[untyped]]
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

            module GeneratedCollectionProxyInstanceMethods[Model, PrimaryKey]
              def build: (?ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                       | (Array[ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> Array[Model]

              def create: (?ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                        | (Array[ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> Array[Model]

              def create!: (?ActiveRecord::Associations::CollectionProxy::_EachPair attributes) ?{ () -> untyped } -> Model
                         | (Array[ActiveRecord::Associations::CollectionProxy::_EachPair] attributes) ?{ () -> untyped } -> Array[Model]

              def reload: () -> Array[Model]

              def replace: (Array[Model]) -> void

              def delete: (*Model | PrimaryKey) -> Array[Model]

              def destroy: (*Model | PrimaryKey) -> Array[Model]

              def <<: (*Model | Array[Model]) -> self

              def prepend: (*Model | Array[Model]) -> self
            end

            class ActiveRecord_Relation < ::ActiveRecord::Relation
              include ::Enumerable[Foo]
              include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
              include GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
              include GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
              include GeneratedEnumScopeMethods[ActiveRecord_Relation]
              include GeneratedScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedEnumScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedScopeMethods[ActiveRecord_Relation]
              include GeneratedPluckOverloads
            end

            class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
              include ::Enumerable[Foo]
              include ::ActiveRecord::Relation::Methods[Foo, ::Integer]
              include GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
              include GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
              include GeneratedEnumScopeMethods[ActiveRecord_Relation]
              include GeneratedScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedEnumScopeMethods[ActiveRecord_Relation]
              include ::Parent::GeneratedScopeMethods[ActiveRecord_Relation]
              include GeneratedPluckOverloads
              include GeneratedCollectionProxyInstanceMethods[Foo, ::Integer]
            end

            extend ::ActiveRecord::Base::ClassMethods[Foo, Foo::ActiveRecord_Relation, ::Integer]
            extend GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
            extend GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
            extend GeneratedEnumScopeMethods[ActiveRecord_Relation]
            extend GeneratedScopeMethods[ActiveRecord_Relation]
            extend ::Parent::GeneratedActiveStorageScopeMethods[ActiveRecord_Relation]
            extend ::Parent::GeneratedDelegatedTypeScopeMethods[ActiveRecord_Relation]
            extend ::Parent::GeneratedEnumScopeMethods[ActiveRecord_Relation]
            extend ::Parent::GeneratedScopeMethods[ActiveRecord_Relation]
            extend GeneratedPluckOverloads

            include GeneratedActiveStorageInstanceMethods
            include GeneratedAttributeMethods
            include GeneratedAssociationMethods
            include GeneratedDelegatedTypeInstanceMethods
            include GeneratedEnumInstanceMethods
            include GeneratedSecurePasswordMethods
          end
        RBS
      end
    end

    context "When the target model has composite primary keys" do
      before do
        stub_const "Foo", klass
        allow(Rails).to receive(:root).and_return(Pathname.new("spec/fixtures/"))

        ActiveRecord::Base.connection.create_table :foos do |t|
          t.integer :store_id
          t.string :sku
        end
      end

      let(:klass) do
        Class.new(ActiveRecord::Base) do
          self.primary_key = %i[store_id sku]
        end
      end

      it "generates RBS" do
        expect(subject).to include "include ::ActiveRecord::Relation::Methods[Foo, [ ::Integer | ::String ]]"
        expect(subject).to include(
          "extend ::ActiveRecord::Base::ClassMethods[Foo, Foo::ActiveRecord_Relation, [ ::Integer | ::String ]]"
        )
      end
    end

    context "When the target model includes a concern module having 'included' block" do
      before do
        allow(Rails).to receive(:root).and_return(Pathname.new("spec/fixtures/"))

        ActiveRecord::Base.connection.create_table :bars do |t|
          t.integer :status
        end
        require_relative "../fixtures/app/models/bar"
      end

      let(:klass) { Bar } # see ../fixtures/app/models/bar.rb

      it "generates RBS" do
        expect(subject).to include "def active: () -> Relation"
        expect(subject).to include "def archived: () -> Relation"
      end
    end
  end
end
