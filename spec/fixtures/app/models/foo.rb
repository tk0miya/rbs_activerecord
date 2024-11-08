# frozen_string_literal: true

class Foo < ActiveRecord::Base
  attribute :status, :integer

  delegated_type :entryable, types: %w[Message Comment]

  enum :status, %i[active archived]

  scope :active, -> { where(active: true) }

  has_many :bars

  has_secure_password
end
