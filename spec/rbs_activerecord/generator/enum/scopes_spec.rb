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

              def archived: () -> Relation
            end
          RBS
        end
      end

      context "When the enum has scope option" do
        context "When the value of scope option is false" do
          let(:content) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], scope: false
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

        context "When the value of scope option is true" do
          let(:content) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], scope: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumScopeMethods[Relation]
                def active: () -> Relation

                def archived: () -> Relation
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

                def status_archived: () -> Relation
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

                def prefix_archived: () -> Relation
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

                def prefix_archived: () -> Relation
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

                def archived_status: () -> Relation
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

                def archived_suffix: () -> Relation
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

                def archived_suffix: () -> Relation
              end
            RBS
          end
        end
      end
    end
  end
end