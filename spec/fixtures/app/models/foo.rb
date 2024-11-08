# frozen_string_literal: true

class Foo < ActiveRecord::Base
  attribute :status, :integer

  enum :status, %i[active archived]

  scope :active, -> { where(active: true) }

  has_many :bars

  has_secure_password
end
