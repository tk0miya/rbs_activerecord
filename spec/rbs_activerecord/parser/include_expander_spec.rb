# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Parser::IncludeExpander do
  describe ".expand" do
    subject { described_class.expand(model, declarations) }

    let(:model) { RbsActiverecord::Model.new(klass) }
    let(:klass) { Class.new(ActiveRecord::Base) }
    let(:declarations) { RbsActiverecord::Parser.parse(code) }

    context "when the class not including modules" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
            scope :active, -> { }
            scope :inactive, -> { }
          end
        RUBY
      end

      it "removes the include call from the declarations" do
        subject
        expect(subject).to include("User")
        expect(subject["User"].map(&:name)).to eq(%i[scope scope])
      end
    end

    context "when the class including modules" do
      let(:code) do
        <<~RUBY
          class User < ActiveRecord::Base
            scope :active, -> { }
            include Included
            scope :inactive, -> { }
          end
        RUBY
      end

      context "when the included module is not found" do
        it "removes the include call from the declarations" do
          subject
          expect(subject).to include("User")
          expect(subject["User"].map(&:name)).to eq(%i[scope scope])
        end
      end

      context "when the included module is found" do
        before do
          stub_const("Included", included)
          allow(Object).to receive(:const_source_location).with("Included").and_return([filename, -1])
        end

        let(:included) do
          Module.new do
            extend ActiveSupport::Concern
          end
        end
        let(:filename) do
          Tempfile.open do |f|
            f.write(included_code)
            f.path
          end
        end

        context "when the included module does not have included block" do
          let(:included_code) do
            <<~RUBY
              module Included
                extend ActiveSupport::Concern
              end
            RUBY
          end

          it "removes the include call from the declarations" do
            subject
            expect(subject).to include("User")
            expect(subject["User"].map(&:name)).to eq(%i[scope scope])
          end
        end

        context "when the included module has included block" do
          let(:included_code) do
            <<~RUBY
              module Included
                extend ActiveSupport::Concern

                included do
                  enum :status, [:active, :archived]
                end
              end
            RUBY
          end

          it "removes the include call from the declarations" do
            subject
            expect(subject).to include("User")
            expect(subject["User"].map(&:name)).to eq(%i[scope enum scope])
          end
        end
      end
    end
  end
end
