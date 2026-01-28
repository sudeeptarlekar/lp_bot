# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class BaseParser
        attr_accessor :json_data, :context

        def initialize(json_data, context = {})
          @json_data = json_data
          @context = context
        end

        def parse
          raise NotImplementedError, 'Subclasses must implement the method'
        end
      end
    end
  end
end
