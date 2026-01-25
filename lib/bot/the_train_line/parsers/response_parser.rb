# frozen_string_literal: true

module Bot
  module TheTrainLine
    class ResponseParser
      attr_reader :json_data, :departure_time, :journeys, :alternatives, :fares, :fare_types, :transports

      def initialize(json_data, departure_time)
        @json_data = json_data
        @departure_time = departure_time
      end

      def parse_fare_types
        @fare_types = json_data['fareTypes'].each_with_object({}) do |(id, type), hash|
          hash[id] = FareType.from_json(type)
        end
      end
    end
  end
end
