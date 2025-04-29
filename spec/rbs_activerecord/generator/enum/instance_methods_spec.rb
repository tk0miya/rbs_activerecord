# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Enum::InstanceMethods do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model, declarations).generate }

    before do
      stub_const("User", klass)

      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
      ActiveRecord::Base.connection.create_table :users, id: false do |t|
        t.integer :status
        t.string :timezone
      end
    end

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(ActiveRecord::Base) }
    let(:declarations) { RbsActiverecord::Parser.parse(code) }

    context "when the model has no enum" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
          end
        RUBY
      end

      it "generates RBS" do
        expect(subject).to eq <<~RBS
          module GeneratedEnumInstanceMethods
          end
        RBS
      end
    end

    context "when the model has an enum" do
      context "when the enum has no options" do
        let(:code) do
          <<~RUBY
            class User < ActiveRecord::Base
              enum :status, [:active, :archived]
            end
          RUBY
        end

        it "generates RBS" do
          expect(subject).to eq <<~RBS
            module GeneratedEnumInstanceMethods
              def status: () -> ::String

              def status=: (::String) -> ::String
                         | (::Integer) -> ::Integer

              def active!: () -> void

              def active?: () -> bool

              def archived!: () -> void

              def archived?: () -> bool
            end
          RBS
        end
      end

      context "when the enum has instance_methods option" do
        context "when the value of instance_methods option is false" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], instance_methods: false
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
              end
            RBS
          end
        end

        context "when the value of instance_methods option is true" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], instance_methods: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def active!: () -> void

                def active?: () -> bool

                def archived!: () -> void

                def archived?: () -> bool
              end
            RBS
          end
        end
      end

      context "when the enum has prefix option" do
        context "when the value of prefix option is true" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], prefix: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def status_active!: () -> void

                def status_active?: () -> bool

                def status_archived!: () -> void

                def status_archived?: () -> bool
              end
            RBS
          end
        end

        context "when the value of prefix option is a String" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], prefix: "prefix"
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def prefix_active!: () -> void

                def prefix_active?: () -> bool

                def prefix_archived!: () -> void

                def prefix_archived?: () -> bool
              end
            RBS
          end
        end

        context "when the value of prefix option is a Symbol" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], prefix: :prefix
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def prefix_active!: () -> void

                def prefix_active?: () -> bool

                def prefix_archived!: () -> void

                def prefix_archived?: () -> bool
              end
            RBS
          end
        end
      end

      context "when the enum has suffix option" do
        context "when the value of suffix option is true" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], suffix: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def active_status!: () -> void

                def active_status?: () -> bool

                def archived_status!: () -> void

                def archived_status?: () -> bool
              end
            RBS
          end
        end

        context "when the value of suffix option is a String" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], suffix: "suffix"
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def active_suffix!: () -> void

                def active_suffix?: () -> bool

                def archived_suffix!: () -> void

                def archived_suffix?: () -> bool
              end
            RBS
          end
        end

        context "when the value of suffix option is a Symbol" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], suffix: :suffix
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def status: () -> ::String

                def status=: (::String) -> ::String
                           | (::Integer) -> ::Integer

                def active_suffix!: () -> void

                def active_suffix?: () -> bool

                def archived_suffix!: () -> void

                def archived_suffix?: () -> bool
              end
            RBS
          end
        end
      end

      context "when the enum is defined via keyword args" do
        let(:code) do
          <<~RUBY
            class User < ActiveRecord::Base
              enum :status, active: 0, archived: 1
            end
          RUBY
        end

        it "generates RBS" do
          expect(subject).to eq <<~RBS
            module GeneratedEnumInstanceMethods
              def status: () -> ::String

              def status=: (::String) -> ::String
                         | (::Integer) -> ::Integer

              def active!: () -> void

              def active?: () -> bool

              def archived!: () -> void

              def archived?: () -> bool
            end
          RBS
        end
      end

      context "when the enum contains special characters" do
        let(:code) do
          <<~RUBY
            class User < ActiveRecord::Base
              enum :timezone, ["America/Los_Angels", "America/Denver", "America/Chicago", "America/New_York"]
            end
          RUBY
        end

        it "generates RBS" do
          expect(subject).to eq <<~RBS
            module GeneratedEnumInstanceMethods
              def timezone: () -> ::String

              def timezone=: (::String) -> ::String
                           | (::String) -> ::String

              def America_Los_Angels!: () -> void

              def America_Los_Angels?: () -> bool

              def America_Denver!: () -> void

              def America_Denver?: () -> bool

              def America_Chicago!: () -> void

              def America_Chicago?: () -> bool

              def America_New_York!: () -> void

              def America_New_York?: () -> bool
            end
          RBS
        end
      end
    end
  end
end
