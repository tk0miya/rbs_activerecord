# frozen_string_literal: true

class Foo < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  has_many :bars

  has_secure_password
end
