# frozen_string_literal: true

require 'money'

module Bot
  module TheTrainLine
    class ResponseParser
      attr_reader :json_data, :origin, :destination, :departure_time,
                  :journeys, :fares, :fare_types, :transports, :legs, :sections

      def initialize(json_data, departure_time, origin, destination)
        @json_data = json_data
        @departure_time = departure_time

        @origin = origin
        @destination = destination
      end

      def parse
        parse_fare_types
        parse_transport_modes
        parse_fares
        parse_legs
        parse_sections
        parse_journeys
      end

      def parse_fare_types
        @fare_types = json_data['fareTypes'].each_with_object({}) do |(id, type_hash), fare_types|
          fare_types[id] = FareType.new(id: type_hash['id'], code: type_hash['code'], name: type_hash['name'])
        end
      end

      def parse_fares
        @fares = json_data['journeySearch']['fares'].each_with_object({}) do |(id, fare_hash), fares|
          type_id = fare_hash['fareType']
          fare = Fare.new(id: fare_hash['id'], type_id: type_id, name: fare_types[type_id].name)
          fares[id] = fare
        end
      end

      def parse_legs
        @legs = json_data['journeySearch']['legs'].each_with_object({}) do |(leg_id, leg_hash), legs|
          leg = Leg.new(id: leg_id, mode_name: transports[leg_hash['transportMode']].mode)
          legs[leg_id] = leg
        end
      end

      def parse_transport_modes
        @transports = json_data['transportModes'].each_with_object({}) do |(id, mode_hash), modes|
          modes[id] = TransportMode.from_json(mode_hash)
        end
      end

      def parse_sections
        @sections = json_data['journeySearch']['sections'].each_with_object({}) do |(section_id, section_hash), sections|
          sections[section_id] = Section.new(id: section_id, alternatives: section_hash['alternatives'])
        end
      end

      def parse_journeys
        @journeys = json_data['journeySearch']['journeys'].each_with_object({}) do |(journey_id, journey_hash), segments|
          # next if DateTime.parse(journey_hash['departAt']) < departure_time

          segment = Segment.new(id: journey_hash['id'], origin: origin, destination: destination,
                                departure_at: journey_hash['departAt'], arrival_at: journey_hash['arriveAt'])

          segment.assign_legs(journey_hash['legs'].map { |leg_id| legs[leg_id] })
          segment.fares = journey_hash['sections'].map { |section_id| sections[section_id].alternatives }
                                                  .flatten
                                                  .uniq
                                                  .map { |alt_id| build_segment_fares(json_data['journeySearch']['alternatives'][alt_id]) }
          segments[journey_id] = segment
        end
      end

      def build_segment_fares(alternative_hash)
        # TODO: It is assumed that query will only be for single person
        fare_name = fares[alternative_hash['fares'].first].name
        price = alternative_hash['fullPrice']['amount']
        currency = alternative_hash['fullPrice']['currencyCode']

        SegmentFare.new(fare_name: fare_name, price: price, currency: currency)
      end
    end
  end
end
