# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class TransportModeParser < BaseParser
        def parse
          json_data['transportModes'].each_with_object({}) do |(id, mode_hash), modes|
            modes[id] =
              TransportMode.new(id: id, code: mode_hash['code'], name: mode_hash['name'], mode: mode_hash['mode'])
          end
        end
      end
    end
  end
end
