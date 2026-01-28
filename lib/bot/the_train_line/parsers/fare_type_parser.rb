# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class FareTypeParser < BaseParser
        def parse
          json_data['fareTypes'].each_with_object({}) do |(id, type_hash), fare_types|
            fare_types[id] = FareType.new(id: type_hash['id'], code: type_hash['code'], name: type_hash['name'])
          end
        end
      end
    end
  end
end
