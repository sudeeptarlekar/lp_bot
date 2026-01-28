# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class Orchestrator
        attr_accessor :json_data, :context

        def initialize(json_data:, departure_time:, origin:, destination:)
          @json_data = json_data
          @context = {
            departure_time: departure_time,
            origin: origin,
            destination: destination
          }
        end

        def parse_entities
          context[:fare_types] = FareTypeParser.new(json_data).parse
          context[:transport_modes] = TransportModeParser.new(json_data).parse
          context[:fares] = FareParser.new(json_data, context).parse
          context[:legs] = LegParser.new(json_data, context).parse
          context[:sections] = SectionParser.new(json_data, context).parse
          context[:segments] = JourneyParser.new(json_data, context).parse
        end
      end
    end
  end
end
