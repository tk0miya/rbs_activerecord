# frozen_string_literal: true

require "active_record"
require "tempfile"
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
    let(:declarations) { RbsActiverecord::Parser.parse(filename) }

    let(:filename) do
      Tempfile.open do |f|
        f.write(content)
        f.path
      end
    end

    context "When the model has no enum" do
      let(:content) do
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

    context "When the model has an enum" do
      context "When the enum has no options" do
        let(:content) do
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

      context "When the enum has scopes option" do
        context "When the value of scopes option is false" do
          let(:content) do
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

        context "When the value of scopes option is true" do
          let(:content) do
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

      context "When the enum has prefix option" do
        context "When the value of prefix option is true" do
          let(:content) do
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

        context "When the value of prefix option is a String" do
          let(:content) do
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

        context "When the value of prefix option is a Symbol" do
          let(:content) do
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

      context "When the enum has suffix option" do
        context "When the value of suffix option is true" do
          let(:content) do
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

        context "When the value of suffix option is a String" do
          let(:content) do
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

        context "When the value of suffix option is a Symbol" do
          let(:content) do
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

      context "When the enum is defined via keyword args" do
        let(:content) do
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
    end
  end
end
