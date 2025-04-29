# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Enum::Scopes do
  include RbsActiverecord::Utils

  describe "#generate" do
    subject { format described_class.new(model, declarations).generate }

    before do
      stub_const("User", klass)
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
          module GeneratedEnumScopeMethods[Relation]
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
            module GeneratedEnumScopeMethods[Relation]
              def active: () -> Relation

              def not_active: () -> Relation

              def archived: () -> Relation

              def not_archived: () -> Relation
            end
          RBS
        end
      end

      context "when the enum has scopes option" do
        context "when the value of scopes option is false" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], scopes: false
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumScopeMethods[Relation]
              end
            RBS
          end
        end

        context "when the value of scopes option is true" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], scopes: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumScopeMethods[Relation]
                def active: () -> Relation

                def not_active: () -> Relation

                def archived: () -> Relation

                def not_archived: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def status_active: () -> Relation

                def not_status_active: () -> Relation

                def status_archived: () -> Relation

                def not_status_archived: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def prefix_active: () -> Relation

                def not_prefix_active: () -> Relation

                def prefix_archived: () -> Relation

                def not_prefix_archived: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def prefix_active: () -> Relation

                def not_prefix_active: () -> Relation

                def prefix_archived: () -> Relation

                def not_prefix_archived: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def active_status: () -> Relation

                def not_active_status: () -> Relation

                def archived_status: () -> Relation

                def not_archived_status: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def active_suffix: () -> Relation

                def not_active_suffix: () -> Relation

                def archived_suffix: () -> Relation

                def not_archived_suffix: () -> Relation
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
              module GeneratedEnumScopeMethods[Relation]
                def active_suffix: () -> Relation

                def not_active_suffix: () -> Relation

                def archived_suffix: () -> Relation

                def not_archived_suffix: () -> Relation
              end
            RBS
          end
        end
      end

      context "when the enum is defined via Hash" do
        context "when the enum has no options" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, { active: 0, archived: 1 }
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumScopeMethods[Relation]
                def active: () -> Relation

                def not_active: () -> Relation

                def archived: () -> Relation

                def not_archived: () -> Relation
              end
            RBS
          end
        end

        context "when the enum has options" do
          let(:code) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, { active: 0, archived: 1 }, suffix: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumScopeMethods[Relation]
                def active_status: () -> Relation

                def not_active_status: () -> Relation

                def archived_status: () -> Relation

                def not_archived_status: () -> Relation
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
            module GeneratedEnumScopeMethods[Relation]
              def active: () -> Relation

              def not_active: () -> Relation

              def archived: () -> Relation

              def not_archived: () -> Relation
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
            module GeneratedEnumScopeMethods[Relation]
              def America_Los_Angels: () -> Relation

              def not_America_Los_Angels: () -> Relation

              def America_Denver: () -> Relation

              def not_America_Denver: () -> Relation

              def America_Chicago: () -> Relation

              def not_America_Chicago: () -> Relation

              def America_New_York: () -> Relation

              def not_America_New_York: () -> Relation
            end
          RBS
        end
      end
    end
  end
end
