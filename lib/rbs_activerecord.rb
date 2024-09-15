# frozen_string_literal: true

require_relative "rbs_activerecord/utils"

require_relative "rbs_activerecord/generator"
require_relative "rbs_activerecord/generator/associations"
require_relative "rbs_activerecord/generator/attributes"
require_relative "rbs_activerecord/model"
require_relative "rbs_activerecord/version"

module RbsActiverecord
  class Error < StandardError; end
  # Your code goes here...
end
