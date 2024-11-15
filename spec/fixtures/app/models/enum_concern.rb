# frozen_string_literal: true

module EnumConcern
  extend ActiveSupport::Concern

  included do
    enum :status, %i[active archived]
  end
end
