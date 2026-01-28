# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class LegParser < BaseParser
        def parse
          json_data['journeySearch']['legs'].each_with_object({}) do |(leg_id, leg_hash), legs|
            leg = Leg.new(id: leg_id, mode_name: context[:transport_modes][leg_hash['transportMode']].mode)
            legs[leg_id] = leg
          end
        end
      end
    end
  end
end
