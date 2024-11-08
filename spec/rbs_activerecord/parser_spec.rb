# frozen_string_literal: true

require "rbs_activerecord"
require "tempfile"

RSpec.describe RbsActiverecord::Parser do
  describe ".parse" do
    subject { described_class.parse(filename) }

    let(:filename) do
      Tempfile.open do |f|
        f.write(content)
        f.path
      end
    end
    let(:content) do
      <<~RUBY
        class User < ActiveRecord::Base
          scope :active, -> { where(active: true) }
          enum :status, [ :active, :archived ]
        end
      RUBY
    end

    it "returns declarations" do
      expect(subject).to include "User"

      decls = subject["User"]
      expect(decls.size).to eq 2
      expect(decls[0].name).to eq :scope
      expect(decls[1].name).to eq :enum
    end
  end

  describe ".eval_node" do
    subject { described_class.eval_node(node) }

    let(:node) { body.first }
    let(:body) { parsed_result.value.statements.body }
    let(:parsed_result) { Prism.parse(code) }

    context "When node is Prism::NilNode" do
      let(:code) { "nil" }

      it { is_expected.to eq nil }
    end

    context "When node is Prism::TrueNode" do
      let(:code) { "true" }

      it { is_expected.to eq true }
    end

    context "When node is Prism::FalseNode" do
      let(:code) { "false" }

      it { is_expected.to eq false }
    end

    context "When node is Prism::SymbolNode" do
      let(:code) { ":symbol" }

      it { is_expected.to eq :symbol }
    end

    context "When node is Prism::IntegerNode" do
      let(:code) { "12345" }

      it { is_expected.to eq 12_345 }
    end

    context "When node is Prism::StringNode" do
      let(:code) { "'String'" }

      it { is_expected.to eq "String" }
    end

    context "When node is Prism::ArrayNode" do
      let(:code) { "[1, 2, 3]" }

      it { is_expected.to eq [1, 2, 3] }
    end

    context "When node is Prism::HashNode" do
      let(:code) { "{ foo: 1, bar: 2}" }

      it { is_expected.to eq({ foo: 1, bar: 2 }) }
    end

    context "When node is Prism::KeywordHashNode" do
      let(:code) { "foo(kw1: true, kw2: false)" }
      let(:node) { body.first.arguments.arguments.first }

      it { is_expected.to eq({ kw1: true, kw2: false }) }
    end
  end
end
