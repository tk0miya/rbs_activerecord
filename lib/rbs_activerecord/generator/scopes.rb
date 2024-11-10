# frozen_string_literal: true

module RbsActiverecord
  class Generator
    class Scopes
      attr_reader :model #: RbsActiverecord::Model
      attr_reader :declarations #: Array[Prism::CallNode]

      # @rbs model: RbsActiverecord::Model
      # @rbs delarations: Hash[String, Array[Prism::CallNode]]
      def initialize(model, declarations) #: void
        @model = model
        @declarations = declarations.fetch(model.klass.name, [])
      end

      def generate #: String
        <<~RBS.strip
          module GeneratedScopeMethods[Relation]
            #{scopes.map { |node| scope(node) }.join("\n")}
          end
        RBS
      end

      private

      def scopes #: Array[Prism::CallNode]
        declarations.select { |node| node.name == :scope }
      end

      # @rbs node: Prism::CallNode
      def scope(node) #: String # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
        args = node.arguments&.arguments
        return "" unless args

        name = args[0] #: Prism::SymbolNode
        body = args[1]

        case body
        when Prism::LambdaNode
          params = lambda_params(body)
          "def #{name.value}: (#{params}) -> Relation"
        when Prism::CallNode
          if (body.name == :lambda || body.name == :proc) && body.block
            block = body.block #: Prism::BlockNode
            params = lambda_params(block)
            "def #{name.value}: (#{params}) -> Relation"
          else
            "def #{name.value}: (?) -> Relation"
          end
        else
          "def #{name.value}: (?) -> Relation"
        end
      end

      # @rbs node: Prism::LambdaNode | Prism::BlockNode
      def lambda_params(node) #: String  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        # @type var params: Prism::ParametersNode?
        params = node.parameters&.parameters # steep:ignore
        return "" unless params

        args = [] #: Array[String]

        params.requireds.each do |required|
          case required
          when Prism::RequiredParameterNode
            args << "untyped #{required.name}"
          when Prism::MultiTargetNode
            args << "untyped"
          end
        end
        params.optionals.each do |optional|
          args << "?untyped #{optional.name}"
        end
        case params.rest
        when Prism::RestParameterNode
          args << "*untyped #{params.rest.name}"
        when Prism::ImplicitRestNode
          args << "*untyped"
        end
        params.keywords.each do |keyword|
          case keyword
          when Prism::RequiredKeywordParameterNode
            args << "#{keyword.name}: untyped"
          when Prism::OptionalKeywordParameterNode
            args << "?#{keyword.name}: untyped"
          end
        end
        case params.keyword_rest
        when Prism::KeywordRestParameterNode
          args << "**untyped #{params.keyword_rest.name}"
        when Prism::NoKeywordsParameterNode
          args << "**untyped"
        end

        args.join(", ")
      end
    end
  end
end
