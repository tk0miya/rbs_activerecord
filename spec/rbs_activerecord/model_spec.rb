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
end
