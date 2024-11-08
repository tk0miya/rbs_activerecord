# frozen_string_literal: true

require "active_record"
require "tempfile"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Generator::Enum::InstanceMethods do
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
          module GeneratedEnumInstanceMethods
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
            module GeneratedEnumInstanceMethods
              def active!: () -> void

              def active?: () -> bool

              def archived!: () -> void

              def archived?: () -> bool
            end
          RBS
        end
      end

      context "When the enum has instance_methods option" do
        context "When the value of instance_methods option is false" do
          let(:content) do
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

        context "When the value of instance_methods option is true" do
          let(:content) do
            <<~RUBY
              class User < ActiveRecord::Base
                enum :status, [:active, :archived], instance_methods: true
              end
            RUBY
          end

          it "generates RBS" do
            expect(subject).to eq <<~RBS
              module GeneratedEnumInstanceMethods
                def active!: () -> void

                def active?: () -> bool

                def archived!: () -> void

                def archived?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def status_active!: () -> void

                def status_active?: () -> bool

                def status_archived!: () -> void

                def status_archived?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def prefix_active!: () -> void

                def prefix_active?: () -> bool

                def prefix_archived!: () -> void

                def prefix_archived?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def prefix_active!: () -> void

                def prefix_active?: () -> bool

                def prefix_archived!: () -> void

                def prefix_archived?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def active_status!: () -> void

                def active_status?: () -> bool

                def archived_status!: () -> void

                def archived_status?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def active_suffix!: () -> void

                def active_suffix?: () -> bool

                def archived_suffix!: () -> void

                def archived_suffix?: () -> bool
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
              module GeneratedEnumInstanceMethods
                def active_suffix!: () -> void

                def active_suffix?: () -> bool

                def archived_suffix!: () -> void

                def archived_suffix?: () -> bool
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
            module GeneratedEnumInstanceMethods
              def active!: () -> void

              def active?: () -> bool

              def archived!: () -> void

              def archived?: () -> bool
            end
          RBS
        end
      end
    end
  end
end
