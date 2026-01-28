# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class JourneyParser < BaseParser
        def parse
          json_data['journeySearch']['journeys'].each_with_object({}) do |(journey_id, journey_hash), segments|
            next if DateTime.parse(journey_hash['departAt']) < context[:departure_time]

            segment = Segment.new(id: journey_hash['id'], origin: context[:origin], destination: context[:destination],
                                  depart_at: journey_hash['departAt'], arrive_at: journey_hash['arriveAt'])

            segment.assign_legs(journey_hash['legs'].map { |leg_id| context[:legs][leg_id] })
            segment.fares = journey_hash['sections'].map { |section_id| context[:sections][section_id].alternatives }
                                                    .flatten
                                                    .uniq
                                                    .map { |alt_id| build_segment_fares(json_data['journeySearch']['alternatives'][alt_id]) }

            segments[journey_id] = segment
          end
        end

        private

        def build_segment_fares(alternative_hash)
          # TODO: It is assumed that query will only be for single person
          fare_name = context[:fares][alternative_hash['fares'].first].name
          price = alternative_hash['fullPrice']['amount']
          currency = alternative_hash['fullPrice']['currencyCode']

          SegmentFare.new(fare_name: fare_name, price: price, currency: currency)
        end
      end
    end
  end
end
