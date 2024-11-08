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
end
