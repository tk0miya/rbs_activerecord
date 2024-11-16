# frozen_string_literal: true

module RbsActiverecord
  module Parser
    class IncludeExpander
      class Module
        attr_reader :mod #: ::Module
        attr_reader :name #: String

        # @rbs mod: ::Module
        # @rbs name: String
        def initialize(mod, name) #: void
          @mod = mod
          @name = name
        end

        def concern? #: bool
          mod.is_a?(::ActiveSupport::Concern)
        end

        def included_blocks #: Array[Prism::CallNode]
          return [] unless concern?

          declarations.select { |node| node.name == :included }
        end

        private

        # @rbs @declarations: Array[Prism::CallNode]

        def declarations #: Array[Prism::CallNode]
          @declarations ||= begin
            path = source_location
            return [] unless path && File.exist?(path)

            declarations = Parser.parse_file(path)
            declarations.fetch(name, [])
          end
        end

        def source_location #: String?
          Object.const_source_location(name)&.fetch(0)
        end
      end
    end
  end
end
