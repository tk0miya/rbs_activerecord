# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :rubocop

namespace :rbs do
  task :generate do
    sh "rbs-inline", "--opt-out", "--output=sig", "lib"
  end
end
