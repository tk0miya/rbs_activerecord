# frozen_string_literal: true

require "rails"

module RbsActiverecord
  class InstallGenerator < Rails::Generators::Base
    def create_raketask
      create_file "lib/tasks/rbs_activerecord.rake", <<~RUBY
        # frozen_string_literal: true

        begin
          require "rbs_activerecord/rake_task"

          RbsActiverecord::RakeTask.new do |task|
            # Make accessor methods for columns pure.
            # task.pure_accessors = true
          end
        rescue LoadError
          # failed to load rbs_activerecord. Skip to load rbs_activerecord tasks.
        end
      RUBY
    end
  end
end
