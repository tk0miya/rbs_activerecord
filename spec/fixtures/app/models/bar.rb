# frozen_string_literal: true

require_relative "enum_concern"

class Bar < ActiveRecord::Base
  include EnumConcern
end
