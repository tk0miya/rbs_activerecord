# frozen_string_literal: true

require_relative "parent"

class Foo < Parent
  attribute :status, :integer

  delegated_type :entryable, types: %w[Message Comment]

  enum :status, %i[active archived]

  scope :active, -> { where(active: true) }

  has_many :bars

  has_one_attached :avatar

  has_secure_password
end
