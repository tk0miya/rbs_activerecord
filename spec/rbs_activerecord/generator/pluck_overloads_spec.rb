# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::PluckOverloads do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model).generate }

    before do
      stub_const "Foo", klass

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    end

    let(:model) { RbsActiverecord::Model.new(klass) }

    context "When model has nullable and non-nullable columns" do
      before do
        ActiveRecord::Base.connection.create_table :foos do |t|
          t.integer :age
          t.string :name, null: false
        end
      end

      let(:klass) { Class.new(::ActiveRecord::Base) }

      it "generates RBS" do
        expect(subject).to eq(<<~RBS)
          module GeneratedPluckOverloads
            def pluck: (:id | "id") -> ::Array[::Integer]
                     | (:age | "age") -> ::Array[::Integer?]
                     | (:name | "name") -> ::Array[::String]
                     | ...
          end
        RBS
      end
    end

    context "When model has enum columns" do
      before do
        ActiveRecord::Base.connection.create_table :foos do |t|
          t.integer :role, null: false
        end
      end

      let(:klass) do
        Class.new(::ActiveRecord::Base) do
          enum :role, %i[admin user]
        end
      end

      it "generates RBS" do
        expect(subject).to eq(<<~RBS)
          module GeneratedPluckOverloads
            def pluck: (:id | "id") -> ::Array[::Integer]
                     | (:role | "role") -> ::Array[::String]
                     | ...
          end
        RBS
      end
    end
  end
end
