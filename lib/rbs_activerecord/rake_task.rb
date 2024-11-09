# frozen_string_literal: true

require "rake/tasklib"

module RbsActiverecord
  class RakeTask < Rake::TaskLib
    attr_accessor :name, :signature_root_dir

    # @rbs name: Symbol
    # @rbs &block: (RakeTask) -> void
    def initialize(name = :'rbs:activerecord', &block) #: void
      super()

      @name = name
      @signature_root_dir = Rails.root / "sig/activerecord"

      block&.call(self)

      define_setup_task
      define_clean_task
      define_generate_task
    end

    def define_setup_task #: void
      desc "Run all tasks of rbs_activerecord"

      deps = [:"#{name}:clean", :"#{name}:generate"]
      task("#{name}:setup" => deps)
    end

    def define_clean_task #: void
      desc "Clean RBS files for ActiveRecord models"
      task "#{name}:clean" do
        signature_root_dir.rmtree if signature_root_dir.exist?
      end
    end

    def define_generate_task #: void  # rubocop:disable Metrics/AbcSize
      desc "Generate RBS files for ActiveRecord models"
      task("#{name}:generate": :environment) do
        require "rbs_activerecord" # load RbsActiverecord lazily

        Rails.application.eager_load!

        signature_root_dir.mkpath

        ActiveRecord::Base.descendants.each do |klass|
          next if klass.abstract_class?
          next unless klass.connection.table_exists?(klass.table_name)

          rbs = Generator.new(klass).generate
          next unless rbs

          path = signature_root_dir / "app/models/#{klass.name.underscore}.rbs"
          path.dirname.mkpath
          path.write(rbs)
        end
      end
    end
  end
end
