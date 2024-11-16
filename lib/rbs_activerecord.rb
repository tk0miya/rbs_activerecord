# frozen_string_literal: true

require_relative "rbs_activerecord/utils"

require_relative "rbs_activerecord/generator"
require_relative "rbs_activerecord/generator/active_storage/instance_methods"
require_relative "rbs_activerecord/generator/active_storage/scopes"
require_relative "rbs_activerecord/generator/associations"
require_relative "rbs_activerecord/generator/attributes"
require_relative "rbs_activerecord/generator/delegated_type/instance_methods"
require_relative "rbs_activerecord/generator/delegated_type/scopes"
require_relative "rbs_activerecord/generator/enum/base"
require_relative "rbs_activerecord/generator/enum/instance_methods"
require_relative "rbs_activerecord/generator/enum/scopes"
require_relative "rbs_activerecord/generator/pluck_overloads"
require_relative "rbs_activerecord/generator/scopes"
require_relative "rbs_activerecord/generator/secure_password"
require_relative "rbs_activerecord/model"
require_relative "rbs_activerecord/parser"
require_relative "rbs_activerecord/parser/evaluator"
require_relative "rbs_activerecord/parser/include_expander"
require_relative "rbs_activerecord/parser/include_expander/module"
require_relative "rbs_activerecord/parser/visitor"
require_relative "rbs_activerecord/version"

module RbsActiverecord
  class Error < StandardError; end
  # Your code goes here...
end
