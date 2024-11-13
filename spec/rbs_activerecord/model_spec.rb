# frozen_string_literal: true

require "active_record"
require "rbs_activerecord"

RSpec.describe RbsActiverecord::Model do
  describe "#filename" do
    subject { model.filename }

    before do
      stub_const("User", klass)
    end

    let(:model) { described_class.new(klass) }
    let(:klass) { Class.new(::ActiveRecord::Base) }

    it { is_expected.to eq "app/models/user.rb" }
  end

  describe "#parents" do
    subject { model.parents }

    let(:model) { described_class.new(klass) }
    let(:klass) { Class.new(parent) }

    context "When the parent is an abstract model" do
      let(:parent) do
        Class.new(::ActiveRecord::Base) do
          self.abstract_class = true
        end
      end

      it { is_expected.to eq [] }
    end

    context "When the parent is a ActiveRecord::Base" do
      let(:parent) { ::ActiveRecord::Base }

      it { is_expected.to eq [] }
    end

    context "When the parent is a concrete model" do
      let(:parent) { Class.new(::ActiveRecord::Base) }

      it { is_expected.to eq [parent] }
    end
  end
end
