# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class FareParser < BaseParser
        def parse
          json_data['journeySearch']['fares'].each_with_object({}) do |(id, fare_hash), fares|
            type_id = fare_hash['fareType']
            fare = Fare.new(id: fare_hash['id'], type_id: type_id, name: context[:fare_types][type_id].name)
            fares[id] = fare
          end
        end
      end
    end
  end
end
