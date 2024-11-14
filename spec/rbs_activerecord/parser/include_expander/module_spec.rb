# frozen_string_literal: true

require "rbs_activerecord"

RSpec.describe RbsActiverecord::Parser::IncludeExpander::Module do
  describe "#concern?" do
    subject { described_class.new(mod, name).concern? }

    let(:mod) { Module.new }
    let(:name) { "Mod" }

    context "When the module is not a concern" do
      it { is_expected.to be false }
    end

    context "When the module is a concern" do
      before do
        mod.extend ActiveSupport::Concern
      end

      it { is_expected.to be true }
    end
  end

  describe "#included_blocks" do
    subject { described_class.new(mod, name).included_blocks }

    let(:mod) { Module.new }
    let(:name) { "Mod" }

    context "When the module is not a concern" do
      it { is_expected.to eq [] }
    end

    context "When the module is a concern" do
      before do
        mod.extend ActiveSupport::Concern
        expect(Object).to receive(:const_source_location).with(name).and_return([filename, 0])
      end

      let(:filename) do
        Tempfile.open do |f|
          f.write(content)
          f.path
        end
      end

      context "When the module has no included blocks" do
        let(:content) do
          <<~RUBY
            module Mod
            end
          RUBY
        end

        it { is_expected.to eq [] }
      end

      context "When the module has included blocks" do
        let(:content) do
          <<~RUBY
            module Mod
              extend ActiveSupport::Concern

              included do
              end

              included do
              end

              extended do
              end
            end
          RUBY
        end

        it "Collects included_blocks" do
          expect(subject).to contain_exactly(instance_of(Prism::CallNode), instance_of(Prism::CallNode))
          expect(subject[0].name).to eq :included
          expect(subject[1].name).to eq :included
        end
      end
    end
  end
end
