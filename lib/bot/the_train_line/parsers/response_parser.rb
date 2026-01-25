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
          fare = Fare.new(id: fare_hash['id'], type: fare_types[fare_hash['fareType']])
          fares[id] = fare
        end
      end

      def parse_legs
        @legs = json_data['journeySearch']['legs'].each_with_object({}) do |(leg_id, leg_hash), legs|
          leg = Leg.new(id: leg_id, transport_mode: transports[leg_hash['transportMode']])
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
          next if DateTime.parse(journey_hash['departAt']) < departure_time

          segment = Segment.from_json(journey_hash)

          segment.departure_station = origin
          segment.arrival_station = destination
          segment.legs = journey_hash['legs'].map { |leg_id| legs[leg_id] }
          segment.sections = journey_hash['sections'].map { |section_id| sections[section_id] }
          segment.fares = journey_hash['sections'].map { |section_id| sections[section_id].alternatives }
                                                  .flatten
                                                  .uniq
                                                  .map { |alt_id| json_data['journeySearch']['alternatives'][alt_id] }
                                                  .map do |alternative|
                                                    SegmentFare.new(fare: fares[alternative['fares'].first],
                                                                    price: alternative['fullPrice']['amount'], currency: alternative['fullPrice']['currencyCode'])
          end
          segments[journey_id] = segment
        end
      end
    end
  end
end
